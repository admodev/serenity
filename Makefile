# Compiler and flags
CC := gcc
CFLAGS := -std=c99 -Wall -Wextra -Werror -g

# Define variables
SRC_EXT := c
BUILD_DIR := build
SRC_FILES := $(shell find . -type f -name '*.$(SRC_EXT)')
OBJ_FILES := $(patsubst %.c, $(BUILD_DIR)/%.o, $(SRC_FILES))
TARGET := $(BUILD_DIR)/app

FORMAT_CMD := clang-format -i
TIDY_CMD := clang-tidy

.PHONY: all format tidy build test clean debug

# Default target
all: format tidy build test

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

# Build all .c files
build: $(TARGET)

$(TARGET): $(SRC_FILES)
	@echo "Building project..."
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $(SRC_FILES) -o $(TARGET)
	@echo "Build complete: $(TARGET)"

# Run tests
test: $(TARGET)
	@echo "Running tests..."
	@if [ ! -f $(TARGET) ]; then \
		echo "Error: Build the project first using 'make build'."; \
		exit 1; \
	else \
		echo "Running application:"; \
		$(TARGET); \
	fi

# Clean up build directory
clean:
	@echo "Cleaning up..."
	@rm -rf $(BUILD_DIR)
	@echo "Clean complete."

# Debugging targets
debug:
	@echo "SRC_FILES: $(SRC_FILES)"
	@echo "OBJ_FILES: $(OBJ_FILES)"

