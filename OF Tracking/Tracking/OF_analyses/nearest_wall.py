import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import fnmatch
import datetime
import math

save_path = '/Volumes/FAT/Bendesky/Tracking/OF/results/nearest_wall'

def wallLeft(x):
    if x == 0:
        return 0
    else:
        return abs(x-wall_left)

def wallRight(x):
    if x == 0:
        return 0
    else:
        return abs(x-wall_right)

def wallTop(x):
    if x == 0:
        return 0
    else:
        return abs(x-wall_top)

def wallBottom(x):
    if x == 0:
        return 0
    else:
        return abs(x-wall_bottom)        

# Compile files to analyze in a list:
files = []
whichColumn = 0 #counter

## Loop through specific files:
for file in os.listdir('.'):
    if fnmatch.fnmatch(file, '2018*'):
        files.append(file)
		
        #df = pd.DataFrame(columns=['Date','Strain','Sex','ID','Closed', 'Center', 'Open_near',
        #'Open_far', 'Open', 'O_c_distance', 'Total_distance'])
        #df = pd.DataFrame(columns=['Date','Strain','Sex','ID', 'Segment','Very_center', 'Intermediate_center', 'Intermediate','Near_wall', 'Home_cage'])
        #df = df[['Date', 'Strain', 'Sex', 'ID', 'Segment', 'Very_center', 'Intermediate_center', 'Intermediate', 'Near_wall', 'Home_cage']]

# cd to EPM/data
# getting info from raw data
for i in files:
    with open(i) as f:
        table = pd.read_table(f, sep='\t', index_col=False, header=None, names=['frame','x','y','where'], lineterminator='\n')
    #last = table.index[-1] + 1
    if fnmatch.fnmatch(i, '20180606*'):
        wall_left = 117
        wall_right = 499
        wall_top = 77
        wall_bottom = 459
    elif fnmatch.fnmatch(i, '20180607*'):
        wall_left = 101
        wall_right = 495
        wall_top = 56
        wall_bottom = 499
    elif fnmatch.fnmatch(i, '20180608*'):
        wall_left = 116
        wall_right = 511
        wall_top = 65
        wall_bottom = 459
    elif fnmatch.fnmatch(i, '20180609*'):
        wall_left = 146
        wall_right = 534
        wall_top = 58
        wall_bottom = 445
    elif fnmatch.fnmatch(i, '20180610*'):
        wall_left = 119
        wall_right = 514
        wall_top = 50
        wall_bottom = 445
    elif fnmatch.fnmatch(i, '20180611*'):
        wall_left = 99
        wall_right = 488
        wall_top = 38
        wall_bottom = 426
    elif fnmatch.fnmatch(i, '20180612*'):
        wall_left = 110
        wall_right = 497
        wall_top = 37
        wall_bottom = 424
    elif fnmatch.fnmatch(i, '20180613*'):
        wall_left = 126
        wall_right = 517
        wall_top = 29
        wall_bottom = 419
    elif fnmatch.fnmatch(i, '20180614*'):
        wall_left = 159
        wall_right = 547
        wall_top = 51
        wall_bottom = 438
    elif fnmatch.fnmatch(i, '20180615*'):
        wall_left = 146
        wall_right = 536
        wall_top = 33
        wall_bottom = 422
    elif fnmatch.fnmatch(i, '20180616*'):
        wall_left = 165
        wall_right = 551
        wall_top = 27
        wall_bottom = 413
    elif fnmatch.fnmatch(i, '20180617*'):
        wall_left = 113
        wall_right = 505
        wall_top = 41
        wall_bottom = 432
    elif fnmatch.fnmatch(i, '20180618*'):
        wall_left = 101
        wall_right = 496
        wall_top = 43
        wall_bottom = 437
    else:
        wall_left = 134
        wall_right = 524
        wall_top = 66
        wall_bottom = 456

    # Get frequency
    #table['freq'] = table.groupby('where')['where'].transform('count')
    #freq = table.groupby('where').agg({'freq' : 'max'})
    #inOrder = freq.reindex(["very_center", "intermediate_center", "intermediate", "near_wall", "home_cage"])
    x_nearL = map(wallLeft, table['x'])
    x_nearR = map(wallRight, table['x'])
    y_nearT = map(wallTop, table['y'])
    y_nearB = map(wallBottom, table['y'])
    #print(table['x'])
    #print(table['y'])
    #print(freq)
    #print(inOrder)
    #print(x_nearL)
    #print(y_nearT)

    nearest_dist = map(min, zip(x_nearL, x_nearR, y_nearT, y_nearB)) #a list with the minimal value at each frame
   
    # Calculate proportional frequencies 
    #freq_percent = inOrder.divide(last, axis='columns', level=None, fill_value=0)
    #print(freq_percent)
    # EPM analysis
    #   allClosed = freq_percent.iloc[0]['freq'] + freq_percent.iloc[1]['freq']
    #   Center = freq_percent.iloc[2]['freq']
    #   allOpenNear = freq_percent.iloc[3]['freq'] + freq_percent.iloc[4]['freq']
    #   allOpenFar = freq_percent.iloc[5]['freq'] + freq_percent.iloc[6]['freq']
    #   allOpen = allOpenNear + allOpenFar

    #very_center = round(freq_percent.iloc[0]['freq'], 3)
    #intermediate_center = round(freq_percent.iloc[1]['freq'], 3)
    #intermediate = round(freq_percent.iloc[2]['freq'], 3)
    #near_wall = round(freq_percent.iloc[3]['freq'], 3)
    #home_cage = round(freq_percent.iloc[4]['freq'], 3)
    
    #print(very_center)
    # EPM analysis
    # Calculate distance
    # total_dist = 0
    # closed_right_total = 0
    #distance = {'Closed_right': 0, 'Closed_left': 0, 'Open_up_far': 0, 'Open_up_near': 0, 'Open_down_near': 0,
    # 'Open_down_far': 0, 'Center': 0}
    # **actually I need to change this -- consolidate open near and far arms before initializing dictionary 
    # so that don't lose distance info in the frame where transitioning from near to far ??
    #for index, column in table.iterrows():
    #   if index != 0:
    #       dist = math.hypot(column['x'] - x, column['y'] - y)
    #       if column['arm'] == arm:
    #           distance[column['arm']] += dist
    #           #total_dist += dist
    #           #y = column['y']
    #        x = column['x']
    #        arm = column['arm']
    #
    #       o_c_dist = (distance['Open_up_far']+distance['Open_up_near']+distance['Open_down_far']+
    #           distance['Open_down_near'])/(distance['Closed_right']+distance['Closed_left'])

    
    #full = i.split(".")[0]
    #date = full.split("_")[0]
    #strain = full.split("_")[1]
    #sex = full.split("_")[2]
    #ID = full.split("_")[3]
    #video_seg = full.split("__")[1]
    

    #print(video_seg)
    #print(r)
    #print(date)
    
    #df.loc[whichRow] = [date, strain, sex, ID, video_seg, very_center, intermediate_center, intermediate, near_wall, home_cage] #adding the data to row r
    #whichRow +=1 #counter
    full = i.split(".")[0]
    name = '_'.join(full.split('_')[0:6])

    if whichColumn == 0:
        df = pd.DataFrame(nearest_dist, columns = [name]) # create a data frame with the columns named after each file name
    
    else:
        newdf = pd.DataFrame(nearest_dist, columns = [name])
        df = df.join(newdf, how='outer')
    #kwargs = {full : nearest_dist}
    #df = df.assign(**kwargs)
    whichColumn +=1 #counter
    print(whichColumn)
print(df)

# Save as tab-delimited txt file
#now = datetime.datetime.now
#todaysDate = now.strftime('%Y%m%d')
#df.to_csv('./analysis/'+todaysDate+'_OF_data.txt', sep='\t', header=True, index=False)
#df.to_csv('./analysis/20180205_EPM_data.txt', sep='\t', header=True, index=False)
now = datetime.datetime.now()
todayDate = now.strftime('%Y%m%d')
df.to_csv(os.path.join(save_path, todayDate+'_nearest_wall.txt'), sep='\t', header=True, index=False)
