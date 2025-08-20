#!/bin/bash
# Cloud Cost Optimizer - AWS CLI + Bash
# Author: Shady

REGION="us-east-1"   

check_identity() {
    echo " Checking AWS identity..."
    aws sts get-caller-identity --region $REGION || { echo " Error: AWS CLI not configured properly."; exit 1; }
    echo "AWS CLI is configured and working."
}

list_ec2_instances() {
    echo -e "\n EC2 Instances:"
    aws ec2 describe-instances \
        --region $REGION \
        --query "Reservations[*].Instances[*].[InstanceId,InstanceType,LaunchTime,State.Name]" \
        --output table
}

list_unattached_volumes() {
    echo -e "\n Unattached Volumes:"
    aws ec2 describe-volumes \
        --region $REGION \
        --query "Volumes[?length(Attachments)==\`0\`].[VolumeId,Size,State]" \
        --output table
}

list_s3_buckets() {
    echo -e "\n S3 Buckets:"
    aws s3 ls
}

list_unattached_eips() {
    echo -e "\n Unattached Elastic IPs:"
    aws ec2 describe-addresses \
        --region $REGION \
        --query "Addresses[?AssociationId==null].[PublicIp,AllocationId]" \
        --output table
}

list_unused_load_balancers() {
    echo -e "\n Unused Load Balancers:"
    for lb in $(aws elbv2 describe-load-balancers --region $REGION --query "LoadBalancers[].LoadBalancerArn" --output text); do
        target_groups=$(aws elbv2 describe-target-groups --region $REGION --load-balancer-arn $lb --query "TargetGroups[].TargetGroupArn" --output text)
        if [ -z "$target_groups" ]; then
            echo "Load Balancer with no target groups: $lb"
        else
            for tg in $target_groups; do
                targets=$(aws elbv2 describe-target-health --region $REGION --target-group-arn $tg --query "TargetHealthDescriptions" --output text)
                if [ -z "$targets" ]; then
                    echo "Load Balancer $lb has empty target group: $tg"
                fi
            done
        fi
    done
}

list_unattached_enis() {
    echo -e "\n Unattached ENIs:"
    aws ec2 describe-network-interfaces \
        --region $REGION \
        --query "NetworkInterfaces[?Status=='available'].[NetworkInterfaceId,Description]" \
        --output table
}

list_idle_nat_gateways() {
    echo -e "\n Idle NAT Gateways (no traffic in last 1 hour):"
    for nat in $(aws ec2 describe-nat-gateways --region $REGION --query "NatGateways[].NatGatewayId" --output text); do
        metrics=$(aws cloudwatch get-metric-statistics \
            --region $REGION \
            --namespace AWS/NATGateway \
            --metric-name BytesOutToDestination \
            --dimensions Name=NatGatewayId,Value=$nat \
            --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ) \
            --end-time $(date -u +%Y-%m-%dT%H:%M:%SZ) \
            --period 3600 \
            --statistics Sum \
            --query "Datapoints[0].Sum" \
            --output text)
        
        if [ "$metrics" == "None" ] || [ "$metrics" == "0" ]; then
            echo " NAT Gateway $nat has no traffic in the last hour."
        fi
    done
}

echo "======================================"
echo "     AWS Cloud Cost Optimizer"
echo "======================================"

check_identity
list_ec2_instances
list_unattached_volumes
list_s3_buckets
list_unattached_eips
list_unused_load_balancers
list_unattached_enis
list_idle_nat_gateways