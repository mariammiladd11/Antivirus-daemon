DIR=test_dir
MAL_DIR=malicious_dir
INTERVAL=5

all:
	mkdir -p $(MAL_DIR)

run:
	./antivirusd.sh $(DIR) $(MAL_DIR) $(INTERVAL)

restore:
	./restore.sh $(DIR) $(MAL_DIR)
