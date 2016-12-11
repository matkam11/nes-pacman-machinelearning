Datamanipulation=require("Datamanipulation")

local Fileops = {}
function Fileops.write_current_state(data,filename)
    local file = io.open(Interface.datapath .. filename, "w")
	for i = 1,169 do
		file:write(data["frame"][i] .. " ")
	end
    	file:write("\n")
    file:close()
end

function Fileops.write_full_game(data,filename)
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

-- ####################################################################
-- this function loads a file line by line to avoid having memory issues
function Fileops.load_file_to_tensorMATRIX(path,slice,input_size)
  local input_table = {}
  local file = io.open(path, 'r') -- open file
  local max_line_size = 0
  local line_number = 1
  for line in file:lines() do
    input_table[line_number] = {}

    for input in line:gmatch("-?[0-9]+") do
      table.insert(input_table[line_number], input)
    end
    -- increment the number of lines counter
    line_number = line_number +1
  end
  file:close() --close file
  -- intialize tensor for the file
  local file_tensor = torch.DoubleTensor(input_table)
  return Datamanipulation.getResizedVector(file_tensor,slice,input_size)
end

-- ####################################################################
-- this function Fileops.loads a file line by line to avoid having memory issues
function Fileops.load_file_to_tensorWITHTYPE(path,thetype)

  local input_table = {}

  local file = io.open(path, 'r') -- open file
  local max_line_size = 0
  local line_number = 1
  for line in file:lines() do
    input_table[line_number] = {}
    for input in line:gmatch("-?[0-9]+") do
      table.insert(input_table[line_number], input)
    end
    -- increment the number of lines counter
    line_number = line_number +1
  end
  file:close() --close file
  -- intialize tensor for the file
  local file_tensor = {}
  if thetype == "double" then
    file_tensor = torch.DoubleTensor(input_table)

  elseif thetype == "byte" then
    file_tensor = torch.ByteTensor(input_table)
  elseif thetype == "int" then
    file_tensor = torch.IntTensor(input_table)
  else
    file_tensor = torch.IntTensor(input_table)
  end

  return file_tensor
end

-- ####################################################################
function Fileops.load_file_to_labelsNEW(path)

  local input_table = {}
  local file = io.open(path, 'r') -- open file
  for line in file:lines() do
    local int_table = {}
    line:gsub(".",function(c) table.insert(int_table,tonumber(c)) end)
    for i = 1,#int_table do
      int_table[i] = (int_table[i]*i)
    end
    table.insert(input_table, torch.DoubleTensor(int_table))
  end
  file:close() --close file

  -- intialize tensor for the file
  --local file_tensor = torch.IntTensor(input_table)
  return input_table
end

-- ####################################################################
function Fileops.load_file_to_labels_WITHTYPE(path,thetype)

  local input_table = {}
  local file = io.open(path, 'r') -- open file
  for line in file:lines() do
    table.insert(input_table, get_int_from_bin(line))

  end
  file:close() --close file

  -- intialize tensor for the file

  local file_tensor = {}
  if thetype == "double" then
    file_tensor = torch.DoubleTensor(input_table)

  elseif thetype == "byte" then
    file_tensor = torch.ByteTensor(input_table)
  elseif thetype == "int" then
    file_tensor = torch.IntTensor(input_table)
  else
    file_tensor = torch.IntTensor(input_table)
  end

  return file_tensor
end

-- ####################################################################
function Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,slice,input_size)
  mySet = {}
  local data=Fileops.load_file_to_tensorMATRIX(dataPath,slice,input_size)
  function mySet:size() return (#data) end
  local labels=Fileops.load_file_to_labelsNEW(labelsPath)
  for i=1, mySet:size() do
    mySet[i] = {data[i], labels[i]}
  end
  return mySet
end

-- ####################################################################
function Fileops.get_data_and_labelsMULTILABEL(dataPath,labelsPath)
  mySet = {}
  local data=Fileops.load_file_to_tensorWITHTYPE(dataPath,"byte")
  local labels=Fileops.load_file_to_labels_WITHTYPE(labelsPath, "byte")
  mySet.data = data
  mySet.label = labels
  return mySet
end

return Fileops
