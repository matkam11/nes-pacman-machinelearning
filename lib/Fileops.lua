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

    local file = io.open(Interface.datapath .. "labels_" .. filename, "w")
    lenOfData = table.getn(data)
    for f = 1,lenOfData do
    	currLabel = data[f]['labels']
        local output_value = "0"
        if currLabel[Interface.ButtonNames[1]] then
            output_value = "1"
        end
        file:write(tostring(output_value))
        for button = 2,Interface.Outputs do
            local output_value = "0"
            if currLabel[Interface.ButtonNames[button]] then
                output_value = "1"
            end
        	file:write(" " .. tostring(output_value))
        end
    	file:write("\n")
    end
    print(currLabel)
    file:close()
end

return Fileops
