package.path = "../lib/?.lua;../config/?.lua;" .. package.path
torch = require "torch"
ffi = require 'ffi'
nn = require "nn"


Interface = require('Interface')
Fileops = require('Fileops')
Config = require('config')
NeuralNets = require('NeuralNets')

-- ####################################################################
active_nn = NeuralNets.First

print('Lenet5\n' .. active_nn.net_def:__tostring());
active_nn.net_def:zeroGradParameters() -- zero the internal gradient buffers of the network
-- (will come to this later)

criterion = nn.MultiLabelMarginCriterion()
trainer = nn.StochasticGradient(active_nn.net_def, criterion)
trainer.learningRate = 0.0001
trainer.maxIteration = 2 -- just do 5 epochs of training.

-- Load the data
for i = 0, 1 do
  dataPath = Interface.datapath .. "data_"..i..".txt"
  labelsPath = Interface.datapath .. "labels_"..i..".txt"
  dataset={}
  dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
  trainer:train(dataset)
end
torch.save(active_nn.meta.output_file, active_nn.net_def)
