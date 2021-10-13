# Web Application Project

---

> Purpose is to deploy a web application that stores/retrieves information from a database, is scalable and publicly available. Two of the core tenets of this application is to deploy the necessarry Infrastrcure as Code and a scalable application. What better to do this than Terraform/Terrgrunt/Kubernetes...a fabulous combination.

## Additional Details To Come...

---

## Local Development

---

#### Running the Flask App Locally

* Install requirements (pip install -r requirements.txt)
* Modify the app as needed
* Run the app locally `` python3 app.py ``

#### Running the Flask App Container

* Build the image locally `` docker -t web-app:test --build-arg DB_PASSWORD=$(cat password.txt) .``
* You will need the password.txt file (git ignores this file, because secrets...)
* Or use the container_manager.sh script (caution: it only works for my GCP project, it is there for an example)
* Run the app from container `` docker run -p 5000:5000 -e DB_HOST='34.73.152.50' web-app:test ``
