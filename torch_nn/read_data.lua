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
trainthis = false
if trainthis then

  -- Load the data
  dataPath = "data_1.txt"
  labelsPath = "labels_1.txt"
  dataset={}
  dataset = get_data_and_labelsNEW(dataPath,labelsPath)

  mlp = nn.Sequential(); -- make a multi-layer perceptron
  inputs = 169; outputs = 6; HUs = 45; -- parameters
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

end

trainthis = false
if trainthis then
  dataPath = "data_1.txt"
  labelsPath = "labels_1.txt"
  dataset={}
  dataset = get_data_and_labelsMULTILABEL(dataPath,labelsPath)

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

    for i=1, 2993 do
      dataset.label[i]=dataset.label[i]+1
    end
    net = nn.Sequential()
    net:add(nn.Linear(169, 100))
    net:add(nn.ReLU()) -- non-linearity
    net:add(nn.Linear(100, 64)) -- 10 is the number of outputs of
    net:add(nn.LogSoftMax()) -- converts the output to a
    --log-probability. Useful for classification problems

    print('Lenet5\n' .. net:__tostring());
    net:zeroGradParameters()

    criterion = nn.ClassNLLCriterion()
    trainer = nn.StochasticGradient(net, criterion)
    trainer.learningRate = 0.01
    trainer.maxIteration = 5 -- just do 5 epochs of training.

    trainer:train(dataset)

    torch.save("nnparame.par", net)
  end


  trainthis = true
  if trainthis then
    learning_rate_table = {0.1, 0.01, 0.001, 0.0001, 0.00001}
    j = 1
    for number_of_training_sets = 1,10 do
      for number_of_learning_rate = 1,#learning_rate_table do
        for nubmber_of_iterations = 1,20 do
          mlp = nn.Sequential(); -- make a multi-layer perceptron
          inputs = 169; outputs = 6; HUs = 5; -- parameters
          mlp:add(nn.Linear(inputs, HUs))
          mlp:add(nn.Sigmoid())
          mlp:add(nn.Linear(HUs, HUs))
          mlp:add(nn.Sigmoid())
          mlp:add(nn.Linear(HUs, HUs))
          mlp:add(nn.Sigmoid())
          mlp:add(nn.Linear(HUs, HUs))
          mlp:add(nn.Sigmoid())
          mlp:add(nn.Linear(HUs, outputs))
          mlp:add(nn.Sigmoid())

          print('Lenet5\n' .. mlp:__tostring());
          mlp:zeroGradParameters() -- zero the internal gradient buffers of the network
          -- (will come to this later)

          criterion = nn.MultiLabelMarginCriterion()
          trainer = nn.StochasticGradient(mlp, criterion)


          trainer.learningRate = learning_rate_table[number_of_learning_rate]
          trainer.maxIteration = nubmber_of_iterations -- just do 5 epochs of training.
          for i = 1,number_of_training_sets do
            dataPath = "../Data/data_2/data_" .. i .. ".txt"
            labelsPath = "../Data/data_2/labels_" .. i .. ".txt"
            dataset={}
            dataset = get_data_and_labelsNEW(dataPath,labelsPath)
            trainer:train(dataset)
          end

          torch.save("nn/multilabel " .. j ..".par", mlp)
          j = j +1
        end
      end
    end

    -- mlp = nn.Sequential(); -- make a multi-layer perceptron
    -- inputs = 169; outputs = 6; HUs = 5; -- parameters
    -- mlp:add(nn.Linear(inputs, HUs))
    -- mlp:add(nn.Sigmoid())
    -- mlp:add(nn.Linear(HUs, HUs))
    -- mlp:add(nn.Sigmoid())
    -- mlp:add(nn.Linear(HUs, HUs))
    -- mlp:add(nn.Sigmoid())
    -- mlp:add(nn.Linear(HUs, HUs))
    -- mlp:add(nn.Sigmoid())
    -- mlp:add(nn.Linear(HUs, outputs))
    -- mlp:add(nn.Sigmoid())

    -- print('Lenet5\n' .. mlp:__tostring());
    -- mlp:zeroGradParameters() -- zero the internal gradient buffers of the network
    -- -- (will come to this later)

    -- criterion = nn.MultiLabelMarginCriterion()
    -- trainer = nn.StochasticGradient(mlp, criterion)
    
    -- trainer.learningRate = 0.001
    -- trainer.maxIteration = 5 -- just do 5 epochs of training.

    -- for i = 1,10 do
    --   dataPath = "../Data/data_2/data_" .. i .. ".txt"
    --   labelsPath = "../Data/data_2/labels_" .. i .. ".txt"
    --   dataset={}
    --   dataset = get_data_and_labelsNEW(dataPath,labelsPath)
    --   trainer:train(dataset)
    -- end

    -- torch.save("multilabel.par", mlp)

  end
