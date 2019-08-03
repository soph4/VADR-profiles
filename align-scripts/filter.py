

def main():

	file1 = ".selected.txt"
	file2 = ".combined.cmalign"
	file3 = open("cds-start-end.txt")
	cds = file3.readlines()
	file3.close()

	total = []
	for i in range(len(cds)):
		line = cds[i].strip().split()
		name = line[0]
		start = int(line[1])
		end = int(line[2])	

		files = open(name+file2)
		cmalign = files.readlines()
		files.close()
	
		files = open(name+file1)
		selected = files.readlines()
		files.close()
		for j in range(len(selected)):
			selected[j] = selected[j].strip()
	
		add = []

		out = open(name+".good.txt", "w")	
		print(name)
		print("start: ", start, "end: ", end)
		
		for j in range(len(cmalign)):
			x = cmalign[j].strip().split()
			if x[0] in selected:
				if int(x[1])<= start and int(x[2])>= end: 
					out.write(x[0] + "\n")
		out.close()
main()


