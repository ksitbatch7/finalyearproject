import RPi.GPIO as GPIO
from picamera import PiCamera
from time import sleep 

GPIO.setwarnings(False) 
GPIO.setmode(GPIO.BOARD) 

motor_l1 = 8
motor_l2 = 10
motor_r1 = 12
motor_r2 = 16

GPIO.setup(motor_l1, GPIO.OUT, initial=GPIO.LOW) 
GPIO.setup(motor_l2, GPIO.OUT, initial=GPIO.LOW) 
GPIO.setup(motor_r1, GPIO.OUT, initial=GPIO.LOW) 
GPIO.setup(motor_r2, GPIO.OUT, initial=GPIO.LOW) 

camera.start_preview()
count = 1
try:
  if(count <=5):

    GPIO.output(motor_l1, GPIO.HIGH)
    GPIO.output(motor_l2, GPIO.LOW)
    GPIO.output(motor_r1, GPIO.HIGH)
    GPIO.output(motor_r2, GPIO.LOW)
    sleep(5) 
    GPIO.output(motor_l1, GPIO.LOW)
    GPIO.output(motor_l2, GPIO.LOW)
    GPIO.output(motor_r1, GPIO.LOW)
    GPIO.output(motor_r2, GPIO.LOW)
    sleep(1)
    camera.capture('/photos/Tree'+str(count)+'.jpg')
    leaf_detect() 
    sleep(4)
    count

leaf_detect()

except KeyboardInterrupt:
    camera.stop_preview()