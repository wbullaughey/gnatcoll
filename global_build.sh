source ~/.zshrc
export BUILD_MODE=$1
export UNIT_TEST=$2
export BUILD_PROFILE=$3
export KIND=$4
export DIRECTORY=`pwd`
export SCRIPT_DIR=$(dirname ${0:A})
#export DEBUG_OPTIONS=-vv -d --verbose

# BUILD_MODE values
#   all     - build everything (help_tests, driver unit tests, applications)
#   execute    - build application or library for subdirectory level
#   help_test  - builds help_test at level

#if [[ -z "$DIRECTORY" ]]; then
#   echo missing DIRECTORY
#   exit
#fi

echo global build BUILD_MODE $BUILD_MODE UNIT_TEST $UNIT_TEST \
   BUILD_PROFILE $BUILD_PROFILE SCRIPT_DIR $SCRIPT_DIR KIND $KIND

case $KIND in

   library)
      ;;

   program)
      ;;

   *)
      echo missing or bad KIND $KIND
      exit;
      ;;

esac

function build () {
   DIRECTORY=$1
   MODE=$2
   KIND=$3
   if [[ "$MODE" = "help_test" && "$KIND" = "library" ]]; then
      echo no build help build for $DIRECTORY
   else
      echo building $DIRECTORY mode $MODE kind $KIND


      pushd $DIRECTORY > /dev/null 2>&1
      if [[ $? -ne 0 ]]; then
         echo "pushd to $DIRECTORY failed"
         exit
      fi
   #  echo building `pwd` mode $MODE
      COMMAND="alr $DEBUG_OPTIONS build -- -j10 -s -k -gnatE -XBUILD_MODE=$MODE \
         -XUNIT_TEST=$UNIT_TEST -XBUILD_PROFILE=$BUILD_PROFILE "

      echo COMMAND $COMMAND
      $COMMAND

      if [[ $? -ne 0 ]]; then
         echo "build failed"
         exit
      fi
      echo "build for $DIRECTORY succeeded"
      popd
   fi
}

function build_all () {
   MODE=$1
   echo build_all for MODE $MODE
   pushd $SCRIPT_DIR > /dev/null 2>&1
   if [[ $? -ne 0 ]]; then
      echo "pushd to $SCRIPT_DIR failed"
      exit
   fi
   build "gnoga_options" $MODE library
   build "ada_lib" $MODE  library
   build "vendor/github.com/gnoga" $MODE library
   build "gnoga_ada_lib" $MODE library
   build "ada_lib/ada_lib_tests" $MODE program
   build "applications/video/camera" $MODE program
   build "applications/video/camera/unit_test" $MODE program
   build "applications/video/camera/driver" $MODE program
   build "applications/video/camera/driver/unit_test" $MODE program
   build ".    " $MODE
   echo all directories built for mode $MODE
   popd
}

case $BUILD_MODE in

   all)
      echo build all
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


