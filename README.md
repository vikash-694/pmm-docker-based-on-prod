# PMM Multi-Account DB Monitoring

Automate monitoring of Amazon RDS and EC2-hosted databases across multiple AWS accounts using Percona Monitoring and Management (PMM).

## 📌 Features

- 📊 Multi-account RDS and EC2 database monitoring using PMM Server.
- 🔄 Automated AWS credentials rotation via IAM role assumption.
- 📈 Auto-discovery of Amazon RDS instances.
- 🖥️ Discovery support for EC2-hosted DB instances.
- 📦 Docker Compose-based deployment.
- 🔐 Uses least-privilege assumed roles for each AWS account.
- 🛡️ No persistent secrets inside containers (credentials mounted read-only).

## 📁 Directory Structure

```
pmm-multiaccount-db-monitoring/
├── .env.example
├── README.md
├── aws-creds/                # Auto-generated at runtime (excluded via .gitignore)
├── docker-compose.base.yml
├── docker-compose.prod.yml
├── scripts/
│   ├── pmm-assume-multi-roles.sh
│   ├── discover-all-rds.sh
│   ├── discover-all-ec2-dbs.sh
│   └── register-dbs-to-pmm.sh
├── .gitignore
└── LICENSE
```

## 📖 Requirements

- AWS CLI configured in PMM host machine (Account A)
- IAM Roles created and trust relationships established
- PMM Server (Percona Monitoring and Management)
- Docker, Docker Compose installed

## 📋 Notes

- All AWS credentials rotate dynamically using STS AssumeRole.
- Supports monitoring of databases from multiple AWS accounts simultaneously.
- Credentials never stored inside containers.

---

## 🚀 Quickstart

### 1️⃣ Setup Environment Variables

```bash
cp .env.example .env
# Edit .env with your AWS accounts and role ARNs
```

### 2️⃣ Generate AWS Multi-Account Credentials

```bash
bash scripts/pmm-assume-multi-roles.sh
```

### 3️⃣ Deploy PMM Server

```bash
docker compose -f docker-compose.base.yml -f docker-compose.prod.yml up -d
```

### 4️⃣ Discover Databases

```bash
bash scripts/discover-all-rds.sh
bash scripts/discover-all-ec2-dbs.sh
bash scripts/register-dbs-to-pmm.sh
```