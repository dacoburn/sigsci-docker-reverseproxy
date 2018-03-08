DOCKERUSER?=sigsci
DOCKERNAME?=sigsci-agent-alpine
DOCKERTAG?=latest
env_options?="-e SIGSCI_ACCESSKEYID=SETME -e SIGSCI_SECRETACCESSKEY=SETME -e SIGSCI_HOSTNAME=alpine35"
PORT?=80

build:
	./getAgent.sh
	docker build -t $(DOCKERUSER)/$(DOCKERNAME):$(DOCKERTAG) .

build-no-cache:
	./getAgent.sh
	docker build --no-cache -t $(DOCKERUSER)/$(DOCKERNAME):$(DOCKERTAG) .

run:
	docker run -p $(PORT):$(PORT) --name $(DOCKERNAME) -d $(env_options) $(DOCKERUSER)/$(DOCKERNAME):$(DOCKERTAG)

deploy:
	docker push $(DOCKERUSER)/$(DOCKERNAME):$(DOCKERTAG)
