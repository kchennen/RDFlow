########################################################################################################################
# Environment Management Makefile
########################################################################################################################

make_lockfile: environment.yaml
ifeq (mamba, $(VIRTUALENV))
	@$(MAMBA_ENV) env export --prefix=$(VIRTUALENV_PATH) --file $(ENV_LOCKFILE)
endif


.PHONY: create_environment
## Set up virtual (conda) environment for this project
create_environment: environment.yaml
ifeq (mamba, $(VIRTUALENV))
	@echo
	@echo -e "ℹ️  Creating mamba environment: $(PROJECT_NAME)\n"
	$(MAMBA_ENV) env create --prefix=$(VIRTUALENV_PATH) --file $<
	@echo
	@echo -e "ℹ️  Creating lockfile: $(PROJECT_NAME)\n"
	@$(MAMBA_ENV) env export --prefix=$(VIRTUALENV_PATH) --file $(ENV_LOCKFILE)
ifneq ("X$(wildcard $(POST_CREATE_ENVIRONMENT_FILE))","X")
	@cat $(POST_CREATE_ENVIRONMENT_FILE) | \
	sed 's|\[PROJECT_NAME\]|$(PROJECT_NAME)|g' | \
	sed 's|\[VIRTUALENV_PATH\]|$(VIRTUALENV_PATH)|g'
endif
else
	$(error Unsupported Environment `$(VIRTUALENV)`. Use conda)
endif


.PHONY: delete_environment
## Delete the virtual (conda) environment for this project
delete_environment:
ifeq (mamba, $(VIRTUALENV))
	@echo "⚠️  Deleting conda environment: $(PROJECT_NAME)"
	@${MAMBA_ENV} env remove --prefix=$(VIRTUALENV_PATH)
	@echo "⚠️  Deleting lockfile: $(ENV_LOCKFILE)"
	@rm -f $(ENV_LOCKFILE)
ifneq ("X$(wildcard $(POST_DELETE_ENVIRONMENT_FILE))","X")
	@echo
	@cat $(POST_DELETE_ENVIRONMENT_FILE) | \
	sed 's|\[YYYY-MM-DD\]|$(DATE)|g' | \
	sed 's|\[VIRTUALENV\]|$(VIRTUALENV)|g' | \
	sed 's|\[VIRTUALENV_PATH\]|$(VIRTUALENV_PATH)|g' | \
	sed 's|\[USERNAME\]|$(USERNAME)|g'
endif
else
	$(error Unsupported Environment `$(VIRTUALENV)`. Use conda)
endif


.PHONY: environment_enabled
# Checks if the project conda environment is active
environment_enabled:
ifeq ($(CONDA_DEFAULT_ENV),$(VIRTUALENV_PATH))
	@echo
	@echo "✅ Conda environment '$(VIRTUALENV_PATH)' is active."
else
	@echo
	@echo "❌ Conda environment '$(VIRTUALENV_PATH)' is not active."
	@echo
	@echo "👉 Activate the environment:\n \
		>>> conda activate $(VIRTUALENV_PATH)"
	@exit 1
endif


.PHONY: check_lockfile
# Test that an environment lockfile exists
check_lockfile:
@echo "ℹ️  Checking lockfile: $(ENV_LOCKFILE)"
ifeq (X,X$(wildcard $(ENV_LOCKFILE)))
	$(error Run "make update_environment" before proceeding...)
endif


.PHONY: update_environment
## Install or update Python Dependencies in the virtual (conda) environment
update_environment: environment.yaml environment_enabled check_lockfile
ifeq (mamba, $(VIRTUALENV))
	@echo
	@echo "ℹ️  Updating conda environment: $(PROJECT_NAME)"
	@$(MAMBA_ENV) env update --quiet --prefix=$(VIRTUALENV_PATH) --file environment.yaml
	@$(MAMBA_ENV) env export --prefix=$(VIRTUALENV_PATH) --file $(ENV_LOCKFILE)
	# @echo
	# @echo "ℹ️  Updating Python dependencies: $(PROJECT_NAME)"
	# @pip install -e .  # uncomment for conda <= 4.3
	@echo
	@echo "✅ $(PROJECT_NAME) conda environment was successfully updated!"
ifneq ("X$(wildcard .post-update-environment.txt)","X")
	@cat .post-update-environment.txt
endif
else
	$(error ERROR: Unsupported Environment `$(VIRTUALENV)`. Use conda)
endif


.PHONY: check_environment
## Check if environment is enabled and correctly configured
check_environment: environment_enabled check_lockfile
	@echo
	@echo "✅ $(PROJECT_NAME) conda environment is enabled and correctly configured!"


.PHONY: debug_environment
## dump useful debugging information to $(DEBUG_FILE)
debug_environment:
	@echo
	@echo "=========================================================================================="
	@echo "- Please include the contents '$(DEBUG_FILE)' when submitting an issue or support request."
	@echo "=========================================================================================="
	@echo "##=========================================================================" > $(DEBUG_FILE)
	@echo "## Git status" >> $(DEBUG_FILE)
	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "ℹ️  Checking git status...\n"
	@git status >> $(DEBUG_FILE)
	@echo >> $(DEBUG_FILE)

	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "## Git log" >> $(DEBUG_FILE)
	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "ℹ️  Checking git log...\n"
	@git log -8 --graph --oneline --decorate --all >> $(DEBUG_FILE)
	@echo >> $(DEBUG_FILE)

	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "## Github remotes" >> $(DEBUG_FILE)
	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "ℹ️  Checking Github remote...\n"
	@git remote -v >> $(DEBUG_FILE)
	@echo >> $(DEBUG_FILE)

	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "## Github authentification" >> $(DEBUG_FILE)
	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "ℹ️  Checking Github authentification...\n"
	@gh auth status 2>&1 | cat >> $(DEBUG_FILE)
	@echo >> $(DEBUG_FILE)

	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "## Conda config" >> $(DEBUG_FILE)
	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "ℹ️  Checking conda configs...\n"
	@conda config --get >> $(DEBUG_FILE)
	@echo >> $(DEBUG_FILE)

	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "## Conda info" >> $(DEBUG_FILE)
	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "ℹ️  Checking conda info...\n"
	@$(MAMBA_ENV) info  >> $(DEBUG_FILE)
	@echo >> $(DEBUG_FILE)

	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "## Conda list" >> $(DEBUG_FILE)
	@echo "##=========================================================================" >> $(DEBUG_FILE)
	@echo "ℹ️  Checking conda list...\n"
	@$(MAMBA_ENV) list >> $(DEBUG_FILE)

	@echo "✅  Created environment debug file: $(DEBUG_FILE)"
