#ifndef SDR_MANAGER_H
#define SDR_MANAGER_H

#include <QObject>
#include <QVariantList>
#include <thread>

class SDRManager : public QObject {
    Q_OBJECT

public:
    QObject* device;

    explicit SDRManager(QObject *parent = nullptr);
    virtual ~SDRManager();

    template <typename T>
    T* getDevice() const;

    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();
    Q_INVOKABLE QVariantList getAvailableDevices();

    void checkDeviceConnection();
    void stopDeviceCheckConnection();

    Q_INVOKABLE void startAdsbReceiver();
    Q_INVOKABLE void stopAdsbReceiver();

signals:
    void deviceChanged(QObject* newDevice);
    void flightsReady(const QVariantList &flights);

private:
    int deviceIndex;
    bool isRunning;
    double frequency;
    int gain;
    int bandwidth;
    int sampleRate;
    int directSampling;
    int offsetTuning;

    std::thread receiverThread;
    std::thread checkDeviceThread;
    std::atomic<bool> checkDeviceRunning;
};

#endif // SDR_MANAGER_H
