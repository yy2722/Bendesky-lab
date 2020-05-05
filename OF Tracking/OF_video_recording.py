import picamera
from time import sleep
import datetime
import os

#config
camera = picamera.PiCamera()
camera.resolution = (640, 480)
local_video_folder = '/home/pi/Desktop/videos/'
local_still_folder = '/home/pi/Desktop/stills/'
date = datetime.datetime.now().strftime("%Y%m%d")

videoCount = 0  
hours_of_video = 10 #10 hours of recording (total)
segment_length = 1 #each segment is 1 hr
segments = int(hours_of_video/segment_length) # number of segments

def rollingTimeStamp(): # allows the timestamp to be continuously updated
        now = datetime.datetime.now()
        
        while (datetime.datetime.now() - now).seconds < (segment_length*60*60):# how long is each segment in seconds
                        camera.annotate_text_size = 10
                        camera.annotate_text = strain+" "+sex+" "+mouseID+" "+datetime.datetime.now().strftime('%H:%M:%S')


def getDiskSpace():
	p = os.popen("df")
	i = 0
	while 1:
		i = i + 1
		line = p.readline()
		if i == 2:
			return(line.split()[1:5])
		    
# Calculate remaining disk space
RemainingDiskSpace = getDiskSpace()[2]
Percentage_Used = getDiskSpace()[3]
min_per_byte = 1.9073486328125e-06

min_available = int(RemainingDiskSpace)/min_per_byte
hr_available = min_available/60
print(str(hr_available) + " hr available for recording")
continueDisk = input("continue? Y/N")
# ----------

if continueDisk == "Y":

    camera.capture(local_still_folder + date + '.jpg') # Take a background picture (no mouse)

    # Put mouse in OF and let acclimate; then enter data:
    strain = input("Enter strain (PO, BW, F1, etc): ")
    sex = input("Press M for male; F for female. ")
    mouseID = input("Enter mouse ID: " )
    other = input("Any other comments? If no, press enter. ")
    input("Press enter to start trial.")

    sleep(3) #3 sec delay before recording - opening the gate
    print("Trial has started. Press CTRL+C to end video early.")
    name = date+'_'+strain+'_'+sex+'_'+mouseID+'_'+other

    camera.start_preview(alpha=220)
        
    # record 10 segments of video sequentially
    for i in range(segments):
        camera.start_recording(local_video_folder + name + '_' + str(i+1)+'.h264')
        rollingTimeStamp()

    # the space here in annotate_text will allow to align in top left corner
      
        camera.stop_recording()
        videoCount += 1
        print(str(videoCount) + " videos recorded")

    camera.stop_preview()
    print("End of trial.")

else:
    print("End of trial.")
