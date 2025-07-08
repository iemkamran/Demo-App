# 📊 Kubernetes Monitoring Stack with Prometheus & Grafana (Helm)

This Helm chart deploys a full monitoring stack in Kubernetes, including:

- **Prometheus** for collecting metrics
- **Grafana** for visualization
- **Node Exporter** for host-level metrics
- **Kube-State-Metrics** for Kubernetes object states
- **Auto-provisioned Grafana dashboards** for a plug-and-play experience

---

## 📦 Components

| Component              | Description                                   | Port |
|------------------------|-----------------------------------------------|------|
| Prometheus             | Metrics collection and alerting               | 9090 |
| Grafana                | Metrics dashboards and visualization          | 3000 |
| Node Exporter          | Exposes node-level system metrics             | 9100 |
| Kube-State-Metrics     | Exposes Kubernetes object metrics             | 8080 |

---

## 📁 Folder Structure

``` prometheus-helm/
├── Chart.yaml
├── values.yaml
├── dashboards/
│ ├── argocd.json
│ ├── kubernetes-cluster.json
│ ├── node-exporter.json
│ └── prometheus-overview.json
├── templates/
│ ├── configmap.yaml
│ ├── deployment.yaml
│ ├── service.yaml
│ ├── namespace.yaml
│ ├── node-exporter.yaml
│ ├── kube-state-metrics.yaml
│ ├── grafana-deployment.yaml
│ ├── grafana-service.yaml
│ ├── grafana-datasource-config.yaml
│ ├── grafana-dashboard-config.yaml
│ └── grafana-dashboard-data.yaml

```

---

## 🚀 Installation

### 1. Prerequisites

- Helm 3.x installed
- Kubernetes cluster access (`kubectl` configured)

### 2. Add dashboards

Place your `.json` files in the `dashboards/` folder.

### 3. Deploy using Helm

```bash
helm upgrade --install prometheus ./prometheus-helm --namespace monitoring --create-namespace

```

### 🔐 Grafana Credentials
```
Username	Password
admin	admin123
```

These are configurable via values.yaml.

### 🌐 Access Dashboards
Port-forward Prometheus
```
kubectl -n monitoring port-forward svc/prometheus 9090:80
```
Visit: http://localhost:9090

Port-forward Grafana

```
kubectl -n monitoring port-forward svc/grafana 3000:80
```
Visit: http://localhost:3000

- ✅ Auto-Provisioned Grafana Dashboards
The following dashboards will appear in Grafana:

- ✅ ArgoCD Dashboard

- ✅ Kubernetes Cluster Monitoring

- ✅ Node Exporter Full

- ✅ Prometheus Overview

These are provisioned automatically at startup from the dashboards/ folder.

### 🛠 Customization
- Modify values.yaml to change user/passwords, scrape configs

- Add or remove dashboards from the dashboards/ folder

- Extend Grafana provisioning or add alerts

📜 License
This project is open-source and licensed under the MIT License.

🙋 Support
Open an issue or PR for improvements, feature requests, or bug reports.