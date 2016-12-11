--test the code


while (1) do

	--save the data into inputData.txt
	inputDataFile = io.open("/home/matkam11/ML/inputData.txt","a")
	inputDataFile:write("0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ")
	inputDataFile:close();


	--set the flag
	flagSet = io.open("/home/matkam11/ML/flag.txt","a")
	flagSet:write("1")
	flagSet:close();

	--scan the flag till 0 to confirm the complete of matlab

	while (1) do

	flagSet=io.open("/home/matkam11/ML/flag.txt","r");

	string=flagSet:read("*a");

		if (string=="0")
		then
			break
		end

		flagSet:close();
	end

	--load the output result from matlab
	outFile=io.open("/home/matkam11/ML/output.txt","r");
	stringOut=outFile:read("*a");
	print(stringOut);

end







