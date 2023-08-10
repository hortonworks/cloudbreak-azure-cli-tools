VERSION=$(shell git  describe --tags --abbrev=0)
REPOSITORY=cloudbreak-tools/cloudbreak-azure-cli-tools

build:
	docker build -t $(REPOSITORY):$(VERSION) .

build-dev:
	docker build -t $(REPOSITORY):dev .

release:
	docker tag $(REPOSITORY):$(VERSION) docker-sandbox.infra.cloudera.com/$(REPOSITORY):$(VERSION)
	docker push docker-sandbox.infra.cloudera.com/$(REPOSITORY):$(VERSION)