source ~/.zshrc
export WHICH=$1         # all | both | execute | help_test
export KIND=$2
export DIRECTORY=`pwd`
export SCRIPT_DIR=$(dirname ${0:A})
export DO_TRACE=TRUE
#export DEBUG_OPTIONS=-vv -d --verbose

# WHICH values
#   all     - build everything (help_tests, driver unit tests, applications)
#   execute    - build application or library for subdirectory level
#   help_test  - builds help_test at level

#if [[ -z "$DIRECTORY" ]]; then
#   echo missing DIRECTORY
#   exit
#fi

function output() {
   TRACE=$1
   shift 1
   echo "output TRACE $TRACE DO_TRACE $DO_TRACE APPEND TRACE $APPEND_OUTPUT \
      PARAMETERS $*" >> TRACE.txt
   case $TRACE in

      "LIST")
         ;;

      "TRACE")
         case $DO_TRACE in

            "FALSE")
               return
               ;;

            "TRUE")
               ;;
         esac
         ;;

   esac
   echo $* 2>&1 | tee $APPEND_OUTPUT $OUTPUT
   export APPEND_OUTPUT=-a  # append from now on
}

output TRACE global build WHICH $WHICH \
   SCRIPT_DIR $SCRIPT_DIR KIND $KIND DO_TRACE $DO_TRACE

case $KIND in

   library)
      ;;

   program)
      ;;

   *)
      output LIST missing or bad KIND $KIND
      exit;
      ;;

esac

function build () {
   DIRECTORY=$1
   MODE=$2
   KIND=$3
   if [[ "$MODE" = "help_test" && "$KIND" = "library" ]]; then
      output LIST no build help build for $DIRECTORY
   else
      output TRACE building $DIRECTORY mode $MODE kind $KIND


      pushd $DIRECTORY > /dev/null 2>&1
      if [[ $? -ne 0 ]]; then
         echo "pushd to $DIRECTORY failed"
         exit
      fi
   #  echo building `pwd` mode $MODE
      COMMAND="alr $DEBUG_OPTIONS build -- -j10 -s -k -gnatE -vl -v $ALR_OPTIONS Build_Host=desktop"

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
   build "gnoga_lib/gnoga_options" $MODE library
   build "ada_lib" $MODE  library
   build "vendor/github.com/gnoga" $MODE library
   build "gnoga_lib/gnoga_ada_lib" $MODE library
   build "ada_lib/ada_lib_tests" $MODE program
   build "applications/video/camera" $MODE program
   build "applications/video/camera/test_lib" $MODE library
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


