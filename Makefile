APP_NAME := SimplyNFCApp
BUILD_DIR := build
PROJECT_DIR := $(BUILD_DIR)/$(APP_NAME).xcodeproj
ARCHIVE_PATH := $(BUILD_DIR)/$(APP_NAME).xcarchive
IPA_PATH := $(BUILD_DIR)/$(APP_NAME).ipa
TIPA_PATH := $(BUILD_DIR)/$(APP_NAME).tipa
DERIVED_DATA := $(BUILD_DIR)/DerivedData
SCHEME := $(APP_NAME)
SDK := iphoneos
CONFIG := Release
ARCH := arm64

.PHONY: all package ipa tipa clean generate project

all: package

project: $(PROJECT_DIR)

$(PROJECT_DIR):
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && xcodegen generate --spec ../project.yml

$(ARCHIVE_PATH): project
	xcodebuild -project $(PROJECT_DIR) \
	  -scheme $(SCHEME) \
	  -configuration $(CONFIG) \
	  -derivedDataPath $(DERIVED_DATA) \
	  -sdk $(SDK) \
	  -arch $(ARCH) \
	  clean archive \
	  -archivePath $(ARCHIVE_PATH) \
	  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO

ipa: $(ARCHIVE_PATH)
	mkdir -p $(BUILD_DIR)/Payload
	rm -f $(IPA_PATH)
	cp -r "$(ARCHIVE_PATH)/Products/Applications/$(APP_NAME).app" "$(BUILD_DIR)/Payload/"
	cd $(BUILD_DIR) && zip -r "$(APP_NAME).ipa" "Payload" > /dev/null
	rm -rf $(BUILD_DIR)/Payload

tipa: ipa
	mkdir -p $(BUILD_DIR)
	cp "$(IPA_PATH)" "$(TIPA_PATH)"

package: ipa
	@echo "Built $(IPA_PATH)"
	@if [ "$(TROLLSTORE)" = "1" ]; then cp "$(IPA_PATH)" "$(TIPA_PATH)" && echo "Built $(TIPA_PATH)"; fi

clean:
	rm -rf $(BUILD_DIR)
