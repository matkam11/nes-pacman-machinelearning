
torch = require "torch"
ffi = require 'ffi'
nn = require "nn"

-- ####################################################################
-- Pre load functions to parse the file

-- ####################################################################
-- this function loads a file line by line to avoid having memory issues
function load_file_to_tensor(path)

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
function load_file_to_tensorNEW(path)

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
  local file_tensor = torch.DoubleTensor(input_table)
  return file_tensor
end

-- ####################################################################
-- this function loads a file line by line to avoid having memory issues
function load_file_to_tensor_with_type(path,thetype)

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
function load_file_to_labelsNEW(path)

  local input_table = {}
  local file = io.open(path, 'r') -- open file
  for line in file:lines() do
    --table.insert(input_table, tonumber(line:gsub(" " , ""),2))
    local int_table = {}
    table.insert(int_table, get_int_from_bin(line))
    --table.insert(input_table, torch.DoubleTensor(line:gmatch("%S")))
    input_table[number_of_lines] = tonumber(line:gsub(" " , ""),2)
    --for input in line:gmatch("%w+") do table.insert(input_table[number_of_lines], input) end

  end
  file:close() --close file
    
  -- intialize tensor for the file
  --local file_tensor = torch.IntTensor(input_table)
  return input_table
end

-- ####################################################################
function load_file_to_labels_with_type(path,thetype)

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
function get_int_from_bin(line)
     number = tonumber(line:gsub(" " , ""),2)
    return number
end
-- ####################################################################
function load_file_to_labels(path)

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
function get_data_and_labels(dataPath,labelsPath)
    mySet = {}
    data=load_file_to_tensor(dataPath)
    labels=load_file_to_labels(labelsPath)
    mySet.data = data
    mySet.label = labels
    
    return mySet
end

-- ####################################################################
function get_data_and_labelsNEW(dataPath,labelsPath)
    mySet = {}
    local data=load_file_to_tensorNEW(dataPath)
    function mySet:size() return (#data)[1] end
    local labels=load_file_to_labelsNEW(labelsPath)
    for i=1, mySet:size() do
        mySet[i] = {data[i], labels[i]}
    end
    return mySet
end

-- ####################################################################
function get_data_and_labelsMULTILABEL(dataPath,labelsPath)
    mySet = {}
    local data=load_file_to_tensor_with_type(dataPath,"byte")
    local labels=load_file_to_labels_with_type(labelsPath, "byte")
    mySet.data = data
    mySet.label = labels
    return mySet
end



-- #####################################################################
-- Load the data
dataPath = "data_1.txt"
labelsPath = "labels_1.txt"
dataset={}
dataset = get_data_and_labelsNEW(dataPath,labelsPath)

mlp = nn.Sequential();  -- make a multi-layer perceptron
inputs = 169; outputs = 1; HUs = 45; -- parameters
mlp:add(nn.Linear(inputs, HUs))
mlp:add(nn.Tanh())
mlp:add(nn.Linear(HUs, outputs))

print('Lenet5\n' .. mlp:__tostring());
mlp:zeroGradParameters() -- zero the internal gradient buffers of the network
-- (will come to this later)

criterion = nn.MSECriterion()
trainer = nn.StochasticGradient(mlp, criterion)
trainer.learningRate = 0.01
trainer.maxIteration = 10 -- just do 5 epochs of training.
trainer:train(dataset)



