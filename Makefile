wp_volume_name = wordpress-data
db_volume_name = db-data

volume_root = /home/$(USER)/data/

volume_dirs = $(addprefix $(volume_root), $(wp_volume_name) $(db_volume_name))

docker_compose= docker compose -f srcs/docker-compose.yml

$(volume_root):
	mkdir -p $@

$(volume_dirs): $(volume_root)
	mkdir -p $@

clean:
	$(docker_compose) down -v --rmi all

build: $(volume_dirs)
	$(docker_compose) build

stop:
	$(docker_compose) stop

up: $(volume_dirs)
	$(docker_compose) up -d

docker_ps:
	$(docker_compose) ps 

docker_ls:
	$(docker_compose) ls 

mariadb_sh:
	$(docker_compose) exec mariadb sh

nginx_sh:
	$(docker_compose) exec nginx sh

wordpress_sh:
	$(docker_compose) exec wordpress sh

all: build

PHONY: clean clean_containers clean_volumes up build stop up all
