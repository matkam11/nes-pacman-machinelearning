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

-- ####################################################################
-- Pre load functions to parse the file

-- ####################################################################
-- this function loads a file line by line to avoid having memory issues
function Fileops.load_file_to_tensor(path)

  local input_table = {}

  local file = io.open(path, 'r') -- open file
  local max_line_size = 0
  local line_number = 1
  for line in file:lines() do
    input_table[line_number] = {}
    for input in line:gmatch("%w+") do
      table.insert(input_table[line_number], input)
    end
    -- increment the number of lines counter
    line_number = line_number +1
  end
  file:close() --close file
  -- intialize tensor for the file
  local file_tensor = torch.IntTensor(input_table)
  return file_tensor
end

-- ####################################################################
-- this function loads a file line by line to avoid having memory issues
function Fileops.load_file_to_tensorNEW(path)
  print(path)
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
  return file_tensor
end

-- ####################################################################
function Fileops.load_file_to_labels(path)

  local input_table = {}
  local file = io.open(path, 'r') -- open file
  for line in file:lines() do
    table.insert(input_table, get_int_from_bin(line))

  end
  file:close() --close file

  -- intialize tensor for the file
  local file_tensor = torch.IntTensor(input_table)
  return input_table
end
-- ####################################################################
-- this function loads a file line by line to avoid having memory issues
function Fileops.load_file_to_tensorMATRIX(path,slice)
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
  return Datamanipulation.getResizedVector(file_tensor,slice)
end

-- ####################################################################
-- this function Fileops.loads a file line by line to avoid having memory issues
function Fileops.load_file_to_tensor_with_type(path,thetype)

  local input_table = {}

  local file = io.open(path, 'r') -- open file
  local max_line_size = 0
  local line_number = 1
  for line in file:lines() do
    input_table[line_number] = {}
    for input in line:gmatch("%w+") do
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
function Fileops.load_file_to_labels_with_type(path,thetype)

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
function Fileops.get_data_and_labels(dataPath,labelsPath)
  mySet = {}
  data=Fileops.load_file_to_tensor(dataPath)
  labels=Fileops.load_file_to_labels(labelsPath)
  mySet.data = data
  mySet.label = labels

  return mySet
end

-- ####################################################################
function Fileops.get_data_and_labelsNEW(dataPath,labelsPath)
  mySet = {}
  local data=Fileops.load_file_to_tensorNEW(dataPath)
  function mySet:size() return (#data)[1] end
  local labels=Fileops.load_file_to_labelsNEW(labelsPath)
  for i=1, mySet:size() do
    mySet[i] = {data[i], labels[i]}
  end
  return mySet
end

-- ####################################################################
function Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,slice)
  mySet = {}
  local data=Fileops.load_file_to_tensorMATRIX(dataPath,slice)
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
  local data=Fileops.load_file_to_tensor_with_type(dataPath,"byte")
  local labels=Fileops.load_file_to_labels_with_type(labelsPath, "byte")
  mySet.data = data
  mySet.label = labels
  return mySet
end

return Fileops
