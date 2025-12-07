# hpm - Hemlock Package Manager
# Makefile for building, testing, and installing

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
HEMLOCK ?= hemlock

# Default target
all: build

# Build the bundled executable
build:
	$(HEMLOCK) --bundle src/main.hml -o hpm.hmlc

# Run the test suite
test:
	$(HEMLOCK) test/run.hml

# Install hpm to system
install: build
	@mkdir -p $(BINDIR)
	@echo '#!/bin/sh' > $(BINDIR)/hpm
	@echo 'exec $(HEMLOCK) "$(PREFIX)/lib/hpm/hpm.hmlc" "$$@"' >> $(BINDIR)/hpm
	@chmod +x $(BINDIR)/hpm
	@mkdir -p $(PREFIX)/lib/hpm
	@cp hpm.hmlc $(PREFIX)/lib/hpm/
	@echo "hpm installed to $(BINDIR)/hpm"

# Install hpm (alternative: run directly from source)
install-dev:
	@mkdir -p $(BINDIR)
	@echo '#!/bin/sh' > $(BINDIR)/hpm
	@echo 'exec $(HEMLOCK) "$(CURDIR)/src/main.hml" "$$@"' >> $(BINDIR)/hpm
	@chmod +x $(BINDIR)/hpm
	@echo "hpm (dev) installed to $(BINDIR)/hpm"

# Uninstall hpm from system
uninstall:
	@rm -f $(BINDIR)/hpm
	@rm -rf $(PREFIX)/lib/hpm
	@echo "hpm uninstalled"

# Clean build artifacts
clean:
	@rm -f hpm.hmlc
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

# Show help
help:
	@echo "hpm Makefile targets:"
	@echo "  all          - Build hpm (default)"
	@echo "  build        - Build bundled hpm.hmlc"
	@echo "  test         - Run all tests"
	@echo "  install      - Install hpm to system (requires sudo)"
	@echo "  install-dev  - Install hpm running from source"
	@echo "  uninstall    - Remove hpm from system"
	@echo "  clean        - Remove build artifacts"
	@echo "  test-semver  - Run only semver tests"
	@echo "  test-manifest - Run only manifest tests"
	@echo "  test-lockfile - Run only lockfile tests"
	@echo "  test-cache   - Run only cache tests"
	@echo "  help         - Show this help"
	@echo ""
	@echo "Variables:"
	@echo "  PREFIX       - Installation prefix (default: /usr/local)"
	@echo "  HEMLOCK      - Hemlock interpreter (default: hemlock)"

.PHONY: all build test install install-dev uninstall clean help test-semver test-manifest test-lockfile test-cache
