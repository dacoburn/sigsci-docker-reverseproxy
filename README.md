## Signal Sciences Docker Configuration - Alpine with SigSci Agent in Reverse Proxy Mode

This is a dockerized SigSci agent in Reverse Proxy mode. This container is set up to take environment variables for the Access Key, Secret Key, and reverse proxy settings. You can use a pre-built container or build your own. When building and deploying I tend to use the agent version for the tag.

## Information about the files


**start.sh**
The start.sh is a simple script for doing some customizations. I use it to start the apache service and then set a custom hostname that the Signal Sciences agent will report up. I like to include a hard coded value, I.E. MYKUBECLUSTERNAME, followed by the dynamically found hostname. On Docker, or Kubernetes, the hostname is the docker id. Between those two things it makes it very easy to figure out where the container is running in relation to the agent found in the Signal Sciences dashboard.

**contrib**

_Files:_

````
    contrib/create-agent-conf.sh  # Creates the config file for Reverse Proxy mode from env variables. This currently only sets up as imple listener. Visit https://docs.signalsciences.net/install-guides/reverse-proxy/ for more options for RP mode (You'll need to update this file)
    contrib/start.sh # Start file that runs the agent creation script and starts the agent
````


I'll usually create a .dockerignore file that will ignore adding the contrib to the final docker container and put files that I would like to copy into the container in this folder. 



**Dockerfile**
The included dockerfile is my example for creating a container that has our Signal Sciences Agent.

**Makefile**
I tend to prefer nice easy command for doing my tasks in building, deploying, and testing locally. The makefile simplifies this process but is not neccessary.

## Running the container

You can use the `env_variables="-e container_env_var=value"` to pass environment variables to the container. 

Example:

make run DOCKERUSER=trickyhu DOCKERTAG=3.2.1 env_options="-e SIGSCI_ACCESSKEYID=*ACCESSKEY* -e SIGSCI_SECRETACCESSKEY=*SECRETKEY* -e SIGSCI_HOSTNAME=*CUSTOMTAGHERE* -e SIGSCI_UPSTREAM=http://server.domain.com:80"


## Building Docker image

You can use the Makefile to build the Docker Container
Make Example:

make build DOCKERUSER=*USERNAME* DOCKERTAG=3.2.1


## Deploying to Docker

You can also use the Makefile to deploy the created container to Docker Hub

make deploy DOCKERUSER=*USERNAME* DOCKERTAG=3.2.1


