PREFIX = "/usr/local"
CONFIG_FILE = config.mk
.ONESHELL:
# Automatically find scripts in the current directory, excluding 'archive' directory
SCRIPTS := $(shell find . -maxdepth 1 -name "*.sh" -not -path "./archive/*" -exec basename {} \;)

# Include configuration if it exists
-include $(CONFIG_FILE)

# Target to create a default config.mk file with write permissions
config:
	@if [ ! -f $(CONFIG_FILE) ]; then \
		echo "# Creating default config.mk"
		for script in $(SCRIPTS); do \
			script_name=$$(basename $$script .sh)
			echo "$$script_name=0" >> $(CONFIG_FILE)
		done
		chmod 644 $(CONFIG_FILE)
	else \
		echo "$(CONFIG_FILE) already exists."
	fi

install:
	@for i in $$(cat ${CONFIG_FILE}); do
		eval INSTALL=\$$$${i}
		INSTALL=$${INSTALL#?}
		script_name=$$( echo $$i | sed 's/=.*//')
		if [ $$INSTALL = 1 ]; then \
			cp $$script_name.sh ${PREFIX}/bin/$$script_name
			echo "installed $$script_name"
		else \
		  if [ -f ${PREFIX}/bin/$$script_name ]; then
			  rm ${PREFIX}/bin/$$script_name
				echo "removed $$script_name"
			fi
		fi
	done
