import sys
import os

significant_results_dir = sys.argv[1]
all_results_dir = sys.argv[2]
bh_file = sys.argv[3]
candidate_file = sys.argv[4]
q = float(sys.argv[5])

m=0
for file in os.listdir(all_results_dir):
    if file.endswith(".json") or file.endswith(".jason"):
        m+=1

significant_results = []
for file in os.listdir(significant_results_dir):
    if file.endswith(".out"):
        seq_id = file.split('_')[0]
        pval=-1
        with open(significant_results_dir + "/" + file) as f:
            for line in f:
                if ', p-value =  ' in line:
                    pval = float(line.split(' =  ')[1])
                    break
        significant_results.append((seq_id, pval))
significant_results.sort(key=lambda x: x[1])

max_pval = 0
# Benjamini-Hochberg
for i, (seq_id, pval) in enumerate(significant_results):
    if pval < q * (float(i+1) / float(m)):
        max_pval = max(max_pval, pval)

significant_results_bh = []
for i, (seq_id, pval) in enumerate(significant_results):
    if pval <= max_pval:
        significant_results_bh.append((seq_id, pval))

with open(candidate_file, 'w') as f:
    for seq_id, pval in significant_results_bh:
        f.write(seq_id + '\n')

with open(bh_file, 'w') as f:
    for i, (seq_id, pval) in enumerate(significant_results_bh):
        f.write(str(i) + '\t' + seq_id + '\t' + str(pval) + '\n')
