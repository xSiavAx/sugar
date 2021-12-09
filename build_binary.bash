set -x

PROJECT_NAME="SSSugar"
OUT_DIR=".."

FRAMEWORK_FOLDER_NAME="${PROJECT_NAME}_XCFramework"
OUT_PATH="${OUT_DIR}/${FRAMEWORK_FOLDER_NAME}"
FRAMEWORK_NAME="${PROJECT_NAME}"

SIMULATOR_ARCHIVE_PATH="${OUT_PATH}/simulator.xcarchive"
IOS_DEVICE_ARCHIVE_PATH="${OUT_PATH}/iOS.xcarchive"

DOCS_PATH="${OUT_PATH}/docs"

rm -rf "${OUT_PATH}"
echo "Deleted ${OUT_PATH}"
mkdir "${FRAMEWORK_FOLDER_NAME}"

echo "Created ${FRAMEWORK_FOLDER_NAME}"
echo "Archiving ${FRAMEWORK_NAME}"
xcodebuild archive -scheme ${FRAMEWORK_NAME} -destination="iOS Simulator" -archivePath "${SIMULATOR_ARCHIVE_PATH}" -sdk iphonesimulator SKIP_INSTALL=NO
xcodebuild archive -scheme ${FRAMEWORK_NAME} -destination="iOS" -archivePath "${IOS_DEVICE_ARCHIVE_PATH}" -sdk iphoneos SKIP_INSTALL=NO

#Creating XCFramework
echo "Creating XCFramework ${FRAMEWORK_NAME}"
xcodebuild -create-xcframework -framework ${SIMULATOR_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}Core.framework -framework ${IOS_DEVICE_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}Core.framework -output "${OUT_PATH}/${FRAMEWORK_NAME}Core.xcframework"
xcodebuild -create-xcframework -framework ${SIMULATOR_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}UIKit.framework -framework ${IOS_DEVICE_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}UIKit.framework -output "${OUT_PATH}/${FRAMEWORK_NAME}UIKit.xcframework"

exit 1
rm -rf "${SIMULATOR_ARCHIVE_PATH}"
rm -rf "${IOS_DEVICE_ARCHIVE_PATH}"

# echo "Generating docs"
# jazzy --min-acl internal --no-hide-documentation-coverage --theme fullwidth --output $DOCS_PATH


open "${OUT_PATH}"

exit 1
