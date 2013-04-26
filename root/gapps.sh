#!/bin/bash
FILE=com.google.android.calendar-1.apk
FILE1=GalleryGoogle.apk
if [ -f $FILE ];
then
   rm -f /system/app/Calendar.apk
else
   echo "File $FILE does not exists"
fi
if [ -f $FILE1 ];
then
   rm -f /system/app/Gallery2.apk
else
   echo "File $FILE does not exists"
fi

