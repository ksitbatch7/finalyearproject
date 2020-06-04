import RPi.GPIO as GPIO
import time
import requests
import picamera


camera = picamera.PiCamera()
camera.start_preview()


IR1 = 4
IR2 = 11
L1 = 6
L2 = 13
R1 = 19
R2 = 26

stop_count = 3
camera_stabilization_time = 3

GPIO.setmode(GPIO.BCM)
GPIO.setup(IR1, GPIO.IN)
GPIO.setup(IR2, GPIO.IN)
GPIO.setup(L1, GPIO.OUT) 
GPIO.setup(L2, GPIO.OUT) 
GPIO.setup(R1, GPIO.OUT) 
GPIO.setup(R2, GPIO.OUT) 
image_count = 1

def upload_image(image_name):
    url = 'http://192.168.0.106/upload'#change IP (latop/server ip)
    files = {'image_data': open(image_name , 'rb')}
    requests.post(url, files=files)


while stop_count:

    IR1_state = GPIO.input(IR1)
    IR2_state = GPIO.input(IR2)
    # print(IR1_state,IR2_state)
    # print(stop_count)

    if (IR1_state == IR2_state == 1):
        GPIO.output(L1, False)
        GPIO.output(L2, False)
        GPIO.output(R1, False)
        GPIO.output(R2, False)
        print('Preparing to take image...')
        time.sleep(camera_stabilization_time)
        image_name =  str(image_count) +'tree.jpg'
        camera.capture(image_name)
        upload_image(image_name)
        print('Image Captured')
        stop_count = stop_count-1
        image_count = image_count +1
        print(stop_count)
        GPIO.output(L1, False)
        GPIO.output(L2, True)
        GPIO.output(R1, False)
        GPIO.output(R2, True)
        time.sleep(2)
    else:
        GPIO.output(L1, False)
        GPIO.output(L2, True)
        GPIO.output(R1, False)
        GPIO.output(R2, True)
        
GPIO.output(L1, False)
GPIO.output(L2, False)
GPIO.output(R1, False)
GPIO.output(R2, False)        
camera.stop_preview()