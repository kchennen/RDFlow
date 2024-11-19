########################################################################################################################
# Program environment variables
########################################################################################################################
# Get the name of the parent directory
PARENT_DIR := $(shell basename "$(shell dirname "$(realpath $(lastword $(MAKEFILE_LIST)))")")

# Get the path of the program directory
PROGRAM_PATH := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Load program logo
LOGO_FILE := logo.txt
LOGO := $(shell cat $(LOGO_FILE) | sed 's/^/\\n/')
export LOGO

# Load program environment variables
include mks/include.mk
include mks/help.mk

