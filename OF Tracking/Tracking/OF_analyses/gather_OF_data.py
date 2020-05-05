'''
This code is for processing data output from video tracking
'''

import os
import pandas as pd
from glob import glob
import numpy as np
import datetime

counter=0
# Tracked video output directory
#tracked_path = '/Volumes/bendesky-locker/Tim/Tracking/OF/data'
tracked_path = '/Users/Timo/Documents/Bendesky/Tracking/OF/data'
# Results folder
#results_path = '/Volumes/bendesky-locker/Tim/Tracking/OF/results'
results_path = '/Users/Timo/Documents/Bendesky/Tracking/OF/results'
# Functions
def combine_data_for_files(files):
	'''
	From a list of files, gets data and combines into a dataframe
	'''
	# Hold pandas dataframe of each file in a list
	results = []
	for i in files:
		with open(i,'r') as f:
			table = pd.read_table(f, sep='\t', index_col=False, header=None, skiprows=9, names=['frame','x','y','where'], lineterminator='\n')
		results.append(table)
	combined_data = pd.concat(results)
	return combined_data

# Get list of all tracked files
tracked_files = glob(os.path.join(tracked_path,'*.txt'))

# Get date_strain_sex_mouseID of each video
#indivs = ['_'.join(tf.split('/')[7].split('_')[0:4]) for tf in tracked_files]
indivs = ['_'.join(tf.split('/')[8].split('_')[0:4]) for tf in tracked_files]
indivs_list = set(indivs) # Get rid of the repeated elements
#print(indivs_list)
# Get data for each individual
# Light
for i in indivs_list:
	# Create a directory per individual to hold results
	indiv_path = os.path.join(results_path,i+'_light*')
	if os.path.exists(indiv_path):
		continue
	else:
		print(indivs_list)
		#print(indiv_path)
		# Get all tracked files for indiv
		tracked_for_indiv = [tf for tf in tracked_files if i in tf]
		#print(len(tracked_files))
		#First sort files according to the order they were recorded
		#tracked_for_indiv = sorted(tracked_for_indiv, key=lambda hour: int(hour.split('__')[1].split('_')[0]))
		light_for_indiv = [t for t in tracked_for_indiv if 'light' in t]
		# Classify light files into before dark and after dark
		light_before = [l for l in light_for_indiv if int(l.split('__')[1].split('_')[0]) < 3]
		#print(light_for_indiv)
		light_after = [l for l in light_for_indiv if int(l.split('__')[1].split('_')[0]) > 7]
		dark_for_indiv = [t for t in tracked_for_indiv if 'dark' in t]
		# Gather data fro light before, light after, and dark
		light_before_results = combine_data_for_files(light_before)
		light_after_results = combine_data_for_files(light_after)
		dark_results = combine_data_for_files(dark_for_indiv)

		# Save results
		light_before_results.to_csv(os.path.join(results_path, i+'_light_before_results.txt'), sep='\t', header= False, index=False)
		light_after_results.to_csv(os.path.join(results_path,i+'_light_after_results.txt'), sep='\t', header= False, index=False)
		dark_results.to_csv(os.path.join(results_path,i+'_dark_results.txt'), sep='\t', header=False, index=False)
		counter+=1
		print(counter)
		
