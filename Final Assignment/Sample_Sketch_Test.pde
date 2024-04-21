
import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int button1_val = 0;
int button2_val = 0;
int button3_val = 0;
int button4_val = 0;
int knob_val = 0;
int slider_val = 0;

void setup() {
  fullScreen();

  String portName = Serial.list()[1];
  print(portName);
  myPort = new Serial(this, portName, 115200);
  print("finished setup..");
}

void draw() {
  background(0);
  fill(#F1F1F1);
  noStroke();

  float tilesX = width/4;
  float tilesY = height/4;

  float tileW = width / 80;
  float tileH = height / 45;

  translate(tileW / 2, tileH / 2);

  for (int x = 0; x < tilesX; x++) {
    for (int y = 0; y < tilesY; y++) {
      if ( button1_val == 0 ) {
        float waveX = sin(radians( frameCount + x * 10 )) * knob_val * 2;
        float waveY = sin(radians( frameCount + y * 10 )) * slider_val * 2;
        pushMatrix();
        translate(tileW * x + waveX, tileH * y + waveY);
        fill(random(255), random(255), 0);
        ellipse(0, 0, tileW, tileH);
        popMatrix();
      } else if ( button2_val == 0 ) {
        float waveX = sin(radians( frameCount + x * 15 )) * knob_val * 4;
        float waveY = sin(radians( frameCount + y * 2 )) * slider_val * 4;
        //float knob_col = map(knob_val, 0, 255, 200, 255);
        pushMatrix();
        translate(tileW * x + waveX, tileH * y + waveY);
        square(0, 0, tileW);
        popMatrix();
      } else if ( button3_val == 0 ) {
        float waveX = sin(radians( frameCount + x * 20 )) * knob_val * 12;
        float waveY = sin(radians( frameCount + y * 30 )) * slider_val * 40;
        pushMatrix();
        translate(tileW * x + waveX, tileH * y + waveY);
        fill(0, random(255), 100);

        rect(0, 0, 20, tilesY);


        popMatrix();
      } else if ( button4_val == 0 ) {
        //float waveX = tan(radians( frameCount + x * 10 )) * knob_val * 8;
        //float waveY = tan(radians( frameCount + y * 12 )) * slider_val * 12;
        pushMatrix();
        translate(tileW * x, tileH * y);

        float w = map(sin(radians(frameCount)), -1, 1, 0, 3);
        for (x = 0; x < tilesX; x++) {
          for (y = 0; y < tilesY; y++) {
            float a = map(tan(radians(x*1 + y*1)), -1, 1, -300, 300);
            float c = map(tan(radians(frameCount * 2 + x * w + y * w * a)), -1, 1, 0, slider_val);
            fill(c, 100, 255);
            rect(x * tileW * 0.9, y * tileH * 0.9, knob_val/10 * 0.9, knob_val/10 * 0.9);
          }
        }
        popMatrix();
        noFill();
      }
    }
  }

  if ( myPort.available() > 0) {  // If data is available,

    String tempString = myPort.readStringUntil('\n');

    if (tempString != null) {
      String[] dataArray = split(tempString, ",");

      //print(MyList);
      if (dataArray.length >= 6)  // at least 2 values received..
      {
        button1_val = int(dataArray[0].trim());
        button2_val = int(dataArray[1].trim());
        button3_val = int(dataArray[2].trim());
        button4_val = int(dataArray[3].trim());
        knob_val = int(dataArray[5].trim());
        slider_val = int(dataArray[4].trim());

        println("button1 =", button1_val);
        println("button2 =", button2_val);
        println("button3 =", button3_val);
        println("button4 =", button4_val);
        println("knob =", knob_val);
        println("slider =", slider_val);
      }
    }
  }
}
