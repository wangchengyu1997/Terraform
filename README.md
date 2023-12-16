# Terraform AWS ECS Configuration

This repository contains the Terraform configuration files for deploying an AWS ECS Cluster, Task Definition, and Service with a specific IAM role. It's set up to deploy a container using the AWS Fargate launch type.

## Overview

The configuration sets up the following resources:

- **AWS ECS Cluster**: A cluster to manage the lifecycle of containerized applications.
- **AWS ECS Task Definition**: Defines the containers and volumes for your task.
- **AWS ECS Service**: Runs and maintains a specified number of instances of a task definition simultaneously in an ECS cluster.

