<!-- ========================================================= -->
<!-- =============== SECURETHECLOUD BANNER =================== -->
<!-- ========================================================= -->
<p align="center">
  <img src="docs/branding/securethecloud.png" width="900" alt="SecureTheCloud Banner">
</p>

<h1 align="center">🌐 Multi-Cloud Compute Architecture</h1>
<p align="center">
  AWS • Azure • GCP • Zero-Trust • Terraform • Secure Automation
</p>

---

<!-- ========================================================= -->
<!-- ======================== BADGES ========================= -->
<!-- ========================================================= -->
<p align="center">

  <img alt="Repo Size" src="https://img.shields.io/github/repo-size/Olagoldstx/multi-cloud-compute-architecture?color=blue&style=for-the-badge">
  <img alt="Stars" src="https://img.shields.io/github/stars/Olagoldstx/multi-cloud-compute-architecture?style=for-the-badge&color=yellow">
  <img alt="License" src="https://img.shields.io/github/license/Olagoldstx/multi-cloud-compute-architecture?style=for-the-badge&color=lightgrey">

  <!-- Cloud Providers -->
  <img alt="AWS" src="https://img.shields.io/badge/AWS-Supported-orange?style=for-the-badge&logo=amazonaws">
  <img alt="Azure" src="https://img.shields.io/badge/Azure-Supported-0078D4?style=for-the-badge&logo=microsoftazure">
  <img alt="GCP" src="https://img.shields.io/badge/GCP-Supported-1A73E8?style=for-the-badge&logo=googlecloud">

  <!-- Tools -->
  <img alt="Terraform" src="https://img.shields.io/badge/Terraform-Automated-844FBA?style=for-the-badge&logo=terraform">

  <!-- Brand -->
  <img alt="SecureTheCloud" src="https://img.shields.io/badge/SecureTheCloud-Labs-red?style=for-the-badge&logo=cloudflare">

</p>

---

<!-- ========================================================= -->
<!-- ================== NAVIGATION BUTTONS =================== -->
<!-- ========================================================= -->
<p align="center">
  <a href="#-repository-tree">
    <img src="https://img.shields.io/badge/Repository_Tree-Click_Here-0A84FF?style=for-the-badge&logo=github">
  </a>

  <a href="docs/theory/">
    <img src="https://img.shields.io/badge/Theory-Documentation-34C759?style=for-the-badge&logo=readthedocs">
  </a>

  <a href="labs/">
    <img src="https://img.shields.io/badge/Labs-Hands_On-FF9500?style=for-the-badge&logo=terminal">
  </a>

  <a href="terraform/">
    <img src="https://img.shields.io/badge/Terraform-Infrastructure-5E5CE6?style=for-the-badge&logo=terraform">
  </a>

  <a href="https://github.com/Olagoldstx">
    <img src="https://img.shields.io/badge/Olagoldstx-GitHub_Profile-8E8E93?style=for-the-badge&logo=github">
  </a>
</p>

---

# 📦 Repository Tree

<details id="-repository-tree">
<summary><strong>📁 Click to Expand Repository Tree</strong></summary>

<br>

📦 **multi-cloud-compute-architecture**

├── 📄 [README.md](README.md)  
├── 🧰 [multicloud_run.sh](multicloud_run.sh)  
├── 📝 [variables.tf](variables.tf)  
├── 📝 [outputs.tf](outputs.tf)  

---

### 🔧 automation/
├── 📂 [automation/aws](automation/aws/)  
│   └── 🏃 [run_lab.sh](automation/aws/run_lab.sh)  
├── 📂 [automation/azure](automation/azure/)  
│   └── 🏃 [run_lab.sh](automation/azure/run_lab.sh)  
├── 📂 [automation/gcp](automation/gcp/)  
│   └── 🏃 [run_lab.sh](automation/gcp/run_lab.sh)  
└── 📂 [automation/common](automation/common/)  
    ├── ⚙️ [backend.sh](automation/common/backend.sh)  
    ├── 🧾 [logger.sh](automation/common/logger.sh)  
    └── 🔍 [validator_core.sh](automation/common/validator_core.sh)  

---

### 📚 docs/
├── 📂 [docs/architecture](docs/architecture/)  
│   ├── 🧩 [multi-cloud-diagram.md](docs/architecture/multi-cloud-diagram.md)  
│   ├── 🛰️ [aws-network.md](docs/architecture/aws-network.md)  
│   ├── 🔷 [azure-network.md](docs/architecture/azure-network.md)  
│   ├── 🌐 [gcp-network.md](docs/architecture/gcp-network.md)  
│   └── 🛡️ [zero-trust-overview.md](docs/architecture/zero-trust-overview.md)  
├── 📂 [docs/theory](docs/theory/)  
│   ├── 📘 [compute-basics.md](docs/theory/compute-basics.md)  
│   ├── 🔐 [zero-trust-concepts.md](docs/theory/zero-trust-concepts.md)  
│   └── 🌍 [terraform-basics.md](docs/theory/terraform-basics.md)  
└── 📂 [docs/binder](docs/binder/)  
    └── 📄 *(future PDF exports)*  

---

