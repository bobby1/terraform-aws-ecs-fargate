## Table of Contents
- [Design Principles](#design-principles)
- [Pre-requisites](#pre-requisites)
- [How to use](#how-to-use)
- [Roadmap](#roadmap)
- [Get Involved](#get-involved)

# This project creates a new AWS ECS Fargate service.
The Terraform code creates a new base infrastructure with the associated external IP, load balancer, networks, security groups etc...

## Design Principles
* Reusable code: The same code base is used for all environment; implementation differences are set based on the environment or tier for the SDLC.
* Scalable:  the environment setting allows each environment to scale automatically.  Development environment use micro server instance (t2.micro) to service a small number of developers, staging environments uses medium server instances (t2.medium) to allow a large audience to test the application.  Production environments uses large server instances (t2.large) to be generally available to the Internet.

  ** In the same manner, dev environments will create two server instances.  Stg environments will create four server instances.  And Prd environments will create six server instances automatically

  ** This is an alternative to terraform workspace and does not require workspace setup

* Secure: The code show examples of how to secure user account and application accessibility based on environments.
  
  ** Access to the server instances is limited based on the environment.  Dev can be configured to only allow developer access.  Stg can be configured to only allow corporate user access.  Prd can be configured to allow general Internet access.

* Flexible: The code can be customized for individual environments, based on your application needs, for example.  the AWS Machine Images (ami) for each region can be preconfigured, without the need to have project specify them for every region. Additional configuration parameters are already in the code to allow for easy customization.  This code can be used with ECS EC2 or Fargate clusters.

* Easy to use and maintain:  All code contains a banner with project, usage, pre-requisite and beware sections.  In addition, tags to identify the project, environment and other identifiable information are added where possible.

## Pre-requisites

To use this code base, AWS cli, Terraform and Ansible are required to be installed locally on the server.

   * AWS cli access configuration (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
  
   * Terraform by HashiCorp ([Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli))
  
## How to use

* To create the example environment using Terraform, in the SDLC directory for the environment to deploy, for example, dev

```bash
  $ terraform init
  $ terraform fmt
  $ terraform validate
  $ terraform plan  
        $ terraform plan -out tfplan.out  is recommended but not required
  $ terraform apply
        $ terraform apply tfplan.out  if -out was used
  
 Once the server instance is created, terraform will output the server’s name and IP.  You can retrieve this output at any time after creating the instances by running 
  
   $ terraform output
  
Once the AWS ECS base infrastructure is created, Terraform will print the output to the required information to the 2nd stage, adding ECS services to the existing infrastructure.  

## Roadmap
- Add support for additional AWS regions.
- Implement automated testing for Terraform configurations.
- Provide examples for integrating with CI/CD pipelines.
Please email me for features and additions you would like to see.  

or

## Get Involved

* Submit a proposed code update through a pull request to the `dev` branch.
* Talk to us before making larger changes
  to avoid duplicate efforts. This not only helps everyone
  know what is going on, but it also helps save time and effort if we decide
  some changes are needed.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

![Terraform](https://img.shields.io/badge/Terraform-v1.11.4-blue)
![License](https://img.shields.io/badge/License-MIT-green)