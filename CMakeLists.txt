cmake_minimum_required(VERSION 3.16)
project(sdrlink VERSION 1.0 LANGUAGES CXX)

set(MACOSX_BUNDLE_ICON_FILE ic_logo_launcher.png)
set(app_icon_macos "${CMAKE_CURRENT_SOURCE_DIR}/Resources/Image/ic_logo_launcher.png")
set_source_files_properties(${app_icon_macos} PROPERTIES
       MACOSX_PACKAGE_LOCATION "Resources")

set(CMAKE_EXECUTABLE_SUFFIX "")
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_OSX_ARCHITECTURES "x86_64")

find_package(Qt6 REQUIRED COMPONENTS Quick Location Positioning)
find_package(PkgConfig REQUIRED)
pkg_check_modules(RTL_SDR REQUIRED librtlsdr)

include_directories(${RTL_SDR_INCLUDE_DIRS})
link_directories(${RTL_SDR_LIBRARY_DIRS})

qt_add_executable(appsdrlink
    app.cpp ${app_icon_macos}

    Resources.qrc
    Manager/SDR/SDRManager.h
    Manager/RTL/RTLManager.cpp


    Receiver/ADSB/ADSBReceiver.h
    Receiver/ADSB/ADSBReceiver.cpp
    Demodulator/ADSB/ADSBDemodulator.h
    Demodulator/ADSB/ADSBDemodulator.cpp
)

target_link_libraries(appsdrlink
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Location
    PRIVATE Qt6::Positioning
    PRIVATE ${RTL_SDR_LIBRARIES}
)

qt_add_qml_module(appsdrlink
    URI sdrlink
    VERSION 1.0
    QML_FILES App.qml

    QML_FILES UI/Page/Device/DevicePage.qml
    QML_FILES UI/Page/Device/DeviceViewModel.qml

    QML_FILES UI/Page/Dashboard/DashboardPage.qml
    QML_FILES UI/Page/Dashboard/DashboardViewModel.qml

    QML_FILES UI/Page/Splash/SplashPage.qml

    QML_FILES UI/Page/About/AboutPage.qml

    QML_FILES UI/Navigation/Route.qml
    QML_FILES UI/Navigation/NavigationViewModel.qml

    QML_FILES UI/Page/Module/Radar/RadarPage.qml
    QML_FILES UI/Page/Module/Flight/Map/FlightMapPage.qml

    QML_FILES UI/Component/Toolbar.qml
    QML_FILES UI/Component/ModuleCard.qml
    QML_FILES UI/Component/DeviceCard.qml
    QML_FILES UI/Component/CircleLoadingBar.qml

    QML_FILES Resources/Style/Style.qml

    RESOURCES Resources/Animation/splash.json
    RESOURCES Resources/Animation/loading.json
    RESOURCES Resources/Image/ic_arrow_back.svg
    RESOURCES Resources/Image/ic_logo.svg
    RESOURCES Resources/Image/ic_logo.png
    RESOURCES Resources/Image/ic_logo_launcher.png
    RESOURCES Resources/Image/ic_logo_launcher.icns
    RESOURCES Resources/Image/ic_radar.svg
    RESOURCES Resources/Image/ic_flight.svg
    RESOURCES Resources/Image/ic_weather.svg
    RESOURCES Resources/Image/ic_spectrum.svg
    RESOURCES Resources/Image/ic_marine.svg
    RESOURCES Resources/Image/ic_radio.svg
    RESOURCES Resources/Image/ic_loading.svg
    RESOURCES Resources/Font/RobotoRegular.ttf
    RESOURCES Resources/Font/SyncopateRegular.ttf
)

include_directories(${RTL_SDR_INCLUDE_DIRS})
