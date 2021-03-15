# Hooks
CLEAN_TARGETS = clean-pkged
BUILD_RELEASE_DEP_TARGETS = bin/pkger
PRE_BUILD_RELEASE_TARGETS = $(patsubst cmd/%,cmd/%/pkged.go,$(wildcard cmd/*))
BUILD_DEBUG_DEP_TARGETS = bin/pkger
PRE_BUILD_DEBUG_TARGETS = $(patsubst cmd/%,cmd/%/pkged.go,$(wildcard cmd/*))

include main.mk

# Project variables
OPENAPI_DESCRIPTOR_DIR = api/openapi

# Dependency versions
SAMPLE_VERSION = 0.2.0

.PHONY: up
up: start config.toml ## Set up the development environment

.PHONY: down
down: clear ## Destroy the development environment
	docker-compose down --volumes --remove-orphans --rmi local
	rm -rf var/docker/volumes/*

.PHONY: reset
reset: down up ## Reset the development environment

docker-compose.override.yml:
	cp docker-compose.override.yml.dist docker-compose.override.yml

.PHONY: start
start: docker-compose.override.yml ## Start docker development environment
	@ if [ docker-compose.override.yml -ot docker-compose.override.yml.dist ]; then diff -u docker-compose.override.yml docker-compose.override.yml.dist || (echo "!!! The distributed docker-compose.override.yml example changed. Please update your file accordingly (or at least touch it). !!!" && false); fi
	docker-compose up -d

.PHONY: stop
stop: ## Stop docker development environment
	docker-compose stop

config.toml:
	sed 's/production/development/g; s/debug = false/debug = true/g; s/shutdownTimeout = "15s"/shutdownTimeout = "0s"/g; s/format = "json"/format = "logfmt"/g; s/level = "info"/level = "debug"/g; s/addr = ":10000"/addr = "127.0.0.1:10000"/g; s/httpAddr = ":8000"/httpAddr = "127.0.0.1:8000"/g; s/grpcAddr = ":8001"/grpcAddr = "127.0.0.1:8001"/g' config.toml.dist > config.toml

bin/pkger: go.mod
	@mkdir -p bin
	go build -o bin/pkger github.com/markbates/pkger/cmd/pkger

cmd/%/pkged.go: bin/pkger
	bin/pkger -o cmd/$*

.PHONY: clean-pkged
clean-pkged:
	rm -rf cmd/*/pkged.go

bin/entc:
	@mkdir -p bin
	go build -o bin/entc github.com/facebook/ent/cmd/entc

bin/sample: bin/sample-${SAMPLE_VERSION}
	@ln -sf sample-${SAMPLE_VERSION} bin/sample
bin/sample-${SAMPLE_VERSION}:
	@mkdir -p bin
	curl -sfL https://git.io/mgatool | bash -s v${SAMPLE_VERSION}
	@mv bin/sample $@

.PHONY: generate
generate: bin/sample bin/entc ## Generate code
	go generate -x ./...
	sample generate kit endpoint ./internal/app/sample/todo/...
	sample generate event handler --output subpkg:suffix=gen ./internal/app/sample/todo/...
	sample generate event dispatcher --output subpkg:suffix=gen ./internal/app/sample/todo/...
	entc generate ./internal/app/sample/todo/todoadapter/ent/schema
