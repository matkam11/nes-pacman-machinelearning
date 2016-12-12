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

criterion = nn.MultiLabelMarginCriterion()
trainer = nn.StochasticGradient(active_nn.net_def, criterion)
trainer.learningRate = 0.0001
trainer.maxIteration = 4 -- just do 5 epochs of training.

-- Load the data
i=3
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
trainset.label=torch.DoubleTensor(#dataset,6)
-- A B UP DOWN LEFT RIGHT
-- 1 1 0   0    0    1   = 4
-- 1 0 0   0    0    1   = 3
-- 0 1 0   0    0    1   = 2
-- 0 0 0   0    0    1   = 1



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
  for j=1,6 do
    trainset.label[i][j]=dataset[i][2][j]
  end

  --print(trainset.data[i][1])
  --print(trainset.label[i])
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
stdv  = {} -- store the standard-deviation for the future
for i=1,1 do -- over each image channel
    mean[i] = trainset.data[{ {}, {i}, {}, {}  }]:mean() -- mean estimation
    print('Channel ' .. i .. ', Mean: ' .. mean[i])
    trainset.data[{ {}, {i}, {}, {}  }]:add(-mean[i]) -- mean subtraction

    stdv[i] = trainset.data[{ {}, {i}, {}, {}  }]:std() -- std estimation
    print('Channel ' .. i .. ', Standard Deviation: ' .. stdv[i])
    trainset.data[{ {}, {i}, {}, {}  }]:div(stdv[i]) -- std scaling
end


for i=1,10 do
  trainer:train(trainset)
  torch.save(active_nn.meta.output_file, active_nn.net_def)
end
