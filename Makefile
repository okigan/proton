THIS_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

DYLD_FALLBACK_LIBRARY_PATH=${THIS_DIR}proton/.build/x86_64-apple-macosx/debug

.PHONY: install
install:
	cd protonappui && yarn install

# .PHONY: xcodeproj
# xcodeproj:
# 	cd proton && swift package generate-xcodeproj

.PHONY: build-ui
build-ui:
	cd protonappui && yarn build

.PHONY: build-swift
build-swift:
	cd proton-swift && swift build && swift test

.PHONY: build-go
build-go:
	cd proton && go build ./... && DYLD_FALLBACK_LIBRARY_PATH=${DYLD_FALLBACK_LIBRARY_PATH} go test ./...


.PHONY: build
build: build-ui build-swift build-go

.PHONY: run
run:
	cd protongo && DYLD_FALLBACK_LIBRARY_PATH=${DYLD_FALLBACK_LIBRARY_PATH} go run . 

