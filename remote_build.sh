#!/bin/zsh
source ~/.zshrc
echo remote_build $*
pwd

export ROOT_PATH=$1
export BASE_PATH=$2
export PROGRAM=$3
export QUICK_BUILD=$4

export RELATIVE_ALR_ENVIRONMENT_PATH="Project/git/alr/$ROOT_PATH"
export ALR_ENVIRONMENT_PATH="$HOME/$RELATIVE_ALR_ENVIRONMENT_PATH"
export BUILD_PATH="$RELATIVE_ALR_ENVIRONMENT_PATH/$BASE_PATH"
export LOCAL_BUILD_PATH="$HOME/$BUILD_PATH"
export LOCAL_APPLICATION="$LOCAL_BUILD_PATH/$PROGRAM"
export REMOTE_BUILD_PATH="/Volumes/wayne/$BUILD_PATH"
export REMOTE_APPLICATION="$REMOTE_BUILD_PATH/$PROGRAM"
export LOCAL_OUTPUT=build.txt

echo ALR_ENVIRONMENT_PATH $ALR_ENVIRONMENT_PATH
echo BASE_PATH $BASE_PATH
echo BUILD_PATH $BUILD_PATH
echo HOME $HOME
echo LOCAL_APPLICATION $LOCAL_APPLICATION
echo LOCAL_BUILD_PATH $LOCAL_BUILD_PATH
echo QUICK_BUILD $QUICK_BUILD
echo RELATIVE_ALR_ENVIRONMENT_PATH $RELATIVE_ALR_ENVIRONMENT_PATH
echo REMOTE_APPLICATION $REMOTE_APPLICATION
echo REMOTE_BUILD_PATH $REMOTE_BUILD_PATH
echo ROOT_PATH $ROOT_PATH

echo building $PROGRAM on $OS_VERSION LOCAL_BUILD_PATH: $LOCAL_BUILD_PATH REMOTE_BUILD_PATH: $REMOTE_BUILD_PATH

function local_build () {
   echo local build output $LOCAL_OUTPUT
   export ROOT=`pwd`
   echo ROOT $ROOT
   cd $BUILD_PATH
   rm -f $LOCAL_OUTPUT
   pwd 2>&1 | tee -a $LOCAL_OUTPUT
   export GPR_PROJECT_PATH_FILE=$BUILD_PATH/project_paths.cfg
   echo GPR_PROJECT_PATH_FILE $GPR_PROJECT_PATH_FILE
   alr build -- -j10 -s -k -gnatE 2>&1 | tee -a $LOCAL_OUTPUT
   echo alr completed
}

case  ${QUICK_BUILD} in

   "")
      ;;

   *)
      local_build
      exit;
esac

case  ${OS_VERSION%%.*} in

   "15")
      echo pwd `pwd`
      export REMOTE_OUTPUT=remote_build.txt
      echo desktop 2>&1 | tee $REMOTE_OUTPUT
      echo $PATH  2>&1 | tee -a $REMOTE_OUTPUT
      export LOCATION=remote
      $ALR_ENVIRONMENT_PATH/rsync.sh verbose 2>&1 | tee -a $REMOTE_OUTPUT
      export BUILD_HOME=`pwd`
      echo BUILD_HOME $BUILD_HOME
      sshpass -p 'grandkidsaregreat' ssh wayne@MacBook $ALR_ENVIRONMENT_PATH/remote_build.sh $ROOT_PATH $BASE_PATH $PROGRAM $QUICK_BUILD 2>&1 | tee -a $REMOTE_OUTPUT
      echo sshpass completed
      ;;

   *)
      echo laptop $LOCAL 2>&1 | tee $LOCAL_OUTPUT
      export LOCATION=local
      local_build
esac

echo LOCATION $LOCATION
case $LOCATION in

   "local")
      # no need to copy
      ;;

   "remote")
      # check if build worked
      echo "rsync -lptv $REMOTE_BUILD_PATH/$LOCAL_OUTPUT .     #copy remote build.txt to desktop"
      rsync -lptv $REMOTE_BUILD_PATH/$LOCAL_OUTPUT .     #copy remote build.txt to desktop
#     export REMOTE_OUTPUT=$REMOTE_BUILD_PATH/build.txt
#     echo "REMOTE_OUTPUT $REMOTE_OUTPUT"
#     echo grep $REMOTE_OUTPUT
      grep "Build finished successfully" $LOCAL_OUTPUT
      RESULT=$?
      if [ $RESULT -eq 0 ]; then
         echo "compile successfully. copy $PROGRAM"
         ls -l $REMOTE_BUILD_PATH/bin
         COMMAND="rsync -lptv $REMOTE_BUILD_PATH/bin/$PROGRAM bin"
         echo COMMAND $COMMAND
         eval $COMMAND
      else
         echo "compile failed."
         rm -f $REMOTE_BUILD_PATH/bin/camera_aunit
      fi
      ;;

   *)
      echo "invalid build location $LOCATION"
      exit
      ;;

esac
