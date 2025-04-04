#include "ADSBReceiver.h"
#include <iostream>
#include <QDebug>
#include <cstdint>
#include <string>
#include <mutex>
#include <vector>
#include <map>
#include <QObject>
#include <QVariantList>
#include <QVariant>
#include <QMetaType>
#include <cstring>

mode_s_t state;

uint16_t *mag;

ADSBReceiver* ADSBReceiver::receiver = nullptr;

ADSBReceiver::ADSBReceiver() {
    mode_s_init(&state);
}

void ADSBReceiver::onNotify(mode_s_t *self, struct mode_s_msg *mm) {
    auto flight = mm->flight;

    if (
        flight == nullptr ||
        *flight == '\0' ||
        strchr(flight, '\u0003') != nullptr ||
        strchr(flight, '\u007F') != nullptr ||
        strchr(flight, '\\') != nullptr ||
        strchr(flight, '?') != nullptr) {
        std::cerr << "Flight contains invalid characters: " << flight << std::endl;
        return;
    }

    std::cerr << "Flight : " << mm->flight << std::endl;
    std::cerr << "Lat : " << mm->lat << std::endl;
    std::cerr << "Lon : " << mm->lon << std::endl;

    char icao24[10];

    Flight message;
    message.icao24 = icao24;
    message.callsign = mm->flight;
    message.latitude = mm->raw_latitude;
    message.longitude = mm->raw_longitude;
    message.altitude = mm->altitude;
    message.heading = mm->heading;
    message.verticalRate = mm->vert_rate;
    message.verticalRateSource = mm->vert_rate_source;
    message.type = mm->aircraft_type;
    message.country = std::string(mm->flight).substr(0, 2);

    try {
        std::lock_guard<std::mutex> lock(messagesMutex);
        flightMapList[message.icao24] = message;
        processFlights();
    } catch (const std::system_error& e) {
        std::cerr << "Error locking mutex: " << e.what() << std::endl;
    }
}

void ADSBReceiver::init(void* ctx){
    receiver = static_cast<ADSBReceiver*>(ctx);
}

void ADSBReceiver::start(rtlsdr_dev_t* device){
    rtlsdr_read_async(device, [](unsigned char* buf, unsigned int len, void* ctx) {
        receiver = static_cast<ADSBReceiver*>(ctx);
        receiver->init(ctx);
        receiver->readCallback(buf, len);
    }, (void*)this, 12, 16 * 16384);
}

void ADSBReceiver::readCallback(unsigned char* buf, unsigned int len) {
    if (len < 2 || buf == nullptr) {
        return;
    }

    std::vector<uint16_t> mag(len / 2);
    mode_s_compute_magnitude_vector(buf, mag.data(), len);
    mode_s_detect(&state, mag.data(), mag.size(), [](mode_s_t *self, struct mode_s_msg *mm) {
        receiver->onNotify(self, mm);
    });
}

void ADSBReceiver::processFlights() {
    QVariantList messageList;
    QHash<QString, QVariant> flightHashMap;

    for (const auto& entry : flightMapList) {
        const auto& message = entry.second;
        QVariantMap msgMap;

        msgMap["icao24"] = QString::fromStdString(message.icao24);
        msgMap["callsign"] = QString::fromStdString(message.callsign);
        msgMap["latitude"] = message.latitude;
        msgMap["longitude"] = message.longitude;
        msgMap["altitude"] = message.altitude;
        msgMap["verticalRate"] = message.verticalRate;
        msgMap["verticalRateSource"] = message.verticalRateSource;
        msgMap["heading"] = message.heading;
        msgMap["squawk"] = message.squawk;
        msgMap["type"] = QString::fromStdString(message.type);
        msgMap["country"] = QString::fromStdString(message.country);

        qDebug() << "getFlights: icao24:" << msgMap["icao24"].toString()
                 << ", Callsign:" << msgMap["callsign"].toString()
                 << ", Latitude:" << msgMap["latitude"].toDouble()
                 << ", Longitude:" << msgMap["longitude"].toDouble()
                 << ", Altitude:" << msgMap["altitude"].toInt()
                 << ", Vertical Rate:" << msgMap["verticalRate"].toInt()
                 << ", Vertical Rate Source:" << msgMap["verticalRateSource"].toInt()
                 << ", Heading:" << msgMap["heading"].toInt();

        QString callsign = msgMap["callsign"].toString();
        if (callsign.contains("?")) {
            continue;
        }

        QString callsignKey = msgMap["icao24"].toString();
        if (flightHashMap.contains(callsignKey)) {
            flightHashMap[callsignKey] = msgMap;
        } else {
            flightHashMap.insert(callsignKey, msgMap);
        }
    }

    for (auto it = flightHashMap.begin(); it != flightHashMap.end(); ++it) {
        messageList.append(it.value());
    }

    emit flightsReady(messageList);
}
