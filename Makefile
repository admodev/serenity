SRC_EXT := c
FORMAT_CMD := clang-format -i
TIDY_CMD := clang-tidy

# Find all .c files
SRC_FILES := $(shell find . -type f -name '*.$(SRC_EXT)')

.PHONY: all format tidy

all: format tidy

# Format all .c files
format:
	@echo "Running clang-format on all .$(SRC_EXT) files..."
	@if [ -z "$(SRC_FILES)" ]; then \
		echo "No .$(SRC_EXT) files found."; \
	else \
		for file in $(SRC_FILES); do \
			echo "Formatting $$file..."; \
			$(FORMAT_CMD) $$file; \
		done; \
	fi

# Run clang-tidy on all .c files
tidy:
	@echo "Running clang-tidy on all .$(SRC_EXT) files..."
	@if [ -z "$(SRC_FILES)" ]; then \
		echo "No .$(SRC_EXT) files found."; \
	else \
		for file in $(SRC_FILES); do \
			echo "Running clang-tidy on $$file..."; \
			$(TIDY_CMD) $$file; \
		done; \
	fi

