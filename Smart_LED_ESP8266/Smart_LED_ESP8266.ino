#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <Adafruit_NeoPixel.h>
#include <SoftwareSerial.h>

// Credenciales WiFi
const char* ssid = "IZZI-157D";
const char* password = "euk7dTTxbaF7";

// Pines para los cátodos del LED RGB
const int redPin = D0;
const int greenPin = D4;
const int bluePin = D7;

// Configuración del LED normal
const int normalLedPin = D1;

// Configuración de la tira LED WS2812B
#define WS2812B_PIN D8
#define WS2812B_COUNT 300 // Ajustar según la cantidad de LEDs de tu tira
Adafruit_NeoPixel ws2812bLedStrip = Adafruit_NeoPixel(WS2812B_COUNT, WS2812B_PIN, NEO_GRB + NEO_KHZ800);

// Bluetooth serial
const int rxPin = D5; // Pin RX del ESP8266 conectado al pin TX del módulo Bluetooth
const int txPin = D6; // Pin TX del ESP8266 conectado al pin RX del módulo Bluetooth
SoftwareSerial bluetoothSerial(rxPin, txPin);

// Almacena los valores RGB
int red = 0;
int green = 0;
int blue = 0;

// Servidor web
ESP8266WebServer server(80);

// Prototipos de funciones
void handleRoot();
void handleRgbLed();
void handleNormalLed();
void handleWs2812bLed();

void setup() {
  Serial.begin(115200);

  // Configuración de los pines para el LED RGB
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);

  // Configuración del LED normal
  pinMode(normalLedPin, OUTPUT);

  // Configuración de la tira LED WS2812B
  ws2812bLedStrip.begin();
  ws2812bLedStrip.show();

  // Configuración Bluetooth
  bluetoothSerial.begin(9600); // Ajustar la velocidad según tu módulo Bluetooth

  // Configuración WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Conectando a WiFi..");
  }
  Serial.println("Conectado a WiFi");
  Serial.println(WiFi.localIP());

  // Configuración de rutas del servidor web
  server.on("/", HTTP_GET, handleRoot);
  server.on("/rgbled", HTTP_GET, handleRgbLed);
  server.on("/normalled", HTTP_GET, handleNormalLed);
  server.on("/color", HTTP_GET, handleWs2812bLed);
  server.begin();
}

void loop() {
  server.handleClient();
  
  // Manejar Bluetooth
  if (bluetoothSerial.available()) {
    char incomingChar = bluetoothSerial.read();
    if (incomingChar == 'R') {
      red = bluetoothSerial.parseInt();
      analogWrite(redPin, red);
    } else if (incomingChar == 'G') {
      green = bluetoothSerial.parseInt();
      analogWrite(greenPin, green);
    } else if (incomingChar == 'B') {
      blue = bluetoothSerial.parseInt();
      analogWrite(bluePin, blue);
    }
  }
}

void handleRoot() {
  server.send(200, "text/plain", "Bienvenido al Control de LEDs con ESP8266");
}

void handleRgbLed() {
  if (server.hasArg("red") && server.hasArg("green") && server.hasArg("blue")) {
    red = server.arg("red").toInt();
    green = server.arg("green").toInt();
    blue = server.arg("blue").toInt();
    analogWrite(redPin, red);
    analogWrite(greenPin, green);
    analogWrite(bluePin, blue);
    server.send(200, "text/plain", "LED RGB actualizado");
  } else {
    server.send(400, "text/plain", "Parámetros RGB faltantes");
  }
}

void handleNormalLed() {
  digitalWrite(normalLedPin, !digitalRead(normalLedPin)); // Alternar el estado del LED
  server.send(200, "text/plain", "LED normal alternado");
}

void handleWs2812bLed() {
  if (server.hasArg("red") && server.hasArg("green") && server.hasArg("blue")) {
    red = server.arg("red").toInt();
    green = server.arg("green").toInt();
    blue = server.arg("blue").toInt();
    for (int i = 0; i < WS2812B_COUNT; i++) {
      ws2812bLedStrip.setPixelColor(i, red, green, blue);
    }
    ws2812bLedStrip.show();
    server.send(200, "text/plain", "Tira LED WS2812B actualizada");
  } else {
    server.send(400, "text/plain", "Parámetros RGB faltantes");
  }
}
