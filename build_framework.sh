#! /bin/bash

set  -e

xcodebuild archive \
-scheme HandsetAssistant \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './build/HandsetAssistant.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme HandsetAssistant \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './build/HandsetAssistant.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild -create-xcframework \
-framework './build/HandsetAssistant.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/HandsetAssistant.framework' \
-framework './build/HandsetAssistant.framework-iphoneos.xcarchive/Products/Library/Frameworks/HandsetAssistant.framework' \
-output './build/HandsetAssistant.xcframework'
