import os, sys, io
import M5
from M5 import *
from hardware import *
import time

pin8 = None
pin7 = None
pin38 = None
pin39 = None  # red connector
pin41 = None
screen_button_val = None
button1_val = None
button2_val = None
button3_val = None
button4_val = None
adc1 = None
adc1_val = None
adc2 = None
adc2_val = None


def setup():
  global pin38, pin39, pin8, pin7
  global pin41, screen_button_val
  global button1_val, adc1, adc2
  M5.begin()
  
  pin38 = Pin(38, mode=Pin.IN)
  pin39 = Pin(39, mode=Pin.IN)
  #Buttons 3 and 4
  pin8 = Pin(8, mode=Pin.IN)
  pin7 = Pin(7, mode=Pin.IN)
  # initialize pin 41 (screen button on AtomS3 board) as input:
  pin41 = Pin(41, mode=Pin.IN)
  #adc Value
  # initialize analog to digital converter on pin 1:
  adc1 = ADC(Pin(5), atten=ADC.ATTN_11DB)
  adc2 = ADC(Pin(6), atten=ADC.ATTN_11DB)
  
# function to map input value range to output value range:
def map_value(in_val, in_min, in_max, out_min, out_max):
  out_val = out_min + (in_val - in_min) * (out_max - out_min) / (in_max - in_min)
  if out_val < out_min:
    out_val = out_min
  elif out_val > out_max:
    out_val = out_max
  return int(out_val)
  
  

def loop():
  global screen_button_val
  global button1_val, button2_val
  global adc1, adc1_val, adc2_val
  M5.update()
  
  screen_button_val = pin41.value()
  
  #read the 4 buttons
  button1_val = pin39.value()
  button2_val = pin38.value()
  button3_val = pin8.value()
  button4_val = pin7.value()
  
  # read ADC value:
  adc1_val = adc1.read()
  # read ADC value:
  adc2_val = adc2.read()

  # map the ADC value from 0-4095 to 0-255 (8-bit) range:
  adc1_val_8bit = map_value(adc1_val, 0, 4095, 0, 255)
  adc2_val_8bit = map_value(adc2_val, 0, 4095, 0, 255)
  
  # print the 8-bit ADC value:
  #print(str(adc1_val_8bit))
  
  # print the 8-bit ADC value:
  print(button1_val, end=',')
  print(button2_val, end=',')
  print(button3_val, end=',')
  print(button4_val, end=',')
  print(adc1_val_8bit, end=',')
  print(adc2_val_8bit)
  
  time.sleep_ms(100)
  

if __name__ == '__main__':
  try:
    setup()
    while True:
      loop()
  except (Exception, KeyboardInterrupt) as e:
    try:
      from utility import print_error_msg
      print_error_msg(e)
    except ImportError:
      print("please update to latest firmware")
