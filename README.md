# Ansible and Terraform Three-Tier Application Setup

## Introduction

This project provides the configuration for setting up a three-tier application using Ansible and Terraform. The setup includes provisioning of infrastructure on Azure using Terraform and configuring Node.js, business logic, and MySQL databases using Ansible.

## Table of Contents

- [Introduction](#introduction)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Dependencies](#dependencies)
- [Configuration](#configuration)
  - [Terraform Configuration](#terraform-configuration)
  - [Ansible Configuration](#ansible-configuration)
- [Documentation](#documentation)
- [Troubleshooting](#troubleshooting)
- [Contributors](#contributors)

## Installation

1. **Clone the repository:**
   ```sh
   git clone <repository_url>
   cd <repository_directory>

2. **Install Ansible:**
Follow the official Ansible installation guide: [Ansible Installation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

3. **Install Terraform:**
Follow the official Terraform installation guide: [Terraform Installation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Usage

1. **Provision Infrastructure using Terraform:**
   ```sh
   terraform init 
   terraform apply
2. **Configure Ansible:**
Modify the `ansible.cfg` file as needed to match your environment. Ensure that your inventory file is correctly set up.
3. **Run the Node.js playbook:**
   ```sh
   ansible-playbook ansible_playbooks/configuring_nodejs.ansible.yml
   ```

4. **Deploy applications and database using Ansible:**
	```sh
	ansible-playbook ansible_playbooks/deploying_web_app.ansible.yml 
	ansible-playbook ansible_playbooks/deploying_business_app.ansible.yml
	ansible-playbook ansible_playbooks/deploy_mysql.ansible.yml
	```
 ## Features

-   Automated setup of a three-tier architecture on Azure.
    
-   Provisioning and configuration of infrastructure and applications using Terraform and Ansible.
    
-   Populating MySQL databases with initial data.

## Dependencies

-   Ansible
-   Terraform
-   Node.js
-   MySQL or compatible database system

## Configuration

### Terraform Configuration

The provided Terraform code defines the infrastructure for a three-tier architecture on Azure. Here’s a detailed breakdown:

#### Virtual Network and Subnets

-   **Virtual Network:** Creates a virtual network with an address space of `10.0.0.0/16`.
-   **Subnets:**
    -   Web Tier Subnet: `10.0.1.0/24`
    -   Business Tier Subnet: `10.0.2.0/24`
    -   Data Tier Subnet: `10.0.3.0/24`

#### Public IPs

-   Public IPs for the frontend application, and temporary public IPs for business and data applications.

#### Network Security Groups (NSGs)

-   **Web Tier NSG:** Allows SSH (port 22) inbound traffic.
-   **Business Tier NSG:** Allows SSH (port 22) and TCP traffic on port 8080 from the Web Tier subnet.
-   **Data Tier NSG:** Allows SSH (port 22) and TCP traffic on port 3306 from the Business Tier subnet.

#### Network Interfaces

-   **Web Tier NIC:** Connected to the Web Tier Subnet and associated public IP.
-   **Business Tier NIC:** Connected to the Business Tier Subnet and associated public IP.
-   **Data Tier NIC:** Connected to the Data Tier Subnet and associated public IP.

#### Storage Account

-   Created for boot diagnostics.

#### SSH Key

-   Generates an SSH key pair and saves the private key locally.

#### Virtual Machines

-   **Web Tier VM:** Ubuntu 18.04-LTS.
-   **Business Tier VM:** Ubuntu 18.04-LTS.
-   **Data Tier VM:** Ubuntu 18.04-LTS.

### Ansible Configuration

#### Ansible Configuration (`ansible.cfg`)

Contains Ansible settings, including:

-   Inventory file location
-   Remote user settings
-   SSH connection parameters

#### Node.js Playbook (`ansible_playbooks/configuring_nodejs.ansible.yml`)

Tasks for setting up a Node.js environment on the target machines.

#### MySQL Script (`ansible_playbooks/test.sql`)

Populates the MySQL database with initial data for the three-tier application.

## Documentation

-   [Ansible Documentation]()
-   [Terraform Documentation]()
-   [Node.js Documentation]()
-   [MySQL Documentation](https://dev.mysql.com/doc/)

## Troubleshooting

-   **Terraform issues:** Ensure that you have the correct permissions and credentials to create resources on Azure.
-   **Ansible issues:** Ensure that your inventory and configuration files are correctly set up and that you can SSH into your target machines.

## Contributors

* [Baghdad Rafik TAAMMA](https://github.com/rafiktaamma)
