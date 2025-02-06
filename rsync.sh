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
   export OPTIONS="-lptv"
fi

echo OPTIONS $OPTIONS

function report {
   if [ -n "$VERBOSE" ]; then
      kind=$1
      what=$2
      echo "$kind $what does not exist"
   fi
}

function copy_file {
   FILE=$1
   DIRECTORY=$2
   if [ -n "$VERBOSE" ]; then
      echo "copy file: $FILE directory: $DIRECTORY
      echo "options: $OPTIONS"
      echo "source: $SOURCE"
      echo "destination: $DESTINATION
      echo "rsync file $OPTIONS $SOURCE/$DIRECTORY/$FILE $DESTINATION/$DIRECTORY"
   fi
   if [[ -e $SOURCE/$DIRECTORY/$FILE ]]; then
      if [ -d "$DESTINATION" ]; then
         rsync $OPTIONS --progress $SOURCE/$DIRECTORY/$FILE $DESTINATION/$DIRECTORY
      else
         report "destination $DESTINATION"
      fi
   else
      report "file $SOURCE/$DIRECTORY/$FILE"
   fi
}

function copy_directory {
   DIRECTORY=$1
   if [ -n "$VERBOSE" ]; then
      echo "copy directory: $DIRECTORY"
      echo "options: $OPTIONS"
      echo "source: $SOURCE "
      echo "destination: $DESTINATION"
      echo "rsync directory $OPTIONS $SOURCE/$DIRECTORY/src/* $DESTINATION/$DIRECTORY/src"
   fi

   if [ -d "$SOURCE/$DIRECTORY" ]; then
      if [ -d "$DESTINATION" ]; then

         rsync $OPTIONS $SOURCE/$DIRECTORY/*.gpr $DESTINATION/$DIRECTORY
         rsync $OPTIONS $SOURCE/$DIRECTORY/src/* $DESTINATION/$DIRECTORY/src

         if [ -d "$SOURCE/$DIRECTORY/config" ]; then
            rsync $OPTIONS $SOURCE/$DIRECTORY/config/* $DESTINATION/$DIRECTORY/config
         else
            report source "$SOURCE/$DIRECTORY/config"
         fi
         copy_file alire.toml $DIRECTORY
         copy_file project_paths.cfg $DIRECTORY
      else
         report destination "$DESTINATION"
      fi
   else
      report source "$SOURCE/$DIRECTORY"
   fi
}

echo "rsync source $SOURCE destination $DESTINATION" 2>&1 | tee $OUTPUT

copy_directory "" 2>&1 | tee -a $OUTPUT
copy_directory "ada_lib" 2>&1 | tee -a $OUTPUT
copy_directory "ada_lib/ada_lib_gnoga" 2>&1 | tee -a $OUTPUT
copy_directory "ada_lib/ada_lib_tests" 2>&1 | tee -a $OUTPUT
copy_directory "aunit" 2>&1 | tee -a $OUTPUT
copy_directory "aunit/ada_lib" 2>&1 | tee -a $OUTPUT
# use git to check in and out vendor/github.com/gnoga
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

copy_file remote_build.sh . 2>&1 | tee -a $OUTPUT
copy_file build.sh ada_lib/ada_lib_tests 2>&1 | tee -a $OUTPUT
#copy_file video/camera/build.sh 2>&1 | tee -a $OUTPUT
#copy_file video/camera/driver/build.sh 2>&1 | tee -a $OUTPUT
#copy_file video/camera/driver/unit_test/build.sh 2>&1 | tee -a $OUTPUT
#copy_file video/camera/unit_test/build.sh 2>&1 | tee -a $OUTPUT

