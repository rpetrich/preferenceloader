THEOS_PLATFORM_SDK_ROOT_armv6 = /Applications/Xcode_Legacy.app/Contents/Developer
ifneq ($(wildcard $(THEOS_PLATFORM_SDK_ROOT_armv6)/*),)
THEOS_PLATFORM_SDK_ROOT_armv7 = /Volumes/Xcode/Xcode.app/Contents/Developer
THEOS_PLATFORM_SDK_ROOT_armv7s = /Volumes/Xcode/Xcode.app/Contents/Developer
THEOS_PLATFORM_SDK_ROOT_arm64 = /Volumes/Xcode_9.4.1/Xcode.app/Contents/Developer
SDKVERSION_armv6 = 5.1
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_armv6 = 2.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_armv7 = 3.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_armv7s = 6.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_arm64 = 7.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_arm64e = 8.4
IPHONE_ARCHS = armv6 armv7 arm64 arm64e
libprefs_IPHONE_ARCHS = armv6 armv7 armv7s arm64 arm64e
else
IPHONE_ARCHS = armv7 arm64 arm64e
libprefs_IPHONE_ARCHS = armv7 armv7s arm64 arm64e
endif

include framework/makefiles/common.mk

LIBRARY_NAME = libprefs
libprefs_LOGOSFLAGS = -c generator=internal
libprefs_FILES = prefs.xm
libprefs_FRAMEWORKS = UIKit
libprefs_PRIVATE_FRAMEWORKS = Preferences
libprefs_CFLAGS = -I.
libprefs_COMPATIBILITY_VERSION = 2.2.0
libprefs_LIBRARY_VERSION = $(shell echo "$(THEOS_PACKAGE_BASE_VERSION)" | cut -d'~' -f1)
libprefs_LDFLAGS  = -compatibility_version $($(THEOS_CURRENT_INSTANCE)_COMPATIBILITY_VERSION)
libprefs_LDFLAGS += -current_version $($(THEOS_CURRENT_INSTANCE)_LIBRARY_VERSION)

TWEAK_NAME = PreferenceLoader
PreferenceLoader_FILES = Tweak.xm
PreferenceLoader_FRAMEWORKS = UIKit
PreferenceLoader_PRIVATE_FRAMEWORKS = Preferences
PreferenceLoader_LIBRARIES = prefs
PreferenceLoader_CFLAGS = -I.
PreferenceLoader_LDFLAGS = -L$(THEOS_OBJ_DIR)

include $(THEOS_MAKE_PATH)/library.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-libprefs-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/usr/include/libprefs$(ECHO_END)
	$(ECHO_NOTHING)cp prefs.h $(THEOS_STAGING_DIR)/usr/include/libprefs/prefs.h$(ECHO_END)

after-stage::
	find $(THEOS_STAGING_DIR) -iname '*.plist' -exec plutil -convert binary1 {} \;
	#$(FAKEROOT) chown -R root:admin $(THEOS_STAGING_DIR)
	mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceBundles $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences
# 	sudo chown -R root:admin $(THEOS_STAGING_DIR)/Library $(THEOS_STAGING_DIR)/usr

after-install::
	install.exec "killall -9 Preferences"
