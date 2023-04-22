// Created and adapted by Mario Madureira Fontes
// Arduino conectors
// D = SDA (UNO/Decimilanove= A4)
// C = SCL (UNO/Decimilanove= A5)
// Other boards: http://www.arduino.cc/en/Reference/Wire
// Board            I2C / TWI pins
// Uno, Ethernet    A4 (SDA), A5 (SCL)
// Mega2560         20 (SDA), 21 (SCL)
// Leonardo          2 (SDA),  3 (SCL)
// Due              20 (SDA), 21 (SCL), SDA1, SCL1

#include "Wire.h"
#include "WiiChuckClass.h"

int loop_cnt=0;

byte accx,accy,zbut,cbut,joyX,joyY;

void setup()
{
    Serial.begin(9600);
    Serial.println("wtf");
    nunchuck_setpowerpins();
    nunchuck_init(); // send the initilization handshake
}

// Example Dump code
// Mario Madureira Fontes
//void loop()
//{
//    if( loop_cnt > 100 ) { // every 100 msecs get new data
//        loop_cnt = 0;
//
//        nunchuck_get_data();
//
//        accx = nunchuck_accelx(); // ranges from 70 - 182 Deadzone Min 120 Max 130
//        accy = nunchuck_accely(); // ranges from 65 - 173 DeadZone Min 130 Max 140
//        zbut = nunchuck_zbutton(); // values 0 or 1
//        cbut = nunchuck_cbutton(); // values 0 or 1
//        joyX = nunchuck_joyx(); // ranges from 25 - 223 DeadZoneX = Min 115 Max 119
//        joyY = nunchuck_joyy(); // ranges from 37 - 228 DeadZoneY = Min 131 Max 134
//        Serial.print("JoyX: "); Serial.print((byte)joyX,DEC);
//        Serial.print("\tJoyY: "); Serial.print((byte)joyY,DEC);
//        Serial.print("\taccx: "); Serial.print((byte)accx,DEC);
//        Serial.print("\taccy: "); Serial.print((byte)accy,DEC);
//        Serial.print("\tzbut: "); Serial.print((byte)zbut,DEC);
//        Serial.print("\tcbut: "); Serial.println((byte)cbut,DEC);
//    }
//    loop_cnt++;
//    delay(1);
//}

void loop() 
{
    if( loop_cnt > 100 ) { // every 100 msecs get new data
        loop_cnt = 0;
        nunchuck_get_data();
        
        if(nunchuck_zbutton() == 0) {
            Serial.println(mapJoyValues(nunchuck_joyx(),25,223,115,119));
            //Serial.println(mapJoyValues0TO100(nunchuck_joyx(),25,223,115,119));
            //Serial.println("zbutton==0");
        }
        
        if(nunchuck_zbutton() == 1) {
            Serial.println(mapJoyValues(nunchuck_accelx(),71,179,120,130));
            //Serial.println(mapJoyValues0TO100(nunchuck_accelx(),71,179,120,130));
            //Serial.println("zbutton==1");
        }
    }
    loop_cnt++;
    delay(1);
}
