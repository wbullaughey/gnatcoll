#!/bin/zsh
export VERBOSE=$1
echo VERBOSE $VERBOSE
export RELATIVE_PATH=Project/git/alr/alr_environment
export SOURCE=/Users/wayne/$RELATIVE_PATH
export DESTINATION=/Volumes/wayne/$RELATIVE_PATH
export OUTPUT=rsync.txt

if [ -z "$VERBOSE" ]; then # not verbose
   export OPTIONS="-lptvq"
else                       # verbose
   export OPTIONS="-lptv --progress"
fi

echo OPTIONS $OPTIONS

function copy_file {
   export FILE=$1
   if [ -n "$VERBOSE" ]; then
      echo "coppy file: $FILE
      echo "options: $OPTIONS"
      echo "source: $SOURCE"
      echo "destination: $DESTINATION
      echo "rsync file $OPTIONS $SOURCE/$FILE $DESTINATION/"
   fi
   if [[ -e $SOURCE/$FILE ]]; then
      if [ -d "$DESTINATION" ]; then
         rsync $OPTIONS $SOURCE/$FILE $DESTINATION/
      else
         echo "destination $DESTINATION does not exist"
      fi
   else
      echo "$SOURCE/$FILE does not exist"
   fi
}

function copy_directory {
   export DIRECTORY=$1
   if [ -n "$VERBOSE" ]; then
      echo "copy directory: $DIRECTORY"
      echo "options: $OPTIONS"
      echo "source: $SOURCE "
      echo "rsync directory $OPTIONS $SOURCE/$DIRECTORY/src/* $DESTINATION/$DIRECTORY/src"
   fi
   if [ -d $SOURCE/$DIRECTORY" ]; then
      rsync $OPTIONS $SOURCE/$DIRECTORY/*.gpr $DESTINATION/$DIRECTORY
      if [ -d "$SOURCE/$DIRECTORY/src" ]; then
         rsync $OPTIONS $SOURCE/$DIRECTORY/src/* $DESTINATION/$DIRECTORY/src
      else
         echo "$OPTIONS $SOURCE/$DIRECTORY/src does not exist"
      fi
      if [ -d "$SOURCE/$DIRECTORY/config" ]; then
         rsync $OPTIONS $SOURCE/$DIRECTORY/config/* $DESTINATION/$DIRECTORY/config
      else
         echo "$SOURCE/$DIRECTORY/config does not exist"
      fi
      copy_file $DIRECTORY/alire.toml
      copy_file $DIRECTORY/project_paths.cfg
   else
      echo "directory $SOURCE/$DIRECTORY does not exist
   fi
}

echo "rsync source $SOURCE destination $DESTINATION" 2>&1 | tee $OUTPUT

copy_directory "" 2>&1 | tee -a $OUTPUT
copy_directory "ada_lib" 2>&1 | tee -a $OUTPUT
copy_directory "ada_lib/ada_lib_gnoga" 2>&1 | tee -a $OUTPUT
copy_directory "ada_lib/ada_lib_tests" 2>&1 | tee -a $OUTPUT
copy_directory "aunit" 2>&1 | tee -a $OUTPUT
copy_directory "aunit/ada_lib" 2>&1 | tee -a $OUTPUT
#copy_directory "vendor/github.com/gnoga" 2>&1 | tee -a $OUTPUT
##copy_directory "vendor/github.com/gnoga-forked" 2>&1 | tee -a $OUTPUT
#copy_directory "video/camera" 2>&1 | tee -a $OUTPUT
#copy_directory "video/camera/lib" 2>&1 | tee -a $OUTPUT
##copy_directory "video/camera/lib/unit_test" 2>&1 | tee -a $OUTPUT
#copy_directory "video/camera/test_lib" 2>&1 | tee -a $OUTPUT
#copy_directory "video/camera/unit_test" 2>&1 | tee -a $OUTPUT
#copy_directory "video/camera/driver" 2>&1 | tee -a $OUTPUT
#copy_directory "video/camera/driver/unit_test" 2>&1 | tee -a $OUTPUT
#copy_directory "video/lib" 2>&1 | tee -a $OUTPUT
#copy_directory "video/lib/video_aunit" 2>&1 | tee -a $OUTPUT

copy_file remote_build.sh 2>&1 | tee -a $OUTPUT
copy_file ada_lib/ada_lib_tests/build.sh 2>&1 | tee -a $OUTPUT
#copy_file video/camera/build.sh 2>&1 | tee -a $OUTPUT
#copy_file video/camera/driver/build.sh 2>&1 | tee -a $OUTPUT
#copy_file video/camera/driver/unit_test/build.sh 2>&1 | tee -a $OUTPUT
#copy_file video/camera/unit_test/build.sh 2>&1 | tee -a $OUTPUT

