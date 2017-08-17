set -e
######################
# Avoid recursively calling this script.
######################
set +u
if [[ $SF_MASTER_SCRIPT_RUNNING ]]
	then
	exit 0
fi
	set -u
export SF_MASTER_SCRIPT_RUNNING=1

######################
# Options
######################

REVEAL_ARCHIVE_IN_FINDER=false

FRAMEWORK_NAME="${PROJECT_NAME}"

SIMULATOR_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}.framework"

DEVICE_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework"

UNIVERSAL_LIBRARY_DIR="${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal"

FRAMEWORK="${UNIVERSAL_LIBRARY_DIR}/${FRAMEWORK_NAME}.framework"


######################
# Build Frameworks
######################

xcodebuild -workspace ${PROJECT_NAME}.xcworkspace -scheme ${PROJECT_NAME} -sdk iphonesimulator -configuration ${CONFIGURATION} OTHER_CFLAGS="-fembed-bitcode" clean build CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphonesimulator 2>&1

xcodebuild -workspace ${PROJECT_NAME}.xcworkspace -scheme ${PROJECT_NAME} -sdk iphoneos -configuration ${CONFIGURATION} OTHER_CFLAGS="-fembed-bitcode" clean build CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphoneos 2>&1

######################
# Create directory for universal
######################

rm -rf "${UNIVERSAL_LIBRARY_DIR}"

mkdir "${UNIVERSAL_LIBRARY_DIR}"

mkdir "${FRAMEWORK}"


######################
# Copy files Framework
######################

cp -r "${DEVICE_LIBRARY_PATH}/." "${FRAMEWORK}"


######################
# Make an universal binary
######################

lipo "${SIMULATOR_LIBRARY_PATH}/${FRAMEWORK_NAME}" "${DEVICE_LIBRARY_PATH}/${FRAMEWORK_NAME}" -create -output "${FRAMEWORK}/${FRAMEWORK_NAME}" | echo

# For Swift framework, Swiftmodule needs to be copied in the universal framework
if [ -d "${SIMULATOR_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/" ]; then
    cp -f ${SIMULATOR_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/* "${FRAMEWORK}/Modules/${FRAMEWORK_NAME}.swiftmodule/" | echo
fi
                                                                      
if [ -d "${DEVICE_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/" ]; then
    cp -f ${DEVICE_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/* "${FRAMEWORK}/Modules/${FRAMEWORK_NAME}.swiftmodule/" | echo
fi

######################
# On Release, copy the result to release directory
######################
#echo "start output"
#echo "output universal"
#BASE_DIR_OUTPUT="${PROJECT_DIR}/Frameworks"
BASE_DIR_OUTPUT="${PROJECT_DIR}/../${FRAMEWORK_NAME}/Frameworks"
rm -rf "${BASE_DIR_OUTPUT}"

OUTPUT_DIR_UNIVERSAL="${BASE_DIR_OUTPUT}/${FRAMEWORK_NAME}-${CONFIGURATION}-iphoneuniversal/"

rm -rf "${OUTPUT_DIR_UNIVERSAL}"
mkdir -p "${OUTPUT_DIR_UNIVERSAL}"

cp -r "${FRAMEWORK}" "${OUTPUT_DIR_UNIVERSAL}"
#mv "${OUTPUT_DIR_UNIVERSAL}${FRAMEWORK_NAME}.framework" "${OUTPUT_DIR_UNIVERSAL}${FRAMEWORK_NAME}.framework"

#echo "output simulator"
OUTPUT_DIR_SIMULATOR="${BASE_DIR_OUTPUT}/${FRAMEWORK_NAME}-${CONFIGURATION}-iphonesimulator/"

rm -rf "$OUTPUT_DIR_SIMULATOR"
mkdir -p "$OUTPUT_DIR_SIMULATOR"

cp -r "${SIMULATOR_LIBRARY_PATH}" "${OUTPUT_DIR_SIMULATOR}"

#echo "output iphoneos"
OUTPUT_DIR_IPHONEOS="$BASE_DIR_OUTPUT/${FRAMEWORK_NAME}-${CONFIGURATION}-iphoneos/"

rm -rf "${OUTPUT_DIR_IPHONEOS}"
mkdir -p "${OUTPUT_DIR_IPHONEOS}"

cp -r "${DEVICE_LIBRARY_PATH}" "${OUTPUT_DIR_IPHONEOS}"

#echo "finder"
if [ ${REVEAL_ARCHIVE_IN_FINDER} = true ]; then
  open "${BASE_DIR_OUTPUT}"
fi