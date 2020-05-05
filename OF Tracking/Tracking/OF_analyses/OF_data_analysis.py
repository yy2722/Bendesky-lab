import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import fnmatch
import datetime
import math

save_path = '/Volumes/FAT/Bendesky/Tracking/OF/results/analysis'

# Compile files to analyze in a list:
files = []
whichRow = 0 #counter

## Loop through specific files:
for file in os.listdir('.'):
    if fnmatch.fnmatch(file, '2018*'):
        files.append(file)
		
        #df = pd.DataFrame(columns=['Date','Strain','Sex','ID','Closed', 'Center', 'Open_near',
        #'Open_far', 'Open', 'O_c_distance', 'Total_distance'])
        df = pd.DataFrame(columns=['Date','Strain','Sex','ID', 'Segment','Very_center', 'Intermediate_center', 'Intermediate','Near_wall', 'Home_cage'])
        df = df[['Date', 'Strain', 'Sex', 'ID', 'Segment', 'Very_center', 'Intermediate_center', 'Intermediate', 'Near_wall', 'Home_cage']]

# cd to EPM/data
# getting info from raw data
for i in files:
    with open(i) as f:
        #table = pd.read_table(f, sep='\t', index_col=False, header=None, skiprows=9, names=['frame','x','y','where'], lineterminator='\n')
        table = pd.read_table(f, sep='\t', index_col=False, header=None, names=['frame','x','y','where'], lineterminator='\n')
    last = table.index[-1] + 1
    
    # Get frequency
    table['freq'] = table.groupby('where')['where'].transform('count')
    freq = table.groupby('where').agg({'freq' : 'max'})
    inOrder = freq.reindex(["very_center", "intermediate_center", "intermediate", "near_wall", "home_cage"])
    
    #print(table['freq'])
    #print(freq)
    #print(inOrder)
    
    # Calculate proportional frequencies 
    freq_percent = inOrder.divide(last, axis='columns', level=None, fill_value=0)
    #print(freq_percent)
    # EPM analysis
    #   allClosed = freq_percent.iloc[0]['freq'] + freq_percent.iloc[1]['freq']
    #   Center = freq_percent.iloc[2]['freq']
    #   allOpenNear = freq_percent.iloc[3]['freq'] + freq_percent.iloc[4]['freq']
    #   allOpenFar = freq_percent.iloc[5]['freq'] + freq_percent.iloc[6]['freq']
    #   allOpen = allOpenNear + allOpenFar

    very_center = freq_percent.iloc[0]['freq']
    intermediate_center = freq_percent.iloc[1]['freq']
    intermediate = freq_percent.iloc[2]['freq']
    near_wall = freq_percent.iloc[3]['freq']
    home_cage = freq_percent.iloc[4]['freq']
    
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

    
    full = i.split(".")[0]
    date = full.split("_")[0]
    strain = full.split("_")[1]
    sex = full.split("_")[2]
    ID = full.split("_")[3]
    segment = "_".join(full.split("_")[4:6])
    

    #print(video_seg)
    #print(r)
    #print(date)
    
    df.loc[whichRow] = [date, strain, sex, ID, segment, very_center, intermediate_center, intermediate, near_wall, home_cage] #adding the data to row r
    whichRow +=1 #counter

print(df)

# Save as tab-delimited txt file
now = datetime.datetime.now()
todaysDate = now.strftime('%Y%m%d')
df.to_csv(os.path.join(save_path, todaysDate+'_OF_data.txt'), sep='\t', header=True, index=False)
#df.to_csv('./analysis/20180205_EPM_data.txt', sep='\t', header=True, index=False)
