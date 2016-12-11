local Fileops = {}
Interface.path  = "/home/matkam11/ML/"
Interface.datapath = Interface.path .. "Data/"
function Fileops.write_current_state(data,filename)
    local file = io.open(Interface.datapath .. filename, "w")
	for i = 1,169 do
		file:write(data["frame"][i] .. " ")
	end
    	file:write("\n")
    file:close()
end

function Fileops.write_full_game(data,filename)
    print(Interface.datapath)
    local file = io.open(Interface.datapath .. "data_" .. filename, "w")
    lenOfData = table.getn(data)
    for f = 1,lenOfData do
    	for i = 1,169 do
    		file:write(data[f]["frame"][i] .. " ")
    	end
    	file:write("\n")
    end
    file:close()

    local file = io.open(Interface.path .. "labels_" .. filename, "w")
    lenOfData = table.getn(data)
    for f = 1,lenOfData do
    	currLabel = data[f]['labels']
    	file:write(tostring(currLabel["P1 A"]) .. " " .. tostring(currLabel["P1 B"]) .. " " .. tostring(currLabel["P1 Down"]) .. " " .. tostring(currLabel["P1 Left"]) .. " " .. tostring(currLabel["P1 Right"]) .. " " .. tostring(currLabel["P1 Up"]))
    	file:write("\n")
    end
    print(currLabel)
    file:close()
end

return Fileops
