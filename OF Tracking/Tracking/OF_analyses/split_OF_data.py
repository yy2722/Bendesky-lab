'''
this code is for splitting the dark phase into eight 1hr data files
'''

import os
import pandas as pd
from glob import glob
import numpy as np
import datetime

which = 0
#The directory of the compiled data
#compiled_path = '/Volumes/bendesky-locker/Tim/Tracking/OF/results'
compiled_path = '/Volumes/FAT/Bendesky/Tracking/OF/results'

#The directory of the output data
#splitted_path = '/Volumes/bendesky-locker/Tim/Tracking/OF/results/splitted'
splitted_path = '/Volumes/FAT/Bendesky/Tracking/OF/results/splitted'
#Get all the compiled dark files in the results folder
dark_compiled_files = glob(os.path.join(compiled_path,'*_dark_results.txt'))

# Get date_strain_sex_mouseID of each file
indivs = ['_'.join(tf.split('/')[7].split('_')[0:4]) for tf in dark_compiled_files]

for i in dark_compiled_files:
	indiv_path = os.path.join(splitted_path, indivs[which]+'_dark_*')
	if os.path.exists(indiv_path):
		continue
	else:	
		with open(i, 'r') as f:
			table = pd.read_table(f, sep='\t', index_col=False, header=None, names=['frame','x','y','where'], lineterminator='\n')
			
		first_hr = table.iloc[:108000]
		second_hr = table.iloc[108000:108000*2]
		third_hr = table.iloc[108000*2:108000*3]
		fourth_hr = table.iloc[108000*3:108000*4]
		fifth_hr = table.iloc[108000*4:108000*5]
		sixth_hr = table.iloc[108000*5:108000*6]
		seventh_hr = table.iloc[108000*6:108000*7]
		eigth_hr = table.iloc[108000*7:table.index[-1]+1]


		#save results
		first_hr.to_csv(os.path.join(splitted_path, indivs[which]+'_dark_1hr.txt'), sep='\t', header= False, index=False)
		second_hr.to_csv(os.path.join(splitted_path, indivs[which]+'_dark_2hr.txt'), sep='\t', header= False, index=False)
		third_hr.to_csv(os.path.join(splitted_path, indivs[which]+'_dark_3hr.txt'), sep='\t', header= False, index=False)
		fourth_hr.to_csv(os.path.join(splitted_path, indivs[which]+'_dark_4hr.txt'), sep='\t', header= False, index=False)
		fifth_hr.to_csv(os.path.join(splitted_path, indivs[which]+'_dark_5hr.txt'), sep='\t', header= False, index=False)
		sixth_hr.to_csv(os.path.join(splitted_path, indivs[which]+'_dark_6hr.txt'), sep='\t', header= False, index=False)
		seventh_hr.to_csv(os.path.join(splitted_path, indivs[which]+'_dark_7hr.txt'), sep='\t', header= False, index=False)
		eigth_hr.to_csv(os.path.join(splitted_path, indivs[which]+'_dark_8hr.txt'), sep='\t', header= False, index=False)
	
		print('total =')
		print(len(table))

		print(len(first_hr))
		#print(first_hr.head(5))
		#print(first_hr.tail(5))
		#print(second_hr.tail(5))
		#print(third_hr.head(5))
		print(len(second_hr))
		print(len(third_hr))
		print(len(fourth_hr))
		print(len(fifth_hr))
		print(len(sixth_hr))
		print(len(seventh_hr))
		print(len(eigth_hr))
	
		print('splitted files add up to =')
		print(len(first_hr)+len(second_hr)+len(third_hr)+len(fourth_hr)+len(fifth_hr)+len(sixth_hr)+len(seventh_hr)+len(eigth_hr))
		#print(table.index[-1]+1)
	
		which +=1
		print(which)
		print(i)
	



