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

# Build a static standalone binary (self-contained, no runtime dependencies)
build:
	hemlockc --static src/main.hml -o hpm-static
	@echo "Built static binary: hpm-static"

# Build the bundled bytecode (NOTE: bundler has dedup bug)
build-bundle:
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

# Install hpm using static binary (recommended for distribution)
install-static: build
	@mkdir -p $(BINDIR)
	@cp hpm-static $(BINDIR)/hpm
	@chmod +x $(BINDIR)/hpm
	@echo "hpm (static binary) installed to $(BINDIR)/hpm"

# Install hpm using bundled version (has issues due to bundler bug)
install-bundle: build-bundle
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
	@rm -f hpm.hmlc hpm hpm-static
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
	@echo "  all            - Create hpm wrapper script (default)"
	@echo "  build          - Build static standalone binary"
	@echo "  build-bundle   - Build bundled hpm.hmlc (has bundler bug)"
	@echo "  test           - Run all tests"
	@echo "  install        - Install hpm to system (runs from source)"
	@echo "  install-static - Install static binary (recommended)"
	@echo "  install-bundle - Install bundled version (has issues)"
	@echo "  uninstall      - Remove hpm from system"
	@echo "  clean          - Remove build artifacts"
	@echo "  test-semver    - Run only semver tests"
	@echo "  test-manifest  - Run only manifest tests"
	@echo "  test-lockfile  - Run only lockfile tests"
	@echo "  test-cache     - Run only cache tests"
	@echo "  help           - Show this help"
	@echo ""
	@echo "Variables:"
	@echo "  PREFIX       - Installation prefix (default: /usr/local)"
	@echo "  HEMLOCK      - Hemlock interpreter (default: hemlock)"

.PHONY: all hpm build build-bundle test install install-static install-bundle uninstall clean help test-semver test-manifest test-lockfile test-cache
