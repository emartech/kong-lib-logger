SHELL=/bin/bash
.PHONY: help up down restart build test publish

default: help

help: ## Show this help
	@echo "Targets:"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/\(.*\):.*##[ \t]*/    \1 ## /' | sort | column -t -s '##'

up: ## Start containers
	docker-compose up -d

down: ## Stop containers
	docker-compose down

restart: down up ## Restart containers

build: ## Rebuild containers
	docker-compose build --no-cache

test: ## Run tests
	docker-compose run lua /usr/local/bin/busted test/spec/logger_spec.lua

publish: ## Build and publish plugin to luarocks
	docker-compose run lua bash -c "cd /test && chmod +x publish.sh && ./publish.sh"
