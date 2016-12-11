package.path = "../lib/?.lua;../config/?.lua;" .. package.path
torch = require "torch"
ffi = require 'ffi'
nn = require "nn"


Interface = require('Interface')
Fileops = require('Fileops')
Config = require('config')

-- ####################################################################
function getResizedVectorLine(inputTensorLine)
  local reshaped_file_tensor = {}
  local resized_tensor = {}
  local vectorTensor = {}
    reshaped_file_tensor = torch.DoubleTensor(13,13):copy(inputTensorLine)
    --print(reshaped_file_tensor[i][{{6,10},{6,13}}])
    resized_tensor = reshaped_file_tensor[{{6,10},{6,13}}]
    vectorTensorLine=torch.DoubleTensor(40):copy(resized_tensor)
  return vectorTensorLine
end

-- ####################################################################
function getResizedVector(inputTensor)
  local vectorTensor = {}
  for i=1,(#inputTensor)[1] do
    vectorTensor[i]=getResizedVectorLine(inputTensor[i])
  end
  return vectorTensor
end

-- ####################################################################
function get_int_from_bin(line)
  number = tonumber(line:gsub(" " , ""),2)
  return number
end

-- #####################################################################
trainthis = false
if trainthis then

  -- Load the data
  dataPath = Interface.datapath .. "data_1.txt"
  labelsPath = Interface.datapath .. "labels_1.txt"
  dataset={}
  dataset = Fileops.get_data_and_labelsNEW(dataPath,labelsPath)

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
  dataPath = Interface.datapath .. "data_1.txt"
  labelsPath = Interface.datapath .. "labels_1.txt"
  dataset={}
  dataset = Fileops.get_data_and_labelsMULTILABEL(dataPath,labelsPath)

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


  if true then

    mlp = nn.Sequential(); -- make a multi-layer perceptron
    inputs = 169; outputs = 6; HUs = 6; -- parameters
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
    trainer.learningRate = 0.0001
    trainer.maxIteration = 30 -- just do 5 epochs of training.

    -- Load the data
    dataPath = Interface.datapath .. "data_0.txt"
    labelsPath = Interface.datapath .. "labels_0.txt"
    dataset={}
    dataset = Fileops.get_data_and_labelsNEW(dataPath,labelsPath)

    trainer:train(dataset)

    torch.save("multilabel.par", mlp)

  end


  if false then

    mlp = nn.Sequential(); -- make a multi-layer perceptron
    inputs = 40; outputs = 6; HUs = 5; -- parameters
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
    trainer.learningRate = 0.001
    trainer.maxIteration = 5 -- just do 5 epochs of training.

    -- Load the data
    dataPath = Interface.datapath .. "../Data/data_2/data_1.txt"
    labelsPath = Interface.datapath .. "../Data/data_2/labels_1.txt"
    dataset={}
    dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath)

    trainer:train(dataset)

    -- Load the data
    dataPath = Interface.datapath .. "../Data/data_2/data_0.txt"
    labelsPath = Interface.datapath .. "../Data/data_2/labels_0.txt"
    dataset={}
    dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath)

    trainer:train(dataset)

    -- Load the data
    dataPath = Interface.datapath .. "../Data/data_2/data_2.txt"
    labelsPath = Interface.datapath .. "../Data/data_2/labels_2.txt"
    dataset={}
    dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath)

    trainer:train(dataset)

    torch.save("multilabel.par", mlp)

  end
