#define _POSIX_C_SOURCE 200809L
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

#include "../include/sysctllib.h"

typedef struct {
  char *buffer;
  size_t buffer_length;
  ssize_t input_length;
} InputBuffer;

typedef enum {
  CMD_EXIT,
  CMD_EMPTY,
  CMD_HELP,
  CMD_TERMCLEAR,
  CMD_SYSCTL_ALLSTATUS,
  CMD_UNKNOWN
} Command;

Command get_command(const char *input) {
  if (strcmp(input, "exit") == 0) {
    return CMD_EXIT;
  } else if (strcmp(input, "") == 0) {
    return CMD_EMPTY;
  } else if (strcmp(input, "help") == 0) {
    return CMD_HELP;
  } else if (strcmp(input, "sc -c") == 0) {
    return CMD_TERMCLEAR;
  } else if (strcmp(input, "svcs -s -a") == 0) {
    return CMD_SYSCTL_ALLSTATUS;
  } else {
    return CMD_UNKNOWN;
  }
}

InputBuffer *new_input_buffer() {
  InputBuffer *input_buffer = malloc(sizeof(InputBuffer));
  input_buffer->buffer = NULL;
  input_buffer->buffer_length = 0;
  input_buffer->input_length = 0;

  return input_buffer;
}

void print_help_message() {
  printf("Available commands are: exit, help, sc, svcs.\n");
}

void print_prompt() { printf("-> "); }

void read_input(InputBuffer *input_buffer) {
  ssize_t bytes_read =
      getline(&(input_buffer->buffer), &(input_buffer->buffer_length), stdin);

  if (bytes_read <= 0) {
    printf("Error reading input\n");
    exit(EXIT_FAILURE);
  }

  input_buffer->input_length = bytes_read - 1;
  //-1 to Ignore trailing newline
  input_buffer->buffer[bytes_read - 1] = 0;
}

void close_input_buffer(InputBuffer *input_buffer) {
  free(input_buffer->buffer);
  free(input_buffer);
}

int main() {
  InputBuffer *input_buffer = new_input_buffer();

  printf("S.e.r.e.n.i.t.y.\n");
  while (true) {
    print_prompt();
    read_input(input_buffer);

    switch (get_command(input_buffer->buffer)) {
    case CMD_EXIT:
      close_input_buffer(input_buffer);
      exit(EXIT_SUCCESS);
      break;
    case CMD_EMPTY:
      break;
    case CMD_HELP:
      print_help_message();
      break;
    case CMD_TERMCLEAR:
      printf("Clear screen...\n");
      break;
    case CMD_SYSCTL_ALLSTATUS:
      check_all_services();
      break;
    default:
      printf("Unrecognized command '%s'. To get help on how to use this system "
             "use: help\n",
             input_buffer->buffer);
      break;
    }
  }
}
