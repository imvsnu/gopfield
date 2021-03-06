BUILD=go build
CLEAN=go clean
INSTALL=go install
BUILDPATH=./_build
PACKAGES=$(shell go list ./... | grep -v /examples/)
EXAMPLES=$(shell find examples/* -maxdepth 0 -type d -exec basename {} \;)

examples: builddir
	for example in $(EXAMPLES); do \
		go build -o "$(BUILDPATH)/$$example" "examples/$$example/$$example.go"; \
	done

all: examples

mnist: builddir
	go build -o "$(BUILDPATH)/mnist" "examples/mnist/mnist.go"

builddir:
	mkdir -p $(BUILDPATH)

install:
	$(INSTALL) ./$(EXDIR)/...

clean:
	rm -rf $(BUILDPATH)

dep:
	go get ./...

check:
	for pkg in ${PACKAGES}; do \
		go vet $$pkg || exit ; \
	done

test:
	for pkg in ${PACKAGES}; do \
		go test -coverprofile="../../../$$pkg/coverage.txt" -covermode=atomic $$pkg || exit; \
	done

.PHONY: clean examples
