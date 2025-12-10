# hpm - Hemlock Package Manager
# Makefile for building, testing, and installing

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
HEMLOCK ?= hemlock

# Default target
all: hpm

# Create hpm wrapper script (runs from source)
hpm:
	@echo '#!/bin/sh' > hpm
	@echo 'exec hemlock "$(CURDIR)/src/main.hml" "$$@"' >> hpm
	@chmod +x hpm
	@echo "Created ./hpm wrapper script"

# Build the bundled executable (NOTE: bundler has dedup bug, use install-dev instead)
build:
	$(HEMLOCK) --bundle src/main.hml -o hpm.hmlc

# Run the test suite
test:
	$(HEMLOCK) test/run.hml

# Install hpm to system (runs from source - recommended)
install:
	@mkdir -p $(BINDIR)
	@echo '#!/bin/sh' > $(BINDIR)/hpm
	@echo 'exec hemlock "$(CURDIR)/src/main.hml" "$$@"' >> $(BINDIR)/hpm
	@chmod +x $(BINDIR)/hpm
	@echo "hpm installed to $(BINDIR)/hpm"

# Install hpm using bundled version (has issues due to bundler bug)
install-bundle: build
	@mkdir -p $(BINDIR)
	@echo '#!/bin/sh' > $(BINDIR)/hpm
	@echo 'exec $(HEMLOCK) "$(PREFIX)/lib/hpm/hpm.hmlc" "$$@"' >> $(BINDIR)/hpm
	@chmod +x $(BINDIR)/hpm
	@mkdir -p $(PREFIX)/lib/hpm
	@cp hpm.hmlc $(PREFIX)/lib/hpm/
	@echo "hpm (bundled) installed to $(BINDIR)/hpm"

# Uninstall hpm from system
uninstall:
	@rm -f $(BINDIR)/hpm
	@rm -rf $(PREFIX)/lib/hpm
	@echo "hpm uninstalled"

# Clean build artifacts
clean:
	@rm -f hpm.hmlc hpm
	@echo "Cleaned build artifacts"

# Run a specific test file
test-semver:
	$(HEMLOCK) -e 'import * as t from "./test/test_semver.hml"; import { summary } from "./test/framework.hml"; t.run(); summary();'

test-manifest:
	$(HEMLOCK) -e 'import * as t from "./test/test_manifest.hml"; import { summary } from "./test/framework.hml"; t.run(); summary();'

test-lockfile:
	$(HEMLOCK) -e 'import * as t from "./test/test_lockfile.hml"; import { summary } from "./test/framework.hml"; t.run(); summary();'

test-cache:
	$(HEMLOCK) -e 'import * as t from "./test/test_cache.hml"; import { summary } from "./test/framework.hml"; t.run(); summary();'

test-integration:
	$(HEMLOCK) -e 'import * as t from "./test/test_integration.hml"; import { summary } from "./test/framework.hml"; t.run(); summary();'

# Run only unit tests (no integration)
test-unit:
	$(HEMLOCK) -e 'import * as ts from "./test/test_semver.hml"; import * as tm from "./test/test_manifest.hml"; import * as tl from "./test/test_lockfile.hml"; import * as tc from "./test/test_cache.hml"; import { summary } from "./test/framework.hml"; ts.run(); tm.run(); tl.run(); tc.run(); summary();'

# Show help
help:
	@echo "hpm Makefile targets:"
	@echo "  all             - Create hpm wrapper script (default)"
	@echo "  build           - Build bundled hpm.hmlc (has bundler bug)"
	@echo "  test            - Run all tests (unit + integration)"
	@echo "  test-unit       - Run only unit tests"
	@echo "  test-integration - Run only integration tests"
	@echo "  install         - Install hpm to system"
	@echo "  install-bundle  - Install bundled version (has issues)"
	@echo "  uninstall       - Remove hpm from system"
	@echo "  clean           - Remove build artifacts"
	@echo "  test-semver     - Run only semver tests"
	@echo "  test-manifest   - Run only manifest tests"
	@echo "  test-lockfile   - Run only lockfile tests"
	@echo "  test-cache      - Run only cache tests"
	@echo "  help            - Show this help"
	@echo ""
	@echo "Variables:"
	@echo "  PREFIX       - Installation prefix (default: /usr/local)"
	@echo "  HEMLOCK      - Hemlock interpreter (default: hemlock)"

.PHONY: all hpm build test test-unit test-integration install install-bundle uninstall clean help test-semver test-manifest test-lockfile test-cache
