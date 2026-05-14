# aitt-infra
Deploy the AITT infrastructure in the cloud.

The goal of this repository is automating the deployment of the AITT infrastructure
in the cloud using Terraform.

## Infrastructure schema

![AITT infrastructure](/schema/infra.svg)

The current AITT infrastructure is simple. It is a simple EC2 instance with two
containers running in the same Docker network: one for the core (+ frontend) and one
for a dedicated service for a angle symbol recognition ML API.

We chose to deploy the infrastructure with separate images and not to use Docker
Compose because we want to have more control over the deployment process.

This way we can ensure independant deployment. This was a way to train a bit and 
experiment with Microservice Architecture in a simple fashion with the best-practices
that come with it.

## Terraform version

In order to manage the version of Terraform, we use the 
[tfenv](https://github.com/tfutils/tfenv) tool.

## Environment management

This is currently only one single environment for this project, named dev.

# Setup

## Environment variables

Set them using the following command:

```bash
source .env
```

Set the `.env` by following the example file: `.env.example`

# Full Deployment of the AIIT Application

Even though this is just the Terraform repository. Here is the full deployment setup.

Check the infrastructure schema seen before to better understand what comes next.

Here is the order to how to deploy the application fully:

1. Terraform the infrastructure using this repository.
2. Deploy the docker image in ECR using this repository: [aitt-symbol-clf](https://github.com/poupeaua/aitt-symbol-clf).
3. Deploy the docker image in ECR using this repository: [aitt-core](https://github.com/poupeaua/aitt-core).
4. Setup the EC2 + Deploy the container `aitt-symbol-clf` using the Ansible repository: [aitt-symbol-clf-deploy](https://github.com/poupeaua/aitt-symbol-clf-deploy). 
5. Setup NGINX + Deploy the container `aitt-core` using the Ansible repository: [aitt-core-deploy](https://github.com/poupeaua/aitt-core-deploy).

Each repository contains its own documentation.

You are all done!
