THEOS_DEVICE_IP = 192.168.3.145
THEOS_DEVICE_PORT = 22

INSTALL_TARGET_PROCESSES = AirTroller
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = AirTroller

AirTroller_CODESIGN_FLAGS = -Sentitlements.plist

include $(THEOS_MAKE_PATH)/xcodeproj.mk
