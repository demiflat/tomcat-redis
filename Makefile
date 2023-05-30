SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

REGISTRY:=$(DOCKER_REGISTRY)
CONTAINER_NAME=tomcat-sessions
CONTAINER_VERSION=1
CONTAINER_TAG="$(REGISTRY)/$(CONTAINER_NAME):$(CONTAINER_VERSION)"
DEPLOYMENT=tomcat-sessions
NAMESPACE=default

info:
> @cat .info

all: login deploy kube-info kube-info-all

clean:
> rm -rf build

build:
> ./gradlew war

login:
> podman login $(REGISTRY)

docker: build
> podman build -f Containerfile -t $(CONTAINER_TAG)

push: docker
> podman push $(CONTAINER_TAG)

deploy: login push
> kubectl create deployment $(DEPLOYMENT) --image=$(CONTAINER_TAG) --port=8080 --replicas=3
> kubectl create service clusterip $(DEPLOYMENT) --tcp=8080:8080
> cat k8s-ingress.yaml | DEPLOYMENT=$(DEPLOYMENT) envsubst | kubectl apply -f -
> cat k8s-role.yaml | NAMESPACE=$(NAMESPACE) envsubst | kubectl apply -f -
> kubectl get all

destroy:
> kubectl delete deployment $(DEPLOYMENT) --ignore-not-found=true
> kubectl delete service $(DEPLOYMENT) --ignore-not-found=true
> kubectl delete ingress $(DEPLOYMENT) --ignore-not-found=true
> kubectl get all

kube-info:
> kubectl get all

kube-info-all:
> kubectl get -A all
