# Check if "docker-compose" is available, and if not, use "docker compose."
ifeq (, $(shell which docker-compose))
    DOCKER_COMPOSE_CMD := docker compose up --build
else
    DOCKER_COMPOSE_CMD := docker-compose up --build
endif

run:
	$(DOCKER_COMPOSE_CMD)

# Check if "docker-compose" is available, and if not, use "docker compose."
ifeq (, $(shell which docker-compose))
    DOCKER_COMPOSE_STOP := docker compose stop
else
    DOCKER_COMPOSE_STOP := docker-compose stop
endif
stop:
	$(DOCKER_COMPOSE_STOP)

mod:
	go mod tidy && go mod vendor

test:
	go test ./...

cover:
	go test ./... -cover