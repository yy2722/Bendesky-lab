from subprocess import call
from glob import glob
import os

video_path = "/Volumes/bendesky-locker/Tim/videos"
vids = glob(os.path.join(video_path,'*.h264'))

for v in vids:
    video_mp4 = v + '.mp4'
    cmd = "MP4Box -add " + v + " " + video_mp4
    call(cmd.split(" "))
    
    
