.PHONY: help build up up-dev down down-dev deploy-examples clean

# Default target
help:
	@echo "Available targets:"
	@echo "  build         - Build all services"
	@echo "  up            - Start all services"
	@echo "  up-dev        - Start all services in development mode"
	@echo "  down          - Stop all services"
	@echo "  down-dev      - Stop all services in development mode"
	@echo "  deploy-examples - Deploy examples for all services"
	@echo "  clean         - Clean .env files and examples"

build:
	docker compose build

up:
	docker compose --profile go-backend up -d

up-node-backend:
	docker compose up --profile backend -d

down:
	docker compose down

up-dev:
	docker compose -f compose.yaml -f compose.override.dev.yaml up -d

down-dev:
	docker compose -f compose.yaml -f compose.override.dev.yaml down

deploy-examples:
	./deploy-examples.sh

clean:
	git clean -Xdi
