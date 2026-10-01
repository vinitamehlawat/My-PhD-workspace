import pandas as pd
import sys
import os

directory = sys.argv[1]
outname = sys.argv[2]

out = pd.DataFrame(columns=["annot_species_id", "reference_species_protein_id", "gene_name", "product", "blast_eval", "blast_iden"])


#this code is extremely fragile and only works if the files are named in a very specific way and none are missing
current_line = 0
file_list = []
stop_loop = False
current_line = 0
while stop_loop == False:
    stop_loop = True
    for filename in os.listdir(directory):
        if filename.endswith(".tsv"):
            start_line = int(filename.split("_")[1])
            end_line = int(filename.split("_")[2].split(".")[0])
            if start_line == current_line:
                file_list.append(filename)
                current_line = end_line
                stop_loop = False

for filename in file_list:
    df = pd.read_csv(directory + "/" + filename, sep="\t")
    out = out.append(df, ignore_index=True)

out.to_csv(outname, sep="\t", index=False)
