# Compiler and flags
CC := gcc
CFLAGS := -std=c99 -Wall -Wextra -Werror -g
TESTCFLAGS := -lcmocka

# Define variables
SRC_EXT := c
BUILD_DIR := build
TESTS_DIR := tests
TESTS_BUILD_DIR := $(BUILD_DIR)/tests
SRC_FILES := $(shell find . -type f -name '*.$(SRC_EXT)' ! -path './$(TESTS_DIR)/*')
OBJ_FILES := $(patsubst %.c, $(BUILD_DIR)/%.o, $(SRC_FILES))
TEST_FILES := $(shell find $(TESTS_DIR) -type f -name '*.$(SRC_EXT)')
TARGET := $(BUILD_DIR)/serenity

FORMAT_CMD := clang-format -i
TIDY_CMD := clang-tidy

.PHONY: all format tidy build-db build test clean debug

# Default target
all: format tidy build test

# Format all .c files, excluding tests/
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

# Run clang-tidy on all .c files, excluding tests/
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

# Generate compilation database
build-db:
	bear -- make build

# Build all .c files, excluding tests/
build: $(TARGET)

$(TARGET): $(SRC_FILES)
	@echo "Building project..."
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $(SRC_FILES) -o $(TARGET)
	@echo "Build complete: $(TARGET)"

# Build test files
build-tests: $(TEST_FILES)
	@echo "Building tests..."
	@mkdir -p $(TESTS_BUILD_DIR)
	$(CC) -o $(TESTS_BUILD_DIR)/test_executable $(TEST_FILES) $(TESTCFLAGS)
	@echo "Tests built: $(TESTS_BUILD_DIR)/test_executable"

# Run tests
test: build-tests
	@echo "Running tests..."
	@if [ ! -f $(TESTS_BUILD_DIR)/test_executable ]; then \
                echo "Error: Build the tests first using 'make build-tests'."; \
                exit 1; \
        else \
                ./$(TESTS_BUILD_DIR)/test_executable; \
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

