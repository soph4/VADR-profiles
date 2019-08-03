# Input:
#	refseq.summary.txt: contains 2 columns (refseq_name, length of refseq)
#
# Output:
#	Seperate files for each refseq 
#       Containing full length sequences that have passed the original VADR model
import sys

def main():

	#file = .sqa.tbl file
	file = open(sys.argv[1])
	lines = file.readlines()
	file.close()

	#file input = refseq.summary.txt
	refseq = open(sys.argv[2])
	refseq_file = refseq.readlines()
	refseq.close()

	#creates dictionary for the refseqs
	#keys: refseq names
	#vales: refseq lengths
	refseq_lengths = {}
	for i in range(len(refseq_file)):
		line = refseq_file[i].strip()
		line = line.split()
		refseq_lengths["NC_" + line[0]] = int(line[1])

	#creates dictionary
	#keys: refseq names
	#values: list of full length sequences that VADR passed 
	refseq_dict = {}
	keys = list(refseq_lengths.keys())
	for i in range(len(keys)):
		refseq_dict[keys[i]] = []

	#NC_009825 = ["MH742362.1", "MH742364.1","KY283130.1", "AB795432.3"]
	#NC_009826 = ["AF064490.1", "MH427311.1","MH427313.1", "MH427312.1"]

	for i in range(3, len(lines)):
		line = lines[i].strip()
		line = line.split()
		name = line[1]
		name = name.split("|")
		name = name[len(name)-2]	
		#print(line)	
		"""if line[5] == "NC_009825" and name not in NC_009825 and int(line[2]) >= 9355 \
		   	and (line[13] == "Low_Similarity_at_Start(lowsim5s),Low_Similarity_at_End(lowsim3s)" \
			or line[13] == "Low_Similarity_at_Start(lowsim5s)" \
			or line[13] == "Low_Similarity_at_End(lowsim3s)"):
			print(name, line[2], line[5])
			refseq_dict[line[5]].append([name, line[2]])

		if line[5] == "NC_009826" and name not in NC_009826 and int(line[2]) >= 9343 \
			and (line[13] == "Low_Similarity_at_Start(lowsim5s),Low_Similarity_at_End(lowsim3s)" \
			or line[13] == "Low_Similarity_at_Start(lowsim5s)" \
			or line[13] == "Low_Similarity_at_End(lowsim3s)"):
			refseq_dict[line[5]].append([name, line[2]])
			print(name, line[2], line[5])

		if line[5] == "NC_009824" and int(line[2]) >= 9456 \
			and (line[13] == "Low_Similarity_at_End(lowsim3s)"):
			refseq_dict[line[5]].append([name, line[2]])
			print(name, line[2], line[5])"""

		if line[3] == "PASS":
			#name = line[1]
			#name = name.split("|")
			#name = name[len(name)-2]
			#if line[5] not in refseq_dict.keys():
			#	if int(line[2]) >= refseq_lengths[line[5]]:
			#		refseq_dict[line[5]] = [[name,line[2]]]
			#else:
			if name[:2] != "NC":
				refseq_dict[line[5]].append([name, line[2]])
	
	#creates the seperate files for each refseq
	keys = list(refseq_lengths.keys())
	
	print(keys)
	for i in range(len(keys)):
		output = open(keys[i] + ".txt", "w")
		#output.write(keys[i] + "\t" + str(val[i]) + "\n")
		values = list(refseq_dict[keys[i]])
		for j in range(len(values)):
			output.write(values[j][0] + "\t" + values[j][1] + "\n")
			#output.write(values[j][0] + "\n")
		output.close()
main()
