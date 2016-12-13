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

--criterion = nn.MSECriterion()
criterion = nn.MultiLabelMarginCriterion()
trainer = nn.StochasticGradient(active_nn.net_def, criterion)
trainer.learningRate = 0.0001
trainer.maxIteration = 2 -- just do 5 epochs of training.

-- Load the data
for j = 1,1 do
for i = 1, 139 do
  print(i .. " " .. j)
  dataPath = Interface.datapath .. "data_"..i..".txt"
  labelsPath = Interface.datapath .. "labels_"..i..".txt"
  dataset={}
  dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
  trainer:train(dataset)
end
for i = 201, 209 do
  print(i .. " " .. j)
  dataPath = Interface.datapath .. "data_"..i..".txt"
  labelsPath = Interface.datapath .. "labels_"..i..".txt"
  dataset={}
  dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
  trainer:train(dataset)
end
end

torch.save(active_nn.meta.output_file, active_nn.net_def)
