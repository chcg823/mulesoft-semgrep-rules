# =============================================================================
# MuleSoft Semgrep Scanner — Makefile
# =============================================================================
# Usage:
#   make scan         PROJECT=path/to/mule-project
#   make scan-sec     PROJECT=path/to/mule-project
#   make scan-rel     PROJECT=path/to/mule-project
#   make scan-perf    PROJECT=path/to/mule-project
#   make scan-maint   PROJECT=path/to/mule-project
#   make ci           PROJECT=path/to/mule-project   (security ERRORs/WARNINGs, exit 1 on findings)
# =============================================================================

RULES_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))rules
PROJECT   ?= .
SEMGREP   := semgrep

.PHONY: scan scan-sec scan-rel scan-perf scan-maint ci help

## Run all rules
scan:
	$(SEMGREP) --config $(RULES_DIR)/ $(PROJECT)

## Security rules only
scan-sec:
	$(SEMGREP) --config $(RULES_DIR)/security/ $(PROJECT)

## Reliability rules only
scan-rel:
	$(SEMGREP) --config $(RULES_DIR)/reliability/ $(PROJECT)

## Performance rules only
scan-perf:
	$(SEMGREP) --config $(RULES_DIR)/performance/ $(PROJECT)

## Maintainability rules only
scan-maint:
	$(SEMGREP) --config $(RULES_DIR)/maintainability/ $(PROJECT)

## CI gate — security ERRORs and WARNINGs cause non-zero exit
ci:
	$(SEMGREP) --config $(RULES_DIR)/security/ \
	           --severity ERROR --severity WARNING \
	           --error \
	           $(PROJECT)

help:
	@echo ""
	@echo "  make scan        PROJECT=<path>   Run all rules"
	@echo "  make scan-sec    PROJECT=<path>   Security rules only"
	@echo "  make scan-rel    PROJECT=<path>   Reliability rules"
	@echo "  make scan-perf   PROJECT=<path>   Performance rules"
	@echo "  make scan-maint  PROJECT=<path>   Maintainability rules"
	@echo "  make ci          PROJECT=<path>   Security gate for CI/CD pipelines"
	@echo "  make effective   PROJECT=<path>   Generate and scan effective POM"
	@echo ""

effective:
	cd $(PROJECT) && mvn help:effective-pom -Doutput=effective-pom.xml
	$(SEMGREP) --config $(RULES_DIR)/maintainability/pom.yaml $(PROJECT)/effective-pom.xml
	cd $(PROJECT) && rm effective-pom.xml
