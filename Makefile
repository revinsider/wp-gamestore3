include .env
export

SERVICE   := mariadb
TIMESTAMP := $(shell date +%Y-%m-%d_%H-%M-%S)

.PHONY: up down restart logs ps shell wp-shell db dump restore reset pull help

help:
	@echo "Available targets:"
	@echo "  up         Start the stack in the background"
	@echo "  down       Stop the stack (keeps volumes)"
	@echo "  restart    Restart all services"
	@echo "  logs       Tail logs from all services"
	@echo "  ps         Show running containers"
	@echo "  shell      Open bash inside the wordpress container"
	@echo "  wp-shell   Alias for shell"
	@echo "  db         Open interactive mariadb client"
	@echo "  dump       Dump database to backups/<db>-<timestamp>.sql.gz"
	@echo "  restore    Restore from FILE=backups/foo.sql.gz"
	@echo "  reset      Stop stack and DELETE volumes (wipes DB)"
	@echo "  pull       Pull latest images"

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

logs:
	docker compose logs -f

ps:
	docker compose ps

shell wp-shell:
	docker compose exec wordpress bash

db:
	docker compose exec $(SERVICE) mariadb -u root -p$(DB_ROOT_PASSWORD) $(DB_NAME)

dump:
	@mkdir -p backups
	docker compose exec -T $(SERVICE) \
	  mariadb-dump -u root -p$(DB_ROOT_PASSWORD) \
	    --single-transaction --quick --lock-tables=false \
	    $(DB_NAME) | gzip > backups/$(DB_NAME)-$(TIMESTAMP).sql.gz
	@echo "Saved → backups/$(DB_NAME)-$(TIMESTAMP).sql.gz"

restore:
	@test -n "$(FILE)" || (echo "Usage: make restore FILE=backups/foo.sql.gz"; exit 1)
	@test -f "$(FILE)" || (echo "Not found: $(FILE)"; exit 1)
	@if echo "$(FILE)" | grep -q '\.gz$$'; then \
	  gunzip -c "$(FILE)" | docker compose exec -T $(SERVICE) mariadb -u root -p$(DB_ROOT_PASSWORD) $(DB_NAME); \
	else \
	  docker compose exec -T $(SERVICE) mariadb -u root -p$(DB_ROOT_PASSWORD) $(DB_NAME) < "$(FILE)"; \
	fi
	@echo "Restored from $(FILE)"

reset:
	docker compose down -v
	docker compose up -d

pull:
	docker compose pull
