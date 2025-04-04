#ifndef ADSB_RECEIVER_H
#define ADSB_RECEIVER_H

#include <vector>
#include <string>
#include <mutex>
#include <map>
#include <QString>
#include <QObject>
#include <rtl-sdr.h>
#include "../../Demodulator/ADSB/ADSBDemodulator.h"

struct Flight {
    std::string icao24;
    std::string callsign;
    double latitude;
    double longitude;
    int altitude;
    int heading;
    int squawk;
    int verticalRate;
    int verticalRateSource;
    std::string type;
    std::string country;
};

class ADSBReceiver : public QObject {
    Q_OBJECT

    std::map<std::string, Flight> flightMapList;

signals:
    void flightsReady(const QVariantList &flights);

public:
    ADSBReceiver();
    static ADSBReceiver* receiver;
    void start(rtlsdr_dev_t* device);
    void init(void* ctx);
    void processFlights();
    void readCallback(unsigned char* buf, unsigned int len);
    void onNotify(mode_s_t *self, struct mode_s_msg *mm);

private:
    std::mutex messagesMutex;
    std::vector<Flight> adsbMessages;
};

#endif // ADSB_RECEIVER_H
