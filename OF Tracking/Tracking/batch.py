from glob import glob
import os
from subprocess import call

py_files = glob("tracking*")
py_files = [pf for pf in py_files if 'BW349' not in pf]

def script_cmd(py_file):
	batch_script = '''#!/bin/bash
#
#
#SBATCH --account=zi       #the account name
#SBATCH --job-name=TrackOF #the job name
#SBATCH -c 1               #the number of cpu cores to use
#SBATCH -N 1               #Nodes required for the job
#SBATCH --time=08:00:00    #the time the job will take
#SBATCH --mem-per-cpu=1gb   #the memory the job will take
#SBATCH -e TrackOF_%j.err #standard err goes to this filehostname
#SBATCH --mail-type=ALL    #send email job notifications
#SBATCH --mail-user=yy2722@columbia.edu    #email address

module load anaconda
source activate track

#command to execute Python program
python {}

#End of script
'''.format(py_file)

	return batch_script

for pf in py_files:
	sbatch_script_cmd = script_cmd(pf)
	file_handle = pf + '.sh'
	print(file_handle)
	with open(file_handle,'w') as fh:
		fh.write(sbatch_script_cmd)
	call(['sbatch', file_handle])
	# break