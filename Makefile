DIR ?= test_dir
MAL_DIR ?= malicious_dir
INTERVAL ?= 5

.PHONY: all prebuild run restore

all: run

prebuild:
	mkdir -p $(MAL_DIR)

run: prebuild
	./antivirusd.sh $(DIR) $(MAL_DIR) $(INTERVAL)

restore: prebuild
	./restore.sh $(DIR) $(MAL_DIR)
