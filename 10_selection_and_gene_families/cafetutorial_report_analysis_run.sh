#!/bin/bash
#SBATCH --job-name=cafetutorial_report_analysis_run
#SBATCH -e cafetutorial_report_analysis_.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=vlamba@uark.edu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=15
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint 'xz036'
#SBATCH --time=100:00:00

module load python/2.7.3

cd /home/vlamba/Noto_CAFE_results/SLC_ID_SCRIPTS/Fulton_python_scripts

python cafetutorial_report_analysis.py -r 0 -o report -i /home/vlamba/Noto_CAFE_results/Base_report.cafe > /home/vlamba/Noto_CAFE_results/cafetutorial_report.txt
