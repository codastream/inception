# defs

COMPOSE_FILE		:=	./srcs/compose.yaml
DATA				:=	/home/fpetit/data

# targets

all: up

secrets:
	@./setup_secrets.sh

rm-secrets:
	@echo "Removing secret files"
	@rm -rf secrets
	@echo "Secret files removed"

directories:
	@chmod +x setup_dirs.sh
	@./setup_dirs.sh

# -f compose file path
# -d detached mode
up: directories
	@echo "Starting Docker compose..."
	@docker compose -f $(COMPOSE_FILE) up
	@echo "Containers ready"

down:
	@echo "Stopping Docker compose..."
	@docker compose -f $(COMPOSE_FILE) down
	@echo "Containers stopped"

# clean project
clean:
	@echo "Cleaning Docker compose..."
	@docker compose -f $(COMPOSE_FILE) down -v --rmi all

# cleans containers, networks, images, volumes
# also cleans build cache
# -a to clean tagged images
fclean: clean
	@echo "Cleaning system from all docker ..."
	@docker system prune -af --volumes
	@echo "Cleaning data..."
	rm -rf $(DATA)
	@echo "Cleaning done"

re-wp:
	@docker compose -f $(COMPOSE_FILE) build --no-cache wordpress

re-db:
	@rm -rf $(DATA)/mariadb/*
	@docker rm -f mariadb || true
	@docker rmi -f mariadb || true
	@docker volume rm -f mariadb || true
	@docker build -t mariadb srcs/requirements/mariadb
	@docker volume create mariadb
	@docker run -d \
		--name mariadb \
		--network inception \
		-v $(DATA)/mariadb:/var/lib/mysql \
		-e SQL_ROOT_PASSWORD=rootpassword \
		-e SQL_ADMIN_PASSWORD=adminpassword \
		-e SQL_USER_PASSWORD=userpassword \
		mariadb

re: fclean
	@echo "Rebuilding Docker images without cache..."
	@docker compose -f $(COMPOSE_FILE) build --no-cache
	@make

status:
	@docker ps

show:
	# containers
	docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
	docker images
	docker volume ls
	docker network ls

inspect-maria:
	@docker inspect mariadb | grep -E "Image|Created"

logs:
	docker compose -f $(COMPOSE_FILE) logs

sh-nginx:
	@docker exec -it nginx sh

sh-maria:
	@docker exec -it mariadb sh

sh-wp:
	@docker exec -it wordpress sh

.PHONY: secrets rm-secrets directories up down stop start clean fclean re status show logs sh-nginx sh-maria sh-wp

