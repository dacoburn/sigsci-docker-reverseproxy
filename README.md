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


## Example Deployment JSON for Kubernetes


The important things to call out are:

````
"env": [
              {
                "name": "SIGSCI_ACCESSKEYID",
                "value": "YOURACCESSKEY"
              },
              {
                "name": "SIGSCI_SECRETACCESSKEY",
                "value": "SECRETACCESSKEY"
              },
              {
                "name": "SIGSCI_HOSTNAME",
                "value": "minikube"
              },
              {
                "name": "SIGSCI_UPSTREAM",
                "value": "http://sigsci-apache-alpine:8080"
              }
            ]

````


In the sigsci upstream the sigsci-apache-alpine:8080 is the internal service name and port that I setup in Ubuntu for my web server. The Accesskey, SecretAccessKey, hostname, and upstream should be updated to reflect your settings.

**Full JSON**

````
{
  "kind": "Deployment",
  "apiVersion": "extensions/v1beta1",
  "metadata": {
    "name": "sigsci-waf",
    "namespace": "default",
    "selfLink": "/apis/extensions/v1beta1/namespaces/default/deployments/sigsci-waf",
    "uid": "e10b77e5-22d2-11e8-91c4-00155d3fef0d",
    "resourceVersion": "54035",
    "generation": 1,
    "creationTimestamp": "2018-03-08T13:16:14Z",
    "labels": {
      "app": "sigsci-waf"
    },
    "annotations": {
      "deployment.kubernetes.io/revision": "1"
    }
  },
  "spec": {
    "replicas": 2,
    "selector": {
      "matchLabels": {
        "app": "sigsci-waf"
      }
    },
    "template": {
      "metadata": {
        "name": "sigsci-waf",
        "creationTimestamp": null,
        "labels": {
          "app": "sigsci-waf"
        }
      },
      "spec": {
        "containers": [
          {
            "name": "sigsci-waf",
            "image": "trickyhu/sigsci-agent-alpine:3.2.1",
            "env": [
              {
                "name": "SIGSCI_ACCESSKEYID",
                "value": "YOURACCESSKEY"
              },
              {
                "name": "SIGSCI_SECRETACCESSKEY",
                "value": "SECRETACCESSKEY"
              },
              {
                "name": "SIGSCI_HOSTNAME",
                "value": "minikube"
              },
              {
                "name": "SIGSCI_UPSTREAM",
                "value": "http://sigsci-apache-alpine:8080"
              }
            ],
            "resources": {},
            "terminationMessagePath": "/dev/termination-log",
            "terminationMessagePolicy": "File",
            "imagePullPolicy": "IfNotPresent",
            "securityContext": {
              "privileged": false
            }
          }
        ],
        "restartPolicy": "Always",
        "terminationGracePeriodSeconds": 30,
        "dnsPolicy": "ClusterFirst",
        "securityContext": {},
        "schedulerName": "default-scheduler"
      }
    },
    "strategy": {
      "type": "RollingUpdate",
      "rollingUpdate": {
        "maxUnavailable": "25%",
        "maxSurge": "25%"
      }
    },
    "revisionHistoryLimit": 10,
    "progressDeadlineSeconds": 600
  },
  "status": {
    "observedGeneration": 1,
    "replicas": 2,
    "updatedReplicas": 2,
    "readyReplicas": 2,
    "availableReplicas": 2,
    "conditions": [
      {
        "type": "Available",
        "status": "True",
        "lastUpdateTime": "2018-03-08T13:16:16Z",
        "lastTransitionTime": "2018-03-08T13:16:16Z",
        "reason": "MinimumReplicasAvailable",
        "message": "Deployment has minimum availability."
      },
      {
        "type": "Progressing",
        "status": "True",
        "lastUpdateTime": "2018-03-08T13:16:16Z",
        "lastTransitionTime": "2018-03-08T13:16:14Z",
        "reason": "NewReplicaSetAvailable",
        "message": "ReplicaSet \"sigsci-waf-866997fcc7\" has successfully progressed."
      }
    ]
  }
}
````