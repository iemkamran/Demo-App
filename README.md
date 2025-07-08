---

#  Fullstack Application Deployment on EKS with CI/CD and Monitoring

This project sets up a Production-ready fullstack application using:

* **Terraform** for provisioning AWS infrastructure (EKS, IAM, VPC)
* **GitHub Actions** for CI/CD pipelines
* **Docker** for containerization
* **Kubernetes (EKS)** for orchestration
* **Prometheus + Grafana** for monitoring

---

##  1. Infrastructure Setup with Terraform

We provision the EKS cluster using **modular Terraform**, enabling reusable, secure, and scalable infrastructure for **staging** and **production**.

###  Features

* Custom VPC with subnets, routes, and Internet Gateway
* Managed EKS cluster with 3 nodes
* IAM roles for users and node groups
* Cluster Autoscaler (via Helm)
* Remote state in S3 with locking using DynamoDB
* Environment separation (`staging`, `production`)

###  Directory Structure

```
terraform/
├── environments/
│   ├── staging/
│   └── production/
├── modules/
│   ├── eks/
│   ├── vpc/
│   └── iam/
```

### Prerequisites

* Terraform 1.3+
* AWS CLI configured (`~/.aws/credentials`)
* Pre-created S3 bucket and DynamoDB table for state

###  Deploy Infrastructure

```bash
cd terraform/environments/staging
terraform init
terraform plan
terraform apply
```

Repeat for production environment.

---

##  2. Application Setup – Docker + GitHub Actions

This fullstack application (React frontend + Express backend) is containerized and deployed via **CI/CD pipelines**.

###  Project Structure

```
.github/workflows/ci-cd.yaml  # GitHub Actions workflow
backend/                      # Backend service (Node.js)
frontend/                     # React frontend
manifests/                    # Kubernetes YAML manifests
```

###  CI/CD Pipeline Flow

1. **Developer pushes to `main` branch**
2. **GitHub Actions**:

   * Build & tag Docker images
   * Push images to DockerHub
   * Replace tags in K8s manifests
   * Deploy to EKS using `kubectl`

###  Required GitHub Secrets

| Secret Name       | Description                        |
| ----------------- | ---------------------------------- |
| `DOCKER_USERNAME` | Docker Hub username                |
| `DOCKER_PASSWORD` | Docker Hub token/password          |
| `KUBE_CONFIG`     | Base64 of `~/.kube/config` for EKS |

To set `KUBE_CONFIG`:

```bash
cat ~/.kube/config | base64
```

Add the output to GitHub → Settings → Secrets → Actions

---

###  Image Tagging Example

Commit SHA: `abc123`

GitHub Actions will:

```yaml
image: iemkamran/frontend:abc123
```

ensuring **traceability and reproducibility**.

---

##  3. Kubernetes Deployment (Manifests)

Manifests are manually created for:

* Backend (`backend-deployment.yaml`)
* Frontend (`frontend-deployment.yaml`)
* Ingress (`frontend-ingress.yaml`)

```bash
kubectl apply -f manifests/
```

The app will be exposed via a LoadBalancer or Ingress (NGINX).

---

##  4. Monitoring with Prometheus + Grafana

A Helm chart installs a full monitoring stack.

###  Components

| Component          | Port | Description                   |
| ------------------ | ---- | ----------------------------- |
| Prometheus         | 9090 | Metrics collection & alerting |
| Grafana            | 3000 | Dashboards & visualization    |
| Node Exporter      | 9100 | Host-level metrics            |
| Kube-State-Metrics | 8080 | Kubernetes object states      |

###  Helm Chart Layout

```
prometheus-helm/
├── dashboards/                  # Grafana dashboards JSONs
├── templates/                   # K8s manifests
├── values.yaml
```

###  Install Monitoring Stack

```bash
helm upgrade --install prometheus ./prometheus-helm \
  --namespace monitoring --create-namespace
```

###  Grafana Login

```
Username: admin
Password: admin123
```

Change via `values.yaml`.

---

### Port Forward

Prometheus:

```bash
kubectl -n monitoring port-forward svc/prometheus 9090:80
```

Visit: [http://localhost:9090](http://localhost:9090)

Grafana:

```bash
kubectl -n monitoring port-forward svc/grafana 3000:80
```

Visit: [http://localhost:3000](http://localhost:3000)

---

### Default Dashboards

* Kubernetes Cluster
* Node Exporter Full
* Prometheus Overview

Provisioned from the `dashboards/` folder automatically.

---

## End-to-End Workflow Summary

1. **Developer** pushes code to `main`
2. **GitHub Actions** builds Docker images and pushes them to DockerHub
3. GitHub Actions updates K8s manifests and applies them to EKS
4. **Pods** run inside EKS and are exposed via Ingress or LoadBalancer
5. Prometheus scrapes metrics; Grafana visualizes them
6. Alerts are sent via **Alertmanager**

---

##  Testing

Visit your ingress or load balancer DNS to access the app:

```
http://<your-domain>
```

You should see:

```
Message from Backend:
Hello from Express!
```

