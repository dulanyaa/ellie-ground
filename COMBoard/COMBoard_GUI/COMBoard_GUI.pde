import controlP5.*; 
import processing.serial.*;
import java.lang.*;

Serial port;
Table readings = new Table();


ControlP5 cp5; 
Textfield servo1, servo2;
PFont font;
String readingsFile;
int readingCount = 0;

void setup(){ 
  size(300, 450); 
  printArray(Serial.list());  
  port = new Serial(this, "COM3", 9600);  //needs to change!! select right port
  cp5 = new ControlP5(this);
  font = createFont("calibri light bold", 20);
  
  readings.addColumn("PT1");
  readings.addColumn("PT2");
  readings.addColumn("PT3");
  readings.addColumn("PT4");
  readings.addColumn("FM");
  readings.addColumn("LC1");
  readings.addColumn("LC2");
  readings.addColumn("LC3");
  saveTable(readings, "/Users/dulanya/Desktop/Spring\ 2022/STAR/readings.csv");
  
  //writes and saves data in .csv
  cp5.addButton("store_readings")     
    .setPosition(0, 50)  
    .setSize(300, 35)      
    .setFont(font)
  ;     
  
  ////load cell data
  //cp5.addButton("load_cell_data")     
  //  .setPosition(0, 150)  
  //  .setSize(300, 35)      
  //  .setFont(font)
  //;
  
  //servo 1 input
  servo1 = cp5.addTextfield("servo1")   
    .setPosition(0, 250) 
    .setSize(300, 35)      
    .setFont(font)
  ;
  
  //servo 2 input
  servo2 = cp5.addTextfield("servo2")     
    .setPosition(0, 355)  
    .setSize(300, 35)      
    .setFont(font)
  ;
}

void draw(){  //same as loop in arduino
  background(0, 0 , 0); 
  fill(0, 255, 0);             
  textFont(font);  
}

//writes readings to a table
void getReadings(Serial port){
  String val = port.readStringUntil('\n'); //The newline separator separates each Arduino loop. We will parse the data by each newline separator. 
  if (val!= null) { //We have a reading! Record it.
    readingCount++; 
    val = trim(val); //gets rid of any whitespace or Unicode nonbreakable space
    val = val.replaceAll("[^\\d,]", "");
    println(val); //Optional, useful for debugging. If you see this, you know data is being sent. Delete if  you like. 
    float sensorVals[] = float(split(val, ',')); //parses the packet from Arduino and places the valeus into the sensorVals array. I am assuming floats. Change the data type to match the datatype coming from Arduino. 
    
   
    TableRow newRow = readings.addRow(); //add a row for this new reading
    newRow.setFloat("PT1", sensorVals[0]);
    newRow.setFloat("PT2", sensorVals[1]);
    newRow.setFloat("PT3", sensorVals[3]);
    newRow.setFloat("PT4", sensorVals[4]);
    newRow.setFloat("FM", sensorVals[5]);
    newRow.setFloat("LC1", sensorVals[6]);
    newRow.setFloat("LC2", sensorVals[7]);
    newRow.setFloat("LC3", sensorVals[8]);
  }
}

//writes + saves readings table in a .csv
void store_readings(){
   getReadings(port);
   saveTable(readings, "/Users/dulanya/Desktop/Spring\ 2022/STAR/readings.csv");
}

//doesn't do anything rn
void loading_pressure_data(){
  port.write('p');
}

//doesn't do anything rn
void load_cell_data(){
  port.write('l');
}

void servo1() {
  int servo1_pos = Integer.parseInt(servo1.getText()); 
  port.write(1 + servo1_pos * 10); 
  //port.write('b');
}

void servo2(){
  int servo2_pos = Integer.parseInt(servo1.getText()); 
  port.write(2 + servo2_pos * 10); 
}
