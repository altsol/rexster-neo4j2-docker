NAME = altsol/rexster-neo4j2
VERSION = 2.6.0

.PHONY: all build tag_latest

all: prepare_neo4j2 build cleanup

build:
	docker build -t $(NAME):$(VERSION) --rm .

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

prepare_neo4j2:
	cd neo4j2-ext && mvn dependency:copy-dependencies

cleanup:
	rm -rf neo4j2-ext/target

test:
	env NAME=$(NAME) VERSION=$(VERSION) ./test.sh
