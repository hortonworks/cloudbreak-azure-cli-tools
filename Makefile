VERSION=$(shell git  describe --tags --abbrev=0)
REPOSITORY=cloudbreak-tools/cloudbreak-azure-cli-tools

.PHONY: build build-dev release release-dev dev-all

build:
	docker build -t $(REPOSITORY):$(VERSION) .

build-dev:
	docker build -t $(REPOSITORY):dev .

release:
	docker tag $(REPOSITORY):$(VERSION) docker-sandbox.infra.cloudera.com/$(REPOSITORY):$(VERSION)
	docker push docker-sandbox.infra.cloudera.com/$(REPOSITORY):$(VERSION)

release-dev:
	docker tag $(REPOSITORY):dev docker-sandbox.infra.cloudera.com/$(REPOSITORY):dev
	docker push docker-sandbox.infra.cloudera.com/$(REPOSITORY):dev

dev-all:
	make build-dev
	make release-dev