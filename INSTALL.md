## Getting Started

### File Updates

* **vagrant-config.yml** - (_copy default and update cpus, memory, and host IP_)
* **docker-variables.yml** - (_copy default and update AWS S3 information_)
* **manifest-variables.dev.yml** - (_copy default and update Name, Host, and Description_)
* **manifest-variables.prod.yml** - (_copy default and update Name, Host, and Description_)


### Development Environment

This Drupal site runs in a two container Docker environment maintained through
Docker Compose.  There are two containers; a PostgreSQL server and an Apache / PHP
Drupal web server, with a shared volume for the root project directory.

If you already have Docker Compose running locally on your machine, you can just
run the docker-compose process locally.  If you do not have Docker or prefer to
work in virtualized development environments, this repository comes with a
Vagrantfile that will build a Virtualbox virtual machine that automatically
spins up the proper containers and exposes the right ports to the host operating
system.


---
#### Vagrant Environment

1. **Virtualbox** - Install Virtualbox from: https://www.virtualbox.org/wiki/Downloads

2. **Vagrant** - Install Vagrant from: https://www.vagrantup.com/downloads.html

When using Vagrant, when SSHing into the virtual machine, you will automatically redirect
you to the project root directory (**/var/www**).  Docker, Docker Compose, Drush, Drupal
Console, PSQL Client, and PHP Composer come installed on the Vagrant virtual
environment initially.

When the Vagrant machine is first created all Docker containers specified in the
docker-compose configuration are created and started so the website will be viewable
at **localhost:8080**.

**To get started**

```bash
$ cd {project directory}
$ git submodule update --init --recursive   # Add the Bootstrap library to the project
$ vagrant up
$ vagrant ssh
```

You are now in the shared project directory: **/var/www**

* **/var/www/web** live at **localhost:8080**
* First user: **admin**
* Password:   **admin987** (_please change!_)


---
#### Docker Environment

1. **Docker** - Install Docker from: https://www.docker.com/community-edition

2. **Docker Compose** - Install Docker Compose from: https://docs.docker.com/compose/install

Since this Drupal site is built on Docker, you can run the site directly from
your local Docker instance (_provided you have Docker Compose installed_).

If running within Docker locally it is important to run **scripts/docker-compose.sh**
before running **docker-compose up** because it generates the final **docker-compose.yml**
file based on a separate variables list; **docker-variables.yml**.  The included
Vagrantfile runs this script automatically before calling docker-compose.

**To get started**

```bash
$ cd {project directory}
$ git submodule update --init --recursive      # Add the Bootstrap library to the project
$ ./scripts/docker-compose.sh
$ docker-compose up -d
$ docker exec -it www_drupal-web_1 /bin/bash   # SSH into a running container
```

You are now within the shared project directory: **/var/www/web**

* **/var/www/web** live at **localhost:8080**
* First user: **admin**
* Password:   **admin987** (_please change!_)


---
### Common Operations

#### Vagrant Controls

* Run from the **host** machine
* Run from the **top level project** directory

```bash
$ vagrant status       # Check the status of the virtual machine

$ vagrant up           # Create a new or run an existing virtual machine
$ vagrant provision    # Re-provision development environment from specs in Vagrantfile
$ vagrant ssh          # SSH into a running virtual machine

$ vagrant halt         # Stop and save an existing virtual machine
$ vagrant destroy      # Completely destroy an existing virtual machine
```

More on the [vagrant commands](https://www.vagrantup.com/docs/cli/)


#### Docker Controls

* Run on either the **vagrant** or **host** machine (_if installed and used_)
* Run from the **/var/www** or **top level project** directory

```bash
$ docker-compose ps                      # List all running containers from the docker-compose images

$ docker logs www_drupal-web_1           # Display recent log entries from the www_drupal-web_1 container
$ docker logs www_drupal-web_1 --follow  # Follow log entries from the www_drupal-web_1 container

$ docker exec -it www_drupal-web_1 bash  # SSH into the running www_drupal-web_1 container

$ docker-compose up -d                   # Create and run all site containers/services in the background
$ docker-compose build                   # Rebuild docker images for all docker-compose services

$ docker-compose stop drupal-web         # Stop the Drupal web service
$ docker-compose rm drupal-web           # Remove the Drupal web service
```

More on the [docker commands](https://docs.docker.com/engine/reference/commandline/cli/)


#### Site Configuration Management

* Run from the Drupal web **docker** container
* Run from the **/var/www/web** directory
* Configurations are imported from and exported to the **/var/www/config** directory

```bash
$ drush cex   # Export site configurations to top level config directory
$ drush cim   # Import site configurations from top level config directory
```


#### Composer Operations

* Run from the Drupal web **docker** container
* Run from the **/var/www** directory
* See the **composer.json** and **scripts/composer/DrupalHandler.php** script

```bash
$ composer install              # Install all dependencies and run all update operations

$ scripts/composer-rebuild.sh   # Delete all cached data and existing build files and run composer install process
```

### Cloud.gov Setup and Deployment

This experimental Drupal site is built to be deployed to the Cloud.gov hosting
environment. The underlying Cloud.gov architecture consists of an application
container and two services; a PostgreSQL service instance and an S3 service.


**Important Note:** This following Cloud.gov deployment system should ultimately
be replaced with flat naming of resources with user provided service environment
variable injection.  Everything has been scripted to ensure it is easier for CI/CD
deployment in the future, so the scripts and manifests should be altered to pull
bound environment variables from both the CI/CD environment and Cloud.gov
environment.  In short, move away from deploying to Cloud.gov like this.


#### Generating the Cloud.gov Manifest

In order to ensure consistent deployments this project supplies three scripts
that can be used to setup and deploy the application to the target environments.

In the top level directory, you will see two files:

 * manifest-variables.dev.default.yml
 * manifest-variables.prod.default.yml

One of these should exist for each environment currently.  Copy the variables into
the appropriate environment file and edit accordingly.  **manifest-variables.{env}.yml**.
These variables are interpolated into a common manifest template for the application.

To generate the completed manifest, run:

```bash
$ scripts/cg-manifest.sh {environment}
```

#### Setting up the Cloud.gov Space

To initialize an existing Cloud.gov space, run:

```bash
$ scripts/cg-init.sh  # This script takes options; to find out more execute with the -h|--help flag.
```

The **cg-init** script creates the required services for the Drupal application
within Cloud.gov.


#### Deploying the Cloud.gov application

To push the Cloud.gov application, ensure the manifest has been generated with **cg-manifest.sh {env}** then run:

```bash
$ scripts/cg-push.sh  # This script takes options; to find out more execute with the -h|--help flag.
```

The **cg-push** script deploys the application to Cloud.gov.  In the future the
Cloud Foundry autopilot plugin should be used for a zero downtime deployment.


#### Destroying the Cloud.gov Space

To destroy all existing Cloud.gov space application related components, run:

```bash
$ scripts/cg-destroy.sh  # This script takes options; to find out more execute with the -h|--help flag.
```

The **cg-destroy** script destroys all Cloud.gov components for the Drupal
application.
