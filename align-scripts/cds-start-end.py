
#Input:	all the refseqs .minfo files 		
#Output: cds-start-end.txt file 
#	 specifies where the refseq starts and ends

#for now the script works if there are only 2 CDS found in refseq
#which is not necessarily true for other refseqs (should fix later)
import sys

def main():
	#opens the concatenated ,minfo file for all refseqs
	file = open(sys.argv[1])
	lines = file.readlines()
	file.close()

	#keeps track of the start and end coordinates
	num = 0
	start = 0
	end = 0	

	out = open("cds-start-end.txt", "w")
	name = ""
	#loops through the .minfo file
	
	for i in range(0,len(lines)):
		line = lines[i].strip().split()
		#when a CDS line if found
		if "MODEL" in line[0] and i == 0:
			name = line[1]		
		if "MODEL" in line[0] and i!= 0:
			out.write(name + "\t" + str(start) + "\t" + str(end) + "\n")
			start = 0
			end = 0
			num = 0
		if "CDS" in line[2]:
			coords = line[3]
			output = coords.split(":")
			x = output[1].split(".")
			#when first CDS is found
			if num == 0:
				start = int(x[0][1:])
				end = int(x[2])
				num +=1
				name = line[1]
			else:
				y = output[2].split(".")
				if int(y[2]) > end:
					end = int(y[2])
				if int(y[0][2:]) < start:
					start = int(y[0][2:])
				if int(x[0][1:]) > end:
					end = int(x[0][1:])
				if int(x[2]) < start:
					start = int(x[2])
				name = line[1]
			
	name = line[1]
	out.write(name + "\t" + str(start) + "\t" + str(end) + "\n")

main()
