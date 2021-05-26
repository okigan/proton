.PHONY: install
install:
	cd protonappui && yarn install

# .PHONY: xcodeproj
# xcodeproj:
# 	cd proton && swift package generate-xcodeproj

.PHONY: build-ui
build-ui:
	cd protonappui && yarn build

.PHONY: build-backend-cocoa
build-backend-cocoa:
	cd proton-backend-cocoa && swift build

.PHONY: build-go
build-go:
	cd proton && go build ./... && go test ./...


.PHONY: build
build: build-ui build-backend-cocoa build-go

.PHONY: run
run:
	cd protonapp && go run . 

.PHONY: self-test
self-test:
	cd protonapp && go run . --self-test

