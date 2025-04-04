#ifndef RTLMANAGERTEST_H
#define RTLMANAGERTEST_H

#include <QObject>
#include <QVariantList>
#include <QTimer>
#include <cstdlib>  // rand() ve srand() için
#include <ctime>    // time() için
#include <cmath>    // M_PI için

class RTLManagerTest : public QObject
{
    Q_OBJECT

public:
    explicit RTLManagerTest(QObject *parent = nullptr) : QObject(parent) {
        std::srand(static_cast<unsigned int>(std::time(nullptr))); // Rastgele sayı üretimi için seed ayarlama
        connect(&timer, &QTimer::timeout, this, &RTLManagerTest::updateAirplanes);
        timer.start(1000); // Her 1000 ms'de bir (1 saniye)
    }

    Q_INVOKABLE QVariantList readAirplanes() {
        return airplanes; // Uçak listesini döndür
    }

signals:
    void airplanesUpdated(); // Uçak listesi güncellendi sinyali

private slots:
    void updateAirplanes() {
        QVariantList newAirplanes;

        // Uçak sayısını rastgele ayarlayın (5-10 arasında)
        int currentAirplaneCount = std::rand() % 6 + 5; // 5 ile 10 arasında rastgele değer

        // Radar merkezi (örneğin San Francisco koordinatları)
        double radarCenterLat = 37.7749;
        double radarCenterLong = -122.4194;

        // 10 km'lik alanda rastgele dağıtmak için gereken dönüşüm faktörleri
        double kmToDegrees = 1.0 / 110.574; // 1 derece enlem yaklaşık 110.574 km
        double radius = 10.0; // 10 km

        for (int i = 0; i < currentAirplaneCount; ++i) {
            QVariantMap airplane;
            airplane["info"] = QString("Uçak %1").arg(i + 1); // Uçak ismi

            // Rastgele açıyı ve mesafeyi hesapla
            double angle = (std::rand() % 360) * (M_PI / 180.0); // 0-360 derece arasında rastgele açı
            double distance = static_cast<double>(std::rand() % 10000) / 1000.0; // 0-10 km arasında rastgele mesafe

            // Koordinatları hesapla
            double latitude = radarCenterLat + (distance * kmToDegrees) * std::cos(angle);
            double longitude = radarCenterLong + (distance * kmToDegrees) * std::sin(angle);

            airplane["lat"] = latitude; // Rastgele latitude
            airplane["longitude"] = longitude; // Rastgele longitude
            newAirplanes.append(airplane);
        }

        airplanes = newAirplanes; // Yeni uçak listesini güncelle
        emit airplanesUpdated(); // Sinyali gönder
    }

private:
    QVariantList airplanes; // Uçak bilgileri
    QTimer timer; // Zamanlayıcı
};

#endif // RTLMANAGERTEST_H
