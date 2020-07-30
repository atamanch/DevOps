# Portfolio of DevOps Projects

**BasicWebApp** is a project which starts with a simple Python WebApp which uses the Streamlit and YFinance libraries to display stock data on Google's stock. This app is then packaged up into a Docker image, deployed to an AWS EC2 Autoscaling group backed by an Elastic Load Balancer. The whole stack is finished off by a CI/CD pipeline which used Jenkins to automatically build and deploy a new Docker image if a new commit is pushed to the master branch.

Docker Image: https://hub.docker.com/repository/docker/atamanch/dockerstore

Technologies used: Terraform, Docker, AWS EC2, AWS ELB, AWS Autoscaling policy, Azure Linux VM Scale Set, Azure Load Balancer, Python

**How to use:**

1) Clone this repository

2a) If you prefer to run in AWS:
	  Edit the **BasicWebApp/AWS/variables.tf** file to fit your environment.
    
2b) If you prefer to run in Azure: 
    Edit the **BasicWebApp/Azure/variables.tf** file to fit your environment.

You will need to replace the "ssh_public_key" field with the path of your public EC2 access key. This will allow SSH access to Terraform to the EC2 web server instance.


**Export-ProcessInfo** is a PowerShell script which remotely queries process information on machines within your environment and output data on memory usage, command lines used to run those processes and more.


**LogReader** is a Python script which can be used to parse log output for keywords.


**WebScraperPS** is a PowerShell script which can detect changes on a website over time. It queries a website and saves the site's state in a statefile. Re-running the script will cause the script to re-query the site, comparing the old state to the current state. If a difference is detected, the script will notify the user via email.


**WebScraperPy** is a Python script which can detect changes on a website over time. It queries a website and saves the site's state in a statefile. Re-running the script will cause the script to re-query the site, comparing the old state to the current state. If a difference is detected, the script will notify the user via email.

https://www.linkedin.com/in/art-anderson/
