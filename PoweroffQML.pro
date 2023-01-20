lessThan(QT_MAJOR_VERSION, 5) {
   lessThan(QT_MINOR_VERSION, 15) {
      error("Sorry, you need at least Qt version 5.15.0")
      message( "You use Qt version" $$[QT_VERSION] )
   }
}

# Version Information
VERSION = 1.0.4
VERSTR = '\\"$${VERSION}\\"'  # place quotes around the version string
DEFINES += VER=\"$${VERSTR}\" # create a VER macro containing the version string

QT += quick quickcontrols2 multimedia dbus

# Specify Compiler
!isEmpty(CC) {
   QMAKE_CC  = $${CC}
}

!isEmpty(CXX) {
   QMAKE_CXX = $${CXX}
}

CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        CAES.cpp \
        CMainWindow.cpp \
        CWorkerThread.cpp \
        main.cpp

HEADERS += \
    CAES.h \
    CMainWindow.h \
    CWorkerThread.h

RESOURCES += \
    qml.qrc \
    PoweroffQML.svg \
    Qt.svg

DISTFILES += \
    PoweroffQML.svg \
    Qt.svg

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
isEmpty(PREFIX) {
    PREFIX = $${PWD}/$${TARGET}
}

# Create Desktop Entry file
system([ ! -d Applications ] && mkdir Applications)
system([ -f Applications/PoweroffQML.desktop ] && rm -rf Applications/PoweroffQML.desktop)
system(touch Applications/PoweroffQML.desktop)

system(echo "[Desktop Entry]" >> Applications/PoweroffQML.desktop)
system(echo "Type=Application" >> Applications/PoweroffQML.desktop)
system(echo "Name=PoweroffQML $${VERSION}" >> Applications/PoweroffQML.desktop)
system(echo "GenericName=PoweroffQML" >> Applications/PoweroffQML.desktop)
system(echo "Comment=Linux Poweroff System" >> Applications/PoweroffQML.desktop)
system(echo "Exec=$${PREFIX}/bin/PoweroffQML %F" >> Applications/PoweroffQML.desktop)
system(echo "Icon=$${PREFIX}/Image/PoweroffQML.png" >> Applications/PoweroffQML.desktop)
system(echo "Categories=System\;" >> Applications/PoweroffQML.desktop)
system(echo "Terminal=false" >> Applications/PoweroffQML.desktop)

# Config Install file
## Install Sound file
Sound.path = $${PREFIX}/bin
Sound.files = Sound/Shutdown.wav

## Install Icon files
Image.path = $${PREFIX}/Image
Image.files = Image/PoweroffQML.png Image/PoweroffQML.svg

## Install DesktopEntry file
DesktopEntry.path = $${PREFIX}
DesktopEntry.files = Applications/PoweroffQML.desktop

## Install Execute Binary file
target.path = $${PREFIX}/bin

## Install
INSTALLS += target Sound Image DesktopEntry
