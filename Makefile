PROJECT = haiku-rv
COMPOSE = docker compose -p $(PROJECT)

io:
	mkdir -p $@

.PHONY: image
image:
	$(COMPOSE) build capsule

.PHONY: sh
sh: io
	$(COMPOSE) run --rm shell

.PHONY: build
build: io
	$(COMPOSE) run --rm builder

.PHONY: clean
clean:
	$(COMPOSE) down --remove-orphans

.PHONY: distclean
distclean:
	$(COMPOSE) down --remove-orphans
	test -d io && rm -rf io
