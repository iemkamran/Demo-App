---

## README.md


# Fullstack App – Docker + GitHub Actions + Kubernetes

This project is a fullstack application (React frontend + Node/Express backend) deployed using:

- Docker for containerization
- GitHub Actions for CI/CD
- Kubernetes for orchestration



## Project Structure

```

├── .github/workflows/ci-cd.yaml     # CI/CD pipeline (GitHub Actions)
├── backend/                         # Backend source code and Dockerfile
│   ├── Dockerfile
│   └── index.js
├── frontend/                        # React frontend and Dockerfile
│   ├── Dockerfile
│   ├── public/index.html
│   └── src/App.js
├── manifests/                       # Kubernetes manifests
│   ├── backend-deployment.yaml
│   ├── frontend-deployment.yaml
│   └── frontend-ingress.yaml
└── README.md
```

##  Technologies Used

| Layer         | Tech                 |
|---------------|----------------------|
| Frontend      | React                |
| Backend       | Node.js + Express    |
| Container     | Docker               |
| CI/CD         | GitHub Actions       |
| Orchestration | Kubernetes           |
| Deployment    | Manual manifests     |
| Routing       | NGINX Ingress        |

---

##  Setup Instructions

###  1. Clone this Repository

```bash
git clone https://github.com/iemkamran/Demo-App.git
cd app
````

---

###  2. Docker Image Build (Manual - Optional)

You can manually build and push the Docker images:

```bash
# Backend
docker build -t iemkamran/backend:latest ./backend
docker push iemkamran/backend:latest

# Frontend (pass env var for backend API)
docker build -t iemkamran/frontend:latest \
  --build-arg REACT_APP_API_URL=http://backend-service.default.svc.cluster.local:5000 \
  ./frontend

docker push iemkamran/frontend:latest
```

---

###  3. Kubernetes Deployment

#### Apply the Kubernetes manifests

```bash
kubectl apply -f manifests/backend-deployment.yaml
kubectl apply -f manifests/frontend-deployment.yaml
kubectl apply -f manifests/frontend-ingress.yaml
```



## GitHub Actions CI/CD

### Required GitHub Secrets

| Secret            | Description                          |
| ----------------- | ------------------------------------ |
| `DOCKER_USERNAME` | Docker Hub username                  |
| `DOCKER_PASSWORD` | Docker Hub password or access token  |
| `KUBE_CONFIG`     | Base64-encoded `~/.kube/config` file |

To generate `KUBE_CONFIG`:

```bash
cat ~/.kube/config | base64 | pbcopy
```

Then add it as a secret named `KUBE_CONFIG` in GitHub → Settings → Secrets → Actions.

---

### CI/CD Workflow Summary

File: `.github/workflows/ci-cd.yaml`

#### Job 1: `build`

* Checks out code
* Builds Docker images for frontend & backend
* Tags images with:

  * `latest`
  * Commit SHA (`<image>:<commit_sha>`)
* Pushes to Docker Hub

#### Job 2: `deploy` (depends on `build`)

* Downloads and extracts `kubeconfig`
* Replaces image tags in Kubernetes manifests with commit SHA
* Applies Kubernetes manifests using `kubectl apply`

> This ensures every deployment matches the commit ID for traceability.

---

### Example: How image tagging works

If your commit SHA is `abc1234`, GitHub Actions will:

* Tag: `iemkamran/frontend:abc1234`
* Replace image in `frontend-deployment.yaml`:

  ```yaml
  image: iemkamran/frontend:abc1234
  ```

---

## CI/CD Trigger

The pipeline runs **automatically** on every push to the `main` branch:

```yaml
on:
  push:
    branches:
      - main
```

You can change this to also run on pull requests, tags, etc.

---

## Test

* [http://testing.dns](http://testing.dns)
* It should show:

  ```
   Message from Backend:
  Hello from Express!
  ```

---