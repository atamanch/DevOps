# DevOps

# Portfolio of DevOps Projects

**BasicWebApp** is a project which starts with a simple Python WebApp which uses the Streamlit and YFinance libraries to display stock data on Google's stock. This app is then packaged up into a Docker image, deployed to an AWS EC2 Autoscaling group backed by an Elastic Load Balancer. The whole stack is finished off by a CI/CD pipeline which used Jenkins to automatically build and deploy a new Docker image if a new commit is pushed to the master branch.

Docker Image: https://hub.docker.com/repository/docker/atamanch/dockerstore

Technologies used: Terraform, Ansible, Docker, Jenkins, Python, EC2, ELB, Autoscaling policy
**How to use:**
Clone this repository and edit both the **BasicWebApp\key-pairs.tf** and **BasicWebApp\variables.tf** files in a text editor. 
**key-pairs.tf**
You will need to replace the "public_key" field with the contents of your public EC2 access key. This will allow SSH access to Terraform to the EC2 web server instance.
**variables.tf**
Similarly, you'll need to edit the default field for the "private_key_path" with the path of your private EC2 access key. This is also required to grant Terraform SSH access to the same EC2 web server instance.

https://www.linkedin.com/in/art-anderson/
