.PHONY: fmt lint module project

fmt:
	terraform fmt -write -recursive

lint:
	terraform fmt -check -list -diff -recursive

define create_module		
	mkdir -p $(1)/$(2)

	touch $(1)/$(2)/{main,outputs,providers,variables}.tf
	touch $(1)/$(2)/readme.md

	for file in $(3); do \
		touch $(1)/$(2)/$$file; \
	done
endef

module:
ifeq ($(name),)
	$(error module name must be provided)
endif

	$(call create_module,modules,$(name))

project:
ifeq ($(name),)
	$(error project name must be provided)
endif

	$(call create_module,projects,$(name),backend.tf)
