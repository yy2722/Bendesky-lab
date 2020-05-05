import os
import numpy as np
import os
import pandas as pd
import fnmatch

pixels_per_cm =3.25 #calculated by dividing 390 pixels with 120 cm (per side)

# Compile files to analyze in a list
files = []
counter = 0
distance_path = '/Volumes/bendesky-locker/Tim/Tracking/OF/results/distance'  # path for saving the processed data

smoothed_total = pd.DataFrame(columns=['Date', 'Strain', 'Sex', 'ID', 'Segment', 'Total_distance'])
smoothed_total = smoothed_total[['Date', 'Strain', 'Sex', 'ID', 'Segment', 'Total_distance']]  #storing all total distance values in one dataframe output

# Calculate the distance frame by frame
def calcDistance(table):
    distance = []   # Create a list for storing distance value at each frame
    for frame in range(len(table)-1):   # Loop through all frames except the last one
           distance.append(np.sqrt((table['x'][frame+1]- table['x'][frame])**2+ (table['y'][frame+1]- table['y'][frame])**2))
    total_distance = np.sum(distance)   # Sum up all values to get total distance
    return distance, total_distance

def smooth(x,window_len=10,window='flat'):
    '''
    from http://wiki.scipy.org/Cookbook/SignalSmooth
    smooth the data using a window with requested size.
    
    This method is based on the convolution of a scaled window with the signal.
    The signal is prepared by introducing reflected copies of the signal 
    (with the window size) in both ends so that transient parts are minimized
    in the begining and end part of the output signal.
    
    input:
        x: the input signal 
        window_len: the dimension of the smoothing window; should be an odd integer
        window: the type of window from 'flat', 'hanning', 'hamming', 'bartlett', 'blackman'
            flat window will produce a moving average smoothing.

    output:
        the smoothed signal, unless x.size < window_len, in which case returns the raw data
    '''

    if x.ndim != 1:
        raise ValueError, "smooth only accepts 1 dimension arrays."
    if x.size < window_len:
        return x
        # raise ValueError, "Input vector needs to be bigger than window size."
    if window_len<3:
        return x
    if not window in ['flat', 'hanning', 'hamming', 'bartlett', 'blackman']:
        raise ValueError, "Window is on of 'flat', 'hanning', 'hamming', 'bartlett', 'blackman'"
    s=np.r_[x[window_len-1:0:-1],x,x[-1:-window_len:-1]]
    #print(len(s))
    if window == 'flat': #moving average
        w=np.ones(window_len,'d')
    else:
        w=eval('np.'+window+'(window_len)')
    y=np.convolve(w/w.sum(),s,mode='valid')
    smoothed = y[(window_len/2-1):-(window_len/2)]
    return smoothed

for file in os.listdir('.'):
    if fnmatch.fnmatch(file, '2018*'):
        files.append(file)

# Loop through specific files
for i in files:
    with open(i) as f:
        table = pd.read_table(f, sep='\t', index_col=False, header=None, names=['frame','x','y','where'], lineterminator='\n')

    #calculating distance travelled
    distance,total_distance = calcDistance(table) # In pixels
    smoothed_distance = pd.DataFrame(smooth(np.array(distance)))
    #total_smoothed_distance = [np.sum(smoothed_distance)]
    total_smoothed_distance = np.sum(smoothed_distance)
    dis_in_cm = int(total_smoothed_distance/pixels_per_cm)

    full = i.split(".")[0]
    date = full.split("_")[0]
    strain = full.split("_")[1]
    sex = full.split("_")[2]
    ID = full.split("_")[3]
    video_seg = "_".join(full.split("_")[4:6]) 
    animal = "_".join(full.split("_")[0:6])

    smoothed_total.loc[counter] = [date, strain, sex, ID, video_seg, dis_in_cm]
    #smoothed_distance.to_csv(os.path.join(distance_path, animal+'_distance.txt'), sep='\t', header=False, index=False)
    

    counter +=1
    print(counter)
    print(animal)
    print(dis_in_cm)
    #print(video_seg)
    #print(animal)
    
smoothed_total.to_csv(os.path.join(distance_path, date+'_total_distance.txt'), sep='\t', header=False, index=False)



