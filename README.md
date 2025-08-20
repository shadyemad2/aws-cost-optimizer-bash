# 🚀 AWS Cloud Cost Optimizer (Bash + AWS CLI)

This project is a **Bash Shell Script** that connects to AWS via the **AWS CLI** to analyze your environment and detect unused or underutilized resources that may be generating unnecessary costs.  

The script is lightweight, requires no dependencies other than AWS CLI, and provides a **menu-driven report** to help you optimize your AWS bill.

---

## 📌 Features

The script currently checks for the following resources:

- **EC2 Instances** → Lists all instances with type, state, and launch time.  
- **Unattached EBS Volumes** → Volumes not attached to any instance (still incurring charges).  
- **S3 Buckets** → Lists all buckets in your account.  
- **Unattached Elastic IPs (EIPs)** → Public IPs allocated but not associated with any instance.  
- **Unused Load Balancers** → Load balancers with no target groups or empty target groups.  
- **Unattached ENIs (Elastic Network Interfaces)** → Available ENIs not in use.  
- **Idle NAT Gateways** → NAT gateways with no traffic in the last 1 hour (costly if unused).  

---

## 📥 Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/aws-cost-optimizer-bash.git
cd aws-cost-optimizer-bash

---

## Example Output

======================================
     AWS Cloud Cost Optimizer
======================================
 Checking AWS identity...
AWS CLI is configured and working.

 EC2 Instances:
-------------------------------------------------
| InstanceId    | InstanceType | State   | Launch|
-------------------------------------------------
| i-0123456789  | t2.micro     | running | 2025-07-20T10:30:00Z |

 Unattached Volumes:
-------------------------------------------------
| vol-0abc12345 | 20 GiB | available |

 Unattached Elastic IPs:
-------------------------------------------------
| 3.92.14.122   | eipalloc-0abcd12345 |

 Unused Load Balancers:
Load Balancer with no target groups: arn:aws:elasticloadbalancing:...

 Unattached ENIs:
-------------------------------------------------
| eni-0ab12345  | Available |

 Idle NAT Gateways (no traffic in last 1 hour):
 NAT Gateway nat-0ab12345 has no traffic in the last hour.



---

## 👨‍💻 Author
- **Shady Emad** – Junior System Administrator  
  Passionate about Linux, AWS, Docker, Kubernetes, and Infrastructure Automation.
