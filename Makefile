# /////////////// defs

COMPOSE_FILE		:=	./srcs/compose.yaml
DATA				:=	/home/fpetit/data

# /////////////// targets

all: up

# -f compose file path
# -d detached mode
up:
	@echo "Starting Docker containers..."
	@docker compose -f $(COMPOSE_FILE) up -d
	@echo "✅ Containers ready"

down:
	@echo "Stopping Docker containers..."
	@docker compose -f $(COMPOSE_FILE) down
	@echo "Containers stopped"

clean:
	@echo "Cleaning Docker containers, project images, volumes and networks..."
	@docker compose -f $(COMPOSE_FILE) down -v --rmi all

# cleans containers, networks, images, volumes
# also cleans build cache
# -a to clean tagged images
fclean: clean
	@echo "Cleaning all Docker resources..."
	@docker system prune -af --volumes
	@echo "Cleaning data..."
	@sudo rm -rf $(DATA)
	@echo "Cleaning done"

secrets:
	@chmod +x setup_secrets.sh
	@sudo ./setup_secrets.sh

rm-secrets:
	@echo "Removing secret files"
	@rm -rf secrets
	@echo "Secret files removed"

directories:
	@chmod +x setup_dirs.sh
	@sudo ./setup_dirs.sh

re-wp:
	@echo "Rebuildig and restarting Wordpress..."
	@docker compose -f $(COMPOSE_FILE) build --no-cache wordpress
	@docker compose -f $(COMPOSE_FILE) up -d wordpress
	@echo "Wordpress restarted"

re-db:
	@echo "Rebuilding and restarting MariaDB without cache..."
	@docker compose -f $(COMPOSE_FILE) build --no-cache mariadb
	@docker compose -f $(COMPOSE_FILE) up -d mariadb
	@echo "MariaDB restarted"

re: fclean
	@echo "Rebuilding and restarting all images"
	@$(MAKE) directories
	@docker compose -f $(COMPOSE_FILE) build --no-cache
	@$(MAKE) up

show:
	# containers
	docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
	docker images
	docker volume ls
	docker network ls

logs:
	docker compose -f $(COMPOSE_FILE) logs

test-db:
	@docker exec -it mariadb mysql -u root -p"$$(cat secrets/sql_root_password.txt)" -e "SHOW DATABASES;"

sh-nginx:
	@docker exec -it nginx sh

sh-maria:
	@docker exec -it mariadb sh

sh-wp:
	@docker exec -it wordpress sh

.PHONY: up down clean fclean re status show logs test-db sh-nginx sh-maria sh-wp secrets rm-secrets directories

