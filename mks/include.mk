########################################################################################################################
# Project environment variables
########################################################################################################################
PROGRAM_NAME := $(PARENT_DIR)
PROGRAM_NAME_LC := $(shell echo $(PROGRAM_NAME) | tr "[:upper:]" "[:lower:]")
PROGRAM_NAME_UC := $(shell echo $(PROGRAM_NAME_LC) | tr "[:lower:]" "[:upper:]")

VIRTUALENV_PATH := $(PROGRAM_PATH)/.venv/$(PROGRAM_NAME_LC)

AUTHOR_EMAIL = kchennen@unistra.fr
AUTHOR_NAME = kchennen
AUTHOR = "$(AUTHOR_NAME) <$(AUTHOR_EMAIL)>"

TEMPLATE_DIR = mks/project.tmpl
PROJECT_DIRS = $(shell find $(TEMPLATE_DIR) -type d | sed "s|^$(TEMPLATE_DIR)||" | sed '/^$$/d')
TEMPLATES = $(shell find $(TEMPLATE_DIR) -type f -name '*.tmpl')
NON_TEMPLATE_FILES = $(shell find $(TEMPLATE_DIR) -type f ! -name '*.tmpl')



########################################################################################################################
# Environment variables
########################################################################################################################
PYTHON_INTERPRETER ?= python3
PLATFORM := $(shell $(PYTHON_INTERPRETER) -c "import platform; print(platform.platform())")
ARCH = $(shell $(PYTHON_INTERPRETER) -c "import sys; print(sys.platform)")
RMTREE ?= rm -rf
MKDIR ?= mkdir -p
CAT ?= cat
SET ?= export
WHICH ?= which
DEVNULL ?= /dev/null
CMDSEP ?= ';'
DATE ?= $(shell date +%Y-%m-%d)
USERNAME ?= $(shell whoami)
COMMUNICATION_CHANNEL ?= email

# This is a minimal set of ANSI/VT100 color codes
PURPLE=\033[1;35m # Bold Purple
NO_COLOR=\033[0m # No Color

SHELL := zsh
VIRTUALENV := mamba
CONDA_ENV := conda
MAMBA_ENV := mamba
CONDA_EXE := $(shell $(WHICH) $(CONDA_ENV))  # Find the system conda executable
MAMBA_EXE := $(shell $(WHICH) $(MAMBA_ENV))  # Find the system mamba executable

ENV_LOCKFILE := $(PROGRAM_PATH)/environment.$(PLATFORM).$(ARCH).lock.yml
POST_CREATE_ENVIRONMENT_FILE := $(PROGRAM_PATH)/mks/posts/create-env.txt
POST_UPDATE_ENVIRONMENT_FILE := $(PROGRAM_PATH)/mks/posts/update-env.txt
POST_DELETE_ENVIRONMENT_FILE := $(PROGRAM_PATH)/mks/posts/delete-env.txt
POST_CREATE_PROJECT := $(PROGRAM_PATH)/mks/posts/create-project.txt
POST_DELETE_PROJECT := $(PROGRAM_PATH)/mks/posts/delete-project.txt

DEBUG_FILE := debug.log
MODULE_NAME := src
TESTS_NO_CI = $(MODULE_NAME)/tests/no_ci