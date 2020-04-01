VERSION=$(shell git  describe --tags --abbrev=0)
DOCKERHUB_REPO=hortonworks/cloudbreak-azure-cli-tools

deps:
	go get github.com/progrium/dockerhub-tag

build:
	docker build -t $(DOCKERHUB_REPO):$(VERSION) .

build-dev:
	docker build -t $(DOCKERHUB_REPO):dev .

dockerhub-tag:
	dockerhub-tag set $(DOCKERHUB_REPO) $(VERSION) $(VERSION) /

