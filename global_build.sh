source ~/.zshrc
export WHICH=$1         # all | both | execute | help_test
export BUILD_PROFILE=$2
export KIND=$3
export DIRECTORY=`pwd`
export SCRIPT_DIR=$(dirname ${0:A})
#export DEBUG_OPTIONS=-vv -d --verbose

# WHICH values
#   all     - build everything (help_tests, driver unit tests, applications)
#   execute    - build application or library for subdirectory level
#   help_test  - builds help_test at level

#if [[ -z "$DIRECTORY" ]]; then
#   echo missing DIRECTORY
#   exit
#fi

echo global build WHICH $WHICH BUILD_PROFILE $BUILD_PROFILE \
   SCRIPT_DIR $SCRIPT_DIR KIND $KIND

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
      COMMAND="alr $DEBUG_OPTIONS build -- -j10 -s -k -gnatE -vl -v "

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

case $WHICH in

   all)
      echo build all
      build_all execute
      build_all help_test
      echo both execute and help_test built
      ;;

   both)
      echo build both
      build $DIRECTORY execute
      build $DIRECTORY help_test
      ;;

   execute)
      echo build execute
      build $DIRECTORY $WHICH
      ;;

   help_test)
      echo build help test
      build $DIRECTORY $WHICH
      ;;

   *)
      echo missing or bad WHICH
      exit;
      ;;

esac


