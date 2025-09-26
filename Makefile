# defs

COMPOSE_FILE		:=	./srcs/compose.yaml
DATA				:=	/home/fpetit/data

# targets

all: secrets

secrets:
	@./setup_secrets.sh

rm-secrets:
	@echo "Removing secret files"
	@rm -rf secrets
	@echo "Secret files removed"

directories:
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
	@sudo docker compose -f $(COMPOSE_FILE) down -v --rmi all

# cleans containers, networks, images, volumes
# also cleans build cache
# -a to clean tagged images
fclean: clean
	@echo "Cleaning system from all docker (..."
	@sudo docker system prune -af --volumes
	@echo "Cleaning data..."
	sudo rm -rf $DATA
	@echo "Cleaning done"

re: fclean
	@make

status:
	@sudo docker ps

show:
	sudo docker images
	sudo docker volume ls
	sudo docker network ls

logs:
	docker compose -f $(COMPOSE_FILE) logs

sh-nginx:
	@sudo docker exec -it nginx sh

sh-maria:
	@sudo docker exec -it mariadb sh

sh-wp:
	@sudo docker exec -it wordpress sh

.PHONY: secrets rm-secrets directories up down stop start clean fclean re status show logs sh-nginx sh-maria sh-wp

