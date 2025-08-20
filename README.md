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


## Example Output

<img width="1281" height="686" alt="output" src="https://github.com/user-attachments/assets/e2a8d0c9-bf16-42f7-918d-7844131cc14f" />


---

## 👨‍💻 Author
- **Shady Emad** – Junior System Administrator  
  Passionate about Linux, AWS, Docker, Kubernetes, and Infrastructure Automation.
