# Web Application Project

---

Purpose is to deploy a web application that stores/retrieves information from a database, is scalable and publicly available. Two of the core tenets of this application is to deploy the necessary Infrastructure as Code and a scalable application. What better to do this than Terraform/Terragrunt/Kubernetes...a fabulous combination.

#### Repository Structure and Contents

| Directory      | Description |
|----------------|-------------|
| docs | Repository documentation, images, etc. |
| helm-charts | Assortment of Helm charts for building the web app and supporting cast |
| infrastructure | Terraform modules and Terragrunt live structure for provisioning Infrastructure as Code (IaC) |
| scripts | An assortment of scripts to make life easier on us all |
| src | Where the magic happens: web app and supporting cast are assembled and published from this directory |

## System Architecture

---

#### System Components

| Item | Description |
|------|-------------|
| Web App | Python Flask, multiple routes, health-check, pulls website content from MySQl |
| MySQL DB | provisioned via Terragrunt/Terraform (IaC), hosts website content, includes sample data (blog posts) |
| Kubernetes cluster | provisioned via Terragrunt/Terraform (IaC), hosts the web app and monitoring stack |
| Containerized everything | web-app, supporting monitoring/metrics apps, pushed to private registry (GCR) for better security |
| Container Registry (GCR) | only available inside my GCP project (security boundary), images are scanned for vulnerabilities |
| Elasticsearch, Kibana, Grafana, Heartbeat | core monitoring stack, provisioned via Helm, provides availability, monitoring, and alerting |
| Prometheus stack | provides metrics for cluster (nodes, pods, apps, services), provisioned via Helm (vendor Helm chart) |

![Web App Architecture Diagram](docs/web-app-architecture_wht.png)

## M2A2 _(Monitoring, Metrics, Availability, and Alerting)_

---

#### Infrastructure and Application Monitoring and Availability

* Service Availability - are services up and running as expected? are there any errors (crit,err,warn)?
* Network Availability - can services communicate both vertically and horizontally?
* Security Monitoring - are service components compliant, scanned, vetted?

#### Application Metrics

* (Request) **R**ate - the number of requests, per second, your services are serving.
* (Request) **E**rrors - the number of failed requests per second.
* (Request) **D**uration - The amount of time each request takes expressed as a time interval

#### Alerting

* Service outage - why did the service outage occur? how long was the service outage? root cause? traceability?
* Immediate versus regular notifications - critical prod service down (why isn't it HA?)? need to know ASAP!

## Local Development

---

#### Running the Flask App Locally

* Install requirements (pip install -r requirements.txt)
* Modify the app as needed
* Run the app locally `` MYSQL_DATABASE_PASSWORD=$(cat password.txt) DB_HOST='34.73.152.50' python3 app.py ``

#### Running the Flask App Container

* Build the image locally `` docker -t web-app:test --build-arg DB_PASSWORD=$(cat password.txt) .``
* You will need the password.txt file (git ignores this file, because secrets...)
* Or use the container_manager.sh script (caution: it only works for my GCP project, it is there for an example)
* Run the app from container `` docker run -p 5000:5000 -e DB_HOST='34.73.152.50' web-app:test ``

## Deploying on the Cloud

---

_Note: this project has been deployed to Google Cloud Platform thanks to their generous trial credits_

* Container images are mainly sourced from open source tools
* Web app container will need to be built using some additional flavor (see local development above)
* Assumptions: you have access to a cloud platform (GCP in this case)
* You have general understanding of: IaC, application development, Kubernetes, Helm, containers...probably even an addiction to good coffee.

## Future Enhancements

---

- [x] Version app in pipeline (verbump ideal, manual ok for initial)
- [x] Register domain name
- [] Obtain/apply SSL certificate
- [] Put web app behind WAF -- Cloud Armor?
- [] CI pipeline to build the app (lint, unit test, sast, version, publish)
- [] CI pipeline to build the container (lint, validate, scan, version, publish)
- [] CD to continually deploy the app (argo?)

#### Deployment Strategy

* Security and compliance - no apps get published to prod with vulnerabilities! Put gates in place.
* Infrastructure - deploy based on estimated workload (infra/live), scale up and out as needed with Terragrunt configs
* Canary deployments - cheaper, faster, more features get added without major pushes
* Blue-Green (dev, stage, pre-prod, prod) - useful with major changes to an app, wholesale upgrades
* Separate Kubernetes clusters - development, test, production
