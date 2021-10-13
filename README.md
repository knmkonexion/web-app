# Web Application Project

---

> Purpose is to deploy a web application that stores/retrieves information from a database, is scalable and publicly available. Two of the core tenets of this application is to deploy the necessarry Infrastrcure as Code and a scalable application. What better to do this than Terraform/Terrgrunt/Kubernetes...a fabulous combination.

## Web-App System Architecture

---

#### System Components

* Web App - Python Flask, multiple routes, health-check, pulls website content from MySQl
* MySQL DB - provisioned via Terragrunt/Terraform (IaC), hosts website content, includes sample data (blog posts)
* Kubernetes cluster - provisioned via Terragrunt/Terraform (IaC), hosts the web app and monitoring stack
* Elasticsearch, Kibana, Grafana, Hearbeat stack - core monitoring stack, provisioned via Helm, propvides availability, monitoring, and alerting
* Prometheus stack - provides metrics for cluster (nodes, pods, apps, services), provisioned via Helm

<!-- insert architecture diagram here -->

#### Monitoring, Metrics, and Alerting

**Infrastrucutre and Application Monitoring**

* Service Availability - are services up and running as expected? are there any errors (crit,err,warn)?
* Network Availability - can services communicate both vertically and horizontally?
* Security Monitoring - are service components comliant, scanned, vetted?

**Application Metrics**

* (Request) **R**ate - the number of requests, per second, your services are serving.
* (Request) **E**rrors - the number of failed requests per second.
* (Request) **D**uration - The amount of time each request takes expressed as a time interval

**Alerting**

* Service outage - why did the service outage occur? how long was the service outage? root cause? tracabilitry?
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
