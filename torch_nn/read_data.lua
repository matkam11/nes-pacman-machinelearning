package.path = "../lib/?.lua;../config/?.lua;" .. package.path
torch = require "torch"
ffi = require 'ffi'
nn = require "nn"

Interface = require('Interface')
Fileops = require('Fileops')
NeuralNets = require('NeuralNets')
Config = require('config')

-- ####################################################################
active_nn = NeuralNets.Active

print('Lenet5\n' .. active_nn.net_def:__tostring());
active_nn.net_def:zeroGradParameters() -- zero the internal gradient buffers of the network
-- (will come to this later)

criterion = nn.ClassNLLCriterion()
trainer = nn.StochasticGradient(active_nn.net_def, criterion)
trainer.learningRate = 0.0001
trainer.maxIteration = 5 -- just do 5 epochs of training.

-- Load the data
--for zz=1,10 do
  -- body...
for i=0,3 do
dataPath = Interface.datapath .. "data_"..i..".txt"
labelsPath = Interface.datapath .. "labels_"..i..".txt"
dataset={}
dataset = Fileops.get_data_and_labelsResMATRIX(dataPath,labelsPath,
  active_nn.meta.input_slice)

print(#dataset)
print(#dataset[1][1][1])
print(#dataset[10][2])
trainset={}
trainset.data=torch.DoubleTensor(#dataset,1,13,13)
trainset.label=torch.DoubleTensor(#dataset)



-- A B UP DOWN LEFT RIGHT
-- 1 1 0 0 0 1 = 4
-- 1 0 0 0 0 1 = 3
-- 0 1 0 0 0 1 = 2
-- 0 0 0 0 0 1 = 1
-- else = 5

local function getLabelFromArray(inputData)
  local A={}
  local B={}
  local UP={}
  local DOWN={}
  local LEFT={}
  local RIGHT={}

  A=inputData[2][1]
  B=inputData[2][2]
  UP=inputData[2][3]
  DOWN=inputData[2][4]
  LEFT=inputData[2][5]
  RIGHT=inputData[2][6]
  local label
  if UP==0 and DOWN==0 and LEFT==0 then
    if A~=0 and B~=0 and RIGHT~=0 then
      label = 4
    elseif A~=0 and B~=1 and RIGHT~=0 then
      label = 3
    elseif A~=1 and B~=0 and RIGHT~=0 then
      label = 2
    elseif A~=1 and B~=1 and RIGHT~=0 then
      label = 1
    else
      label = 5
    end
  else
    label = 5
  end
  return label
end

for i=1,#dataset do
  -- DATA
  for j=1,1 do
    for k=1,13 do
      for z=1,13 do
        trainset.data[i][j][k][z]=dataset[i][1][k][z]
      end
    end
  end

  -- LABELS
  trainset.label[i] = getLabelFromArray(dataset[i])

end

-- ignore setmetatable for now, it is a feature beyond the scope of this tutorial. It sets the index operator.
setmetatable(trainset,
  {__index = function(t, i)
      return {t.data[i], t.label[i]}
      end}
  );
  trainset.data = trainset.data:double() -- convert the data from a ByteTensor to a DoubleTensor.

  function trainset:size()
    return self.data:size(1)
  end

  mean = {} -- store the mean, to normalize the test set in the future
  stdv = {} -- store the standard-deviation for the future
  for i=1,1 do -- over each image channel
    mean[i] = trainset.data[{ {}, {i}, {}, {} }]:mean() -- mean estimation
    print('Channel ' .. i .. ', Mean: ' .. mean[i])
    trainset.data[{ {}, {i}, {}, {} }]:add(-mean[i]) -- mean subtraction

    stdv[i] = trainset.data[{ {}, {i}, {}, {} }]:std() -- std estimation
    print('Channel ' .. i .. ', Standard Deviation: ' .. stdv[i])
    trainset.data[{ {}, {i}, {}, {} }]:div(stdv[i]) -- std scaling
  end


    trainer:train(trainset)
    torch.save(active_nn.meta.output_file, active_nn.net_def)
  end
--end