### 🏗 terraform/
├── 📂 [terraform/modules](terraform/modules/)  
│   ├── 📂 [aws-ec2](terraform/modules/aws-ec2/)  
│   │   ├── 📝 [main.tf](terraform/modules/aws-ec2/main.tf)  
│   │   ├── 📝 [variables.tf](terraform/modules/aws-ec2/variables.tf)  
│   │   └── 📝 [outputs.tf](terraform/modules/aws-ec2/outputs.tf)  
│   ├── 📂 [aws-network](terraform/modules/aws-network/)  
│   │   ├── 📝 [main.tf](terraform/modules/aws-network/main.tf)  
│   │   ├── 📝 [variables.tf](terraform/modules/aws-network/variables.tf)  
│   │   └── 📝 [outputs.tf](terraform/modules/aws-network/outputs.tf)  
│   ├── 📂 [azure-vm](terraform/modules/azure-vm/)  
│   │   ├── 📝 [main.tf](terraform/modules/azure-vm/main.tf)  
│   │   ├── 📝 [variables.tf](terraform/modules/azure-vm/variables.tf)  
│   │   └── 📝 [outputs.tf](terraform/modules/azure-vm/outputs.tf)  
│   ├── 📂 [azure-network](terraform/modules/azure-network/)  
│   │   ├── 📝 [main.tf](terraform/modules/azure-network/main.tf)  
│   │   ├── 📝 [variables.tf](terraform/modules/azure-network/variables.tf)  
│   │   └── 📝 [outputs.tf](terraform/modules/azure-network/outputs.tf)  
│   ├── 📂 [gcp-compute](terraform/modules/gcp-compute/)  
│   │   ├── 📝 [main.tf](terraform/modules/gcp-compute/main.tf)  
│   │   ├── 📝 [variables.tf](terraform/modules/gcp-compute/variables.tf)  
│   │   └── 📝 [outputs.tf](terraform/modules/gcp-compute/outputs.tf)  
│   └── 📂 [gcp-network](terraform/modules/gcp-network/)  
│       ├── 📝 [main.tf](terraform/modules/gcp-network/main.tf)  
│       ├── 📝 [variables.tf](terraform/modules/gcp-network/variables.tf)  
│       └── 📝 [outputs.tf](terraform/modules/gcp-network/outputs.tf)  

├── 📂 [terraform/stacks](terraform/stacks/)  
│   └── 📂 [multi-cloud-deployment](terraform/stacks/multi-cloud-deployment/)  
│       ├── 📝 [main.tf](terraform/stacks/multi-cloud-deployment/main.tf)  
│       ├── 📝 [variables.tf](terraform/stacks/multi-cloud-deployment/variables.tf)  
│       └── 📝 [outputs.tf](terraform/stacks/multi-cloud-deployment/outputs.tf)  

---

### 🧪 logs/
└── 📄 [run-YYYYMMDD-HHMMSS.log](logs/)

</details>

---

# 📘 Theory Modules

<p align="center">

<a href="docs/theory/compute-basics.md">
  <img src="https://img.shields.io/badge/Compute_Basics-Click_to_Read-0A84FF?style=for-the-badge&logo=azurefunctions">
</a>

<a href="docs/theory/zero-trust-concepts.md">
  <img src="https://img.shields.io/badge/Zero_Trust_Concepts-View_Diagram-34C759?style=for-the-badge&logo=databricks">
</a>

<a href="docs/theory/terraform-basics.md">
  <img src="https://img.shields.io/badge/Terraform_Basics-Start_Here-5E5CE6?style=for-the-badge&logo=terraform">
</a>

</p>

---

# 🧪 Multi-Cloud Hands-On Labs

<p align="center">

<a href="labs/aws/">
  <img src="https://img.shields.io/badge/AWS_Labs-EC2%20|%20Lambda%20|%20EKS-orange?style=for-the-badge&logo=amazonaws">
</a>

<a href="labs/azure/">
  <img src="https://img.shields.io/badge/Azure_Labs-VM%20|%20Functions%20|%20AKS-0078D4?style=for-the-badge&logo=microsoftazure">
</a>

<a href="labs/gcp/">
  <img src="https://img.shields.io/badge/GCP_Labs-Compute%20Engine%20|%20GKE-1A73E8?style=for-the-badge&logo=googlecloud">
</a>

<a href="labs/cross-cloud/">
  <img src="https://img.shields.io/badge/Cross_Cloud-Labs-FF9500?style=for-the-badge&logo=cloudflare">
</a>

</p>

---

# 🏗 Terraform Architecture Navigation

<p align="center">

<a href="terraform/modules/">
  <img src="https://img.shields.io/badge/Modules-Browse-8E8E93?style=for-the-badge&logo=terraform">
</a>

<a href="terraform/stacks/multi-cloud-deployment/">
  <img src="https://img.shields.io/badge/Main_Stack-Multi_Cloud_Deployment-5856D6?style=for-the-badge&logo=terraform">
</a>

<a href="terraform/environments/">
  <img src="https://img.shields.io/badge/Environments-Deploy-ACACAC?style=for-the-badge&logo=icloud">
</a>

</p>

---

# 🔐 Zero-Trust Multi-Cloud Architecture (Mermaid)

```mermaid
flowchart LR
    User -->|Authenticate| IdentityProvider[Identity Provider (IAM / Entra / IAM-GCP)]
    IdentityProvider -->|Short-lived tokens| ZeroTrustGateway

    ZeroTrustGateway --> AWS_EC2
    ZeroTrustGateway --> Azure_VM
    ZeroTrustGateway --> GCP_Compute

    AWS_EC2 --> AWS_SecurityGroup[SG + NACL + IAM Role]
    Azure_VM --> Azure_NSG[NSG + Managed Identity]
    GCP_Compute --> GCP_Firewall[VPC FW + IAM SA]

    AWS_SecurityGroup --> Logs_AWS[CloudTrail + GuardDuty]
    Azure_NSG --> Logs_Azure[Azure Monitor + Defender]
    GCP_Firewall --> Logs_GCP[Cloud Logging + Security Command Center]

    Logs_AWS --> SIEM
    Logs_Azure --> SIEM
    Logs_GCP --> SIEM

    SIEM --> SOC[Security Operations Center]
