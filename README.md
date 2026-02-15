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