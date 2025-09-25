# defs

COMPOSE_FILE		:=	./srcs/compose.yaml
DATA			:=	/home/fpetit/data

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
    @docker compose -f $(COMPOSE_FILE) up -d
    @echo "Containers ready"

down:
    @echo "Stopping Docker compose..."
    @docker compose -f $(COMPOSE_FILE) down -d
    @echo "Containers stopped"

# clean project
clean:
    @echo "Cleaning Docker compose..."
    @docker compose -f $(COMPOSE_FILE) down -v --rmi all

# cleans containers, networks, images, volumes
# also cleans build cache
# -a to clean tagged images
fclean: clean
    @echo "Cleaning system from all docker (..."
    @docker system prune -af --volumes
    @echo "Cleaning data..."
    sudo rm -rf $DATA
    @echo "Cleaning done"

re: fclean
    @make

status:
    @docker ps

show:
    docker images
    docker volumes ls
    docker network ls
    
logs:
    docker compose -f $(COMPOSE_FILE) logs

sh-nginx:
    @docker exec -it nginx sh

sh-maria:
    @docker exec -it mariaadb sh

sh-wp:
    @docker exec -it wordpress sh

.PHONY: secrets rm-secrets directories up down stop start clean fclean re status show logs sh-nginx sh-maria sh-wp

