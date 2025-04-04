#include <QThread>
#include <rtl-sdr.h>
#include "../SDR/SDRManager.h"
#include "../../Receiver/ADSB/ADSBReceiver.h"

ADSBReceiver* adsbReceiver;

SDRManager::SDRManager(QObject *parent) : QObject(parent),
    device(nullptr),
    deviceIndex(0),
    isRunning(false),
    frequency(1090000000),
    gain(28),
    bandwidth(2000000),
    sampleRate(2048000),
    directSampling(1),
    offsetTuning(1),
    checkDeviceRunning(false) { checkDeviceConnection(); }

SDRManager::~SDRManager() {
    stop();
}

template <typename T>
T* SDRManager::getDevice() const {
    return reinterpret_cast<T*>(device);
}

void SDRManager::start() {
    stop();

    if (!device) {
        if (rtlsdr_open(reinterpret_cast<rtlsdr_dev_t**>(&device), deviceIndex) < 0) {
            return;
        }

        emit deviceChanged(device);

        rtlsdr_dev_t* rtlsdrDevice = getDevice<rtlsdr_dev_t>();
        if (rtlsdrDevice) {
            rtlsdr_set_sample_rate(rtlsdrDevice, sampleRate);
            rtlsdr_set_freq_correction(rtlsdrDevice, 0);
            rtlsdr_set_center_freq(rtlsdrDevice, frequency);
            rtlsdr_reset_buffer(rtlsdrDevice);
        }

        isRunning = true;
    }
}

void SDRManager::stop() {
    if (device) {
        rtlsdr_dev_t* rtlsdrDevice = getDevice<rtlsdr_dev_t>();
        if (rtlsdrDevice) {
            rtlsdr_cancel_async(rtlsdrDevice);
            rtlsdr_close(rtlsdrDevice);
        }
        stopDeviceCheckConnection();
        device = nullptr;
        isRunning = false;
    }
}

void SDRManager::checkDeviceConnection() {
    checkDeviceRunning = true;
    checkDeviceThread = std::thread([this]() {
        while (checkDeviceRunning) {
            std::this_thread::sleep_for(std::chrono::seconds(60));

            int deviceCount = rtlsdr_get_device_count();
            if (deviceCount > 0) {
                qDebug() << "Devices connected, total number of devices: " << deviceCount;
                if (!device) {
                    qDebug() << "Device is not on, will be opened.";
                } else {
                    qDebug() << "Device is already on.";
                }
            } else {
                qDebug() << "Device not found!";
            }
        }
    });
}

void SDRManager::stopDeviceCheckConnection() {
    checkDeviceRunning = false;
    if (checkDeviceThread.joinable()) {
        checkDeviceThread.join();
    }
}

QVariantList SDRManager::getAvailableDevices() {
    QVariantList deviceList;
    int deviceCount = rtlsdr_get_device_count();

    for (int i = 0; i < deviceCount; ++i) {
        char manufacturer[256], product[256], serial[256];
        rtlsdr_get_device_usb_strings(i, manufacturer, product, serial);

        QVariantMap deviceInfo;
        deviceInfo["deviceId"] = i;
        deviceInfo["name"] = QString("%1 %2").arg(manufacturer).arg(product);
        deviceList.append(deviceInfo);
    }

    return deviceList;
}

void SDRManager::startAdsbReceiver() {
    rtlsdr_dev_t* rtlsdrDevice = getDevice<rtlsdr_dev_t>();

    if (rtlsdrDevice) {
        rtlsdr_set_center_freq(rtlsdrDevice, 1090000000);
        rtlsdr_set_tuner_gain_mode(rtlsdrDevice, 1);
        rtlsdr_set_tuner_gain(rtlsdrDevice, 378);
        rtlsdr_set_sample_rate(rtlsdrDevice, 2000000);
        rtlsdr_set_freq_correction(rtlsdrDevice, 58);
        rtlsdr_set_agc_mode(rtlsdrDevice, 1);
        rtlsdr_reset_buffer(rtlsdrDevice);

        adsbReceiver = new ADSBReceiver();
        ADSBReceiver::receiver = adsbReceiver;
        connect(adsbReceiver, &ADSBReceiver::flightsReady, this, &SDRManager::flightsReady);

        receiverThread = std::thread([this]() {

            rtlsdr_read_async(getDevice<rtlsdr_dev_t>(), [](unsigned char* buf, unsigned int len, void* ctx) {
                adsbReceiver->readCallback(buf, len);
            }, (void*)this, 12, 16 * 16384);

            while (isRunning) {
                std::this_thread::sleep_for(std::chrono::seconds(1));
            }
        });
    }
}

void SDRManager::stopAdsbReceiver() {
    rtlsdr_dev_t* rtlsdrDevice = getDevice<rtlsdr_dev_t>();
    if (rtlsdrDevice) {
        rtlsdr_cancel_async(rtlsdrDevice);
    }
    if (receiverThread.joinable()) {
        receiverThread.join();
    }
}
