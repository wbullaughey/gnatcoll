source ~/.zshrc
export BUILD_MODE=$1
#echo BUILD_MODE $BUILD_MODE

#echo build from `pwd`

function build () {
   DIRECTORY=$1
   BUILD_MODE=$2
#  echo build $DIRECTORY mode $BUILD_MODE
   pushd $DIRECTORY
   echo building `pwd` mode $BUILD_MODE
   alr -v build -- -j10 -s -k -gnatE -XBUILD_MODE=$BUILD_MODE

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

if [[ -z "$BUILD_MODE" ]]; then
   echo build both
   build_all execute
   build_all help_test
   echo both execute and help_test built
else
   echo build mode $BUILD_MODE
   build_all $BUILD_MODE
   echo $BUILD_MODE built
fi


