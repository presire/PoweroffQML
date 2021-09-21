# PoweroffQML for x86 and x64  

# Preface  
PoweroffQML is a Linxu system shutdown / reboot software for Linux x86 /x64.<br>
It can easily shutdown/restart Linux systems just by pressing button.<br>
<br>
You can also change the shutdown sound by placing Shutdown.wav,<br>
in a directory on the same level as the executable binary.<br>
<br>
*Note:*<br>
*PoweroffQML is created in Qt 5.15, so it requires Qt 5.15 library.*<br>
<br>

# 1. Install the necessary dependencies for PineScaleQML
Create a directory for installing Qt libraries on PinePhone.<br>
* libQt5Core.so.5
* libQt5Gui.so.5
* libQt5Quick.so.5
* libQt5QuickControls2.so.5
* libQt5Qml.so.5
* libQt5QmlModels.so.5
* libQt5Network.so.5
* libQt5Multimedia.so.5
<br>

Get the latest updates.<br>

    # Debian / Ubuntu
    sudo apt update
    sudo apt upgrade

    # SUSE
    sudo zypper update
<br>

Install the dependencies required to build the PoweroffQML.  

    # Debian / Ubuntu
    sudo apt-get install qt5-qmake qt5-qmake-bin \
                         libqt5core5a libqt5gui5 libqt5quick5 libqt5quickcontrols2-5 \
                         libqt5qml5 libqt5qmlmodels5 libqt5network5 libQt5Multimedia5
    
    # SUSE
    sudo zypper install  libqt5-qtbase-common-devel libQt5Core5 libQt5Gui5 \
                         libqt5-qtquickcontrols libQt5QuickControls2-5 \
                         libqt5qmlmodels5 libQt5Network5 libQt5multimedia5
<br>
<br>

# 2. Compile PoweroffQML
Download the source code from PoweroffQML's Github.<br>

    git clone https://github.com/presire/PoweroffQML.git PoweroffQML
<br>

Use the qmake command to compile the source code of PoweroffQML.<br>
The default installation directory is <I>**${PWD}/PoweroffQML**</I>.<br>

The recommended installation directory is the home directory. (Ex. <I>**${HOME}/InstallSoftware/PoweroffQML**</I>)

    cd PoweroffQML

    mkdir build && cd build

    qmake ../PoweroffQML.pro PREFIX=<The directory you want to install in>
    make -j $(nproc)
    make install
<br>

Copy Shutdown.wav to a directory at the same level as the Poweroff QML executable binary.<br>

    cp Shutdown.wav /<Directory at the same level as the installed Poweroff QML>/
<br>

# 3. Create DesktoEntry for PoweroffQML
    vi ~/.local/share/applications/PoweroffQML.desktop
<br>

    [Desktop Entry]
    Type=Application
    Name=PoweroffQML
    GenericName=PoweroffQML
    Comment=Linux Shutdown / Reboot Software
    Icon=/<PoweroffQML Install Directory>/PoweroffQML.svg
    Exec=/<PoweroffQML Install Directory>/PoweroffQML %F
    Terminal=false
    Categories=Utility;
<br>

<br>
<br>

# 4. Execute PoweroffQML
Make sure you can execute **PoweroffQML**.<br>
<br>
<center><img src="img/PoweroffQML_SS_1.png" width="50%" height="50%" ></center><br>
<br>
First, select [File] -> [Save Password].<br>
Next, enter the Linux administrator password and click the [Save] button.<br>
<center><img src="img/PoweroffQML_SS_2.png" width="50%" height="50%" ><img src="img/PoweroffQML_SS_3.png" width="50%" height="50%" ></center><br>
Press the [Shutdown] or [Reboot] button to see if Linux will shutdown/restart.<br> 
(You can also use the shortcut key [U] Key to shut down and [R] Key to reboot.)<br>
<br>
<br>

