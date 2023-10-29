const int pin = 13;

void setup() {
    Serial.begin(9600);
    pinMode(pin, OUTPUT);
}

void loop() {
  digitalWrite(pin, HIGH);
  Serial.write("HIGH\n");
  delay(1500);
  digitalWrite(pin, LOW);
  Serial.write("LOW\n");
  delay(500);
}
