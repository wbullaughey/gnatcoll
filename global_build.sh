source ~/.zshrc
export BUILD_MODE=$1
export UNIT_TEST=$2
export BUILD_PROFILE=$3
export DIRECTORY=$4
#export DEBUG_OPTIONS=-vv -d

# BUILD_MODE values
#   all     - build everything (help_tests, driver unit tests, applications)
#   execute    - build application or library for subdirectory level
#   help_test  - builds help_test at level

if [[ -z "$DIRECTORY" ]]; then
   echo missing DIRECTORY
   exit
fi

echo global build BUILD_MODE $BUILD_MODE UNIT_TEST $UNIT_TEST BUILD_PROFILE $BUILD_PROFILE DIRECTORY $DIRECTORY

#echo build from `pwd`

function build () {
   DIRECTORY=$1
   MODE=$2
   echo build $DIRECTORY mode $MODE
   pushd $DIRECTORY
   echo building `pwd` mode $MODE
   COMMAND="alr $DEBUG_OPTIONS build -- -j10 -s -k -gnatE -XBUILD_MODE=$MODE -XUNIT_TEST=$UNIT_TEST -XBUILD_PROFILE=$BUILD_PROFILE"
   echo COMMAND $COMMAND
   $COMMAND

   if [[ $? -ne 0 ]]; then
      echo "build failed"
      exit
   fi
   popd
}

function build_all () {
   MODE=$1
   build "ada_lib/ada_lib_tests" $MODE
   build "applications/video/camera/unit_test" $MODE
   build "applications/video/camera" $MODE
   build "applications/video/camera/driver/unit_test" $MODE
   build "applications/video/camera/driver" $MODE
   build ".    " $MODE
   echo all directories build for mode $MODE
}

case $BUILD_MODE in

   all)
      echo build both
      build_all execute
      build_all help_test
      echo both execute and help_test built
      ;;

   execute)
      echo build execute
      build $DIRECTORY $BUILD_MODE
      ;;

   help_test)
      echo build help test
      build $DIRECTORY $BUILD_MODE
      ;;

   *)
      echo missing or bad BUILD_MODE
      exit;
      ;;

esac


