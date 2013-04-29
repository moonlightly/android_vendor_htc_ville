# Include files for all Kaos Droid Devices
$(call inherit-product, vendor/KaosDroid/config/all_devices.mk)

#Overlay KaosDroid properties
PRODUCT_PACKAGE_OVERLAYS += vendor/KaosDroid/device/htc/ville/overlay/common

#Add device specific files
PRODUCT_COPY_FILES += \
    vendor/KaosDroid/device/htc/ville/prebuilt/etc/init.d/SS98KickAssKernel:system/etc/init.d/SS98KickAssKernel \
    vendor/KaosDroid/device/htc/ville/prebuilt/etc/init.d/SS99SuperCharger:system/etc/init.d/SS99SuperCharger \
    vendor/KaosDroid/device/htc/ville/prebuilt/media/bootanimation.zip:system/media/bootanimation.zip

#Add Extra Modules
PRODUCT_COPY_FILES += \
    vendor/KaosDroid/device/htc/ville/prebuilt/lib/modules/cifs.ko:system/lib/modules/cifs.ko \
    vendor/KaosDroid/device/htc/ville/prebuilt/lib/modules/md4.ko:system/lib/modules/md4.ko \
    vendor/KaosDroid/device/htc/ville/prebuilt/lib/modules/nls_utf8.ko:system/lib/modules/nls_utf8.ko

