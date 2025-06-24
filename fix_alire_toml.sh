#!/bin/zsh
SOURCE=$1
TARGET=alire.toml

if [ -f "$SOURCE" ]; then
   echo "$SOURCE exists"
   echo fixing $SOURCE creating $TARGET

   case $ALR_BUILD_ENVIRONMENT in

      "desktop")
         sed '/^@/d' $SOURCE > $TARGET
         ;;

      "laptop")
         sed 's/^@//' $SOURCE > $TARGET
         ;;

      "*")
         echo invalid ALR_BUILD_ENVIRONMENT value /$ALR_BUILD_ENVIRONMENT/
         ;;
   esac
else
   echo "$SOURCE does not exist"
fi

