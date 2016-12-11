torch = require "torch"
ffi = require 'ffi'
nn = require "nn"


-- ####################################################################
function get_int_from_bin(line)
     number = tonumber(line:gsub(" " , ""),2)
    return number
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


-- ----------------------------------------------------------------
-- Load NN objsect
net = torch.load('nnparame.par')

--load data
-- Load the data
dataPath = "data_1.txt"
labelsPath = "labels_1.txt"
dataset={}
dataset = get_data_and_labelsMULTILABEL(dataPath,labelsPath)
-- note that for furthur training we must add 1 to the labels to conform with
-- the net that has been trainned already
setmetatable(dataset,
				{__index = function(t, i)
				return {t.data[i], t.label[i]}
				end}
			);
		dataset.data = dataset.data:double() -- convert the data from a ByteTensor to
		-- a DoubleTensor.

function dataset:size()
    return self.data:size(1)
end


class_performance = {
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0}
for i=1,dataset:size()  do
    local groundtruth = dataset.label[i]
    local prediction = net:forward(dataset.data[i])
    local confidences, indices = torch.sort(prediction, true)  -- true means sort in descending order
    if groundtruth == indices[1] then
        class_performance[groundtruth] = class_performance[groundtruth] + 1
    end
end

for i=1, 64 do
    print(i, class_performance[i] .. ' %')
end
