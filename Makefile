wp_volume_name = wordpress-data
db_volume_name = db-data

volume_dirs = /home/$(USER)/$(wp_volume_name) /home/$(USER)/$(db_volume_name)

docker_compose= docker compose -f srcs/docker-compose.yml

$(volume_dirs): 
	mkdir -p $@

clean_volumes: stop
	docker volume rm $(wp_volume_name) $(db_volume_name)
	rm -rf $(volume_dirs)

clean_containers: stop
	docker container rm mariadb wordpress nginx

clean: clean_containers clean_volumes

build: $(volume_dirs)
	$(docker_compose) build

stop:
	$(docker_compose) stop

up: $(volume_dirs)
	$(docker_compose) up -d

all: build

PHONY: clean clean_containers clean_volumes up build stop up all
