#!/sbin/sh

sed -e 's/ro.build.display.id=cm_ville-userdebug 4.2.2 JDQ39 eng.pete.20130416.202358 test-keys/ro.build.display.id=Kaos Droid V5.1.5/g' -e 's/ro.product.local.region=US/ro.product.local.region=GB/g' -e 's/net.bt.name=Android/net.bt.name=Kaos Droid/g' -e 's/ro.com.android.dateformat=MM-dd-yyyy/ro.com.android.dateformat=dd-MM-yyyy/g' /system/build.prop >> /system/build.prop1

rm -rf /system/build.prop
mv /system/build.prop1 /system/build.prop
