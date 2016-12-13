local NeuralNets = {}

-- #####################################################################
-- Insert Commentary here
-- #####################################################################
local NeuralNet_Def = {}
NeuralNet_Def.meta = {}

local inputs = 169
local input_slice = {{1,13},{1,13}}
local outputs = 6
local HUs = 2
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "NN_first.par"
NeuralNet_Def.meta.threshold = {
  0.5, -- A
  0.5, -- B
  0.5, -- UP
  0.5, -- Down
  0.5, -- left
  0.5, -- right
}
NeuralNet_Def.meta.buttonNames = {
  "A",
  "B",
  "up",
  "down",
  "left",
  "right",
}

NeuralNet_Def.net_def = nn.Sequential()
NeuralNet_Def.net_def:add(nn.Linear(inputs, outputs))
NeuralNet_Def.net_def:add(nn.MulConstant(0.04))
NeuralNet_Def.net_def:add(nn.Sigmoid())

-- NeuralNet_Def.net_def:add(nn.Linear(HUs, HUs))
-- NeuralNet_Def.net_def:add(nn.Sigmoid())
-- NeuralNet_Def.net_def:add(nn.Linear(HUs, HUs))
-- NeuralNet_Def.net_def:add(nn.Sigmoid())
-- NeuralNet_Def.net_def:add(nn.Linear(HUs, HUs))
-- NeuralNet_Def.net_def:add(nn.Sigmoid())
-- NeuralNet_Def.net_def:add(nn.Linear(HUs, outputs))
-- NeuralNet_Def.net_def:add(nn.Sigmoid())

NeuralNets.First = NeuralNet_Def

-- #####################################################################
-- Insert Commentary here
-- #####################################################################
local NeuralNet_Def = {}
NeuralNet_Def.meta = {}

local inputs = 169
local input_slice = {{1,13},{1,13}}
local outputs = 6
local HUs = 2
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "Multilabel.par"
-- NeuralNet_Def.meta.threshold = {
-- 0.5, -- A
-- 0.5, -- B
-- 0.5, -- UP
-- 0.5, -- Down
-- 0.5, -- left
-- 0.5, -- right
-- }
NeuralNet_Def.meta.buttonNames = {
  "A",
  "B",
  "up",
  "down",
  "left",
  "right",
}

NeuralNet_Def.net_def = nn.Sequential()
NeuralNet_Def.net_def:add(nn.Linear(169, 100))
NeuralNet_Def.net_def:add(nn.ReLU()) -- non-linearity
NeuralNet_Def.net_def:add(nn.Linear(100, 64)) -- 10 is the number of outputs of
NeuralNet_Def.net_def:add(nn.LogSoftMax())

NeuralNets.Multilabel = NeuralNet_Def

-- #####################################################################
-- criterion = nn.MSECriterion()
-- trainer = nn.StochasticGradient(active_nn.net_def, criterion)
-- trainer.learningRate = 0.0001
-- trainer.maxIteration = 3 -- just do 5 epochs of training.

-- -- Load the data
-- for i = 1,2 do
-- for i = 1, 25 do
-- dataPath = Interface.datapath .. "data_"..i..".txt"
-- labelsPath = Interface.datapath .. "labels_"..i..".txt"
-- dataset={}
-- dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
-- trainer:train(dataset)
-- end
-- end

-- trainer.learningRate = 0.00001
-- trainer.maxIteration = 2 -- just do 5 epochs of training.

-- criterion = nn.MSECriterion()
-- -- Load the data
-- for i = 1,2 do
-- for i = 1, 64 do
-- dataPath = Interface.datapath .. "data_"..i..".txt"
-- labelsPath = Interface.datapath .. "labels_"..i..".txt"
-- dataset={}
-- dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
-- -- trainer:train(dataset)
-- end
-- #####################################################################
local NeuralNet_Def = {}
NeuralNet_Def.meta = {}

local inputs = 169
local input_slice = {{1,13},{1,13}}
local outputs = 6
local HUs = 2
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "NN_Third.par"
NeuralNet_Def.meta.threshold = {
  0.054, -- A
  2, -- B
  0, -- UP
  1, -- Down
  2.37, -- left
  0, -- right
}
NeuralNet_Def.meta.buttonNames = {
  "A",
  "B",
  "up",
  "down",
  "left",
  "right",
}

NeuralNet_Def.net_def = nn.Sequential()
NeuralNet_Def.net_def:add(nn.MulConstant(3))
NeuralNet_Def.net_def:add(nn.Linear(inputs, 40))
NeuralNet_Def.net_def:add(nn.Linear(40, 30))
NeuralNet_Def.net_def:add(nn.Linear(30, 20))
NeuralNet_Def.net_def:add(nn.Linear(20, 10))
NeuralNet_Def.net_def:add(nn.Linear(10, 6))
--NeuralNet_Def.net_def:add(nn.Sigmoid())
--NeuralNet_Def.net_def:add(nn.Sigmoid())
NeuralNets.Third = NeuralNet_Def
-- #####################################################################
-- criterion = nn.MSECriterion()
-- trainer = nn.StochasticGradient(active_nn.net_def, criterion)
-- trainer.learningRate = 0.0001
-- trainer.maxIteration = 3 -- just do 5 epochs of training.

-- -- Load the data
-- for i = 1,2 do
-- for i = 1, 25 do
-- dataPath = Interface.datapath .. "data_"..i..".txt"
-- labelsPath = Interface.datapath .. "labels_"..i..".txt"
-- dataset={}
-- dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
-- trainer:train(dataset)
-- end
-- end
-- #####################################################################
local NeuralNet_Def = {}
NeuralNet_Def.meta = {}

local inputs = 169
local input_slice = {{1,13},{1,13}}
local outputs = 6
local HUs = 2
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "NN_Third.par"
NeuralNet_Def.meta.threshold = {
  0.055, -- A
  2, -- B
  0, -- UP
  1, -- Down
  2.37, -- left
  0, -- right
}
NeuralNet_Def.meta.buttonNames = {
  "A",
  "B",
  "up",
  "down",
  "left",
  "right",
}

NeuralNet_Def.net_def = nn.Sequential()
NeuralNet_Def.net_def:add(nn.MulConstant(3))
NeuralNet_Def.net_def:add(nn.Linear(inputs, 40))
NeuralNet_Def.net_def:add(nn.Linear(40, 30))
NeuralNet_Def.net_def:add(nn.Linear(30, 20))
NeuralNet_Def.net_def:add(nn.Linear(20, 10))
NeuralNet_Def.net_def:add(nn.Linear(10, 6))
--NeuralNet_Def.net_def:add(nn.Sigmoid())
--NeuralNet_Def.net_def:add(nn.Sigmoid())

NeuralNets.Second = NeuralNet_Def

-- #####################################################################
-- end
-- #####################################################################
local NeuralNet_Def = {}
NeuralNet_Def.meta = {}

local inputs = 169
local input_slice = {{1,13},{1,13}}
local outputs = 6
local HUs = 2
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "NN_Nico.par"
NeuralNet_Def.meta.threshold = {
  1.09, -- A
  2, -- B
  0, -- UP
  1, -- Down
  2.37, -- left
  -1, -- right
}
NeuralNet_Def.meta.buttonNames = {
  "A",
  "B",
  "up",
  "down",
  "left",
  "right",
}

NeuralNet_Def.net_def = nn.Sequential()
--NeuralNet_Def.net_def:add(nn.MulConstant(3))
NeuralNet_Def.net_def:add(nn.Linear(inputs, 40))
NeuralNet_Def.net_def:add(nn.Linear(40, 30))
NeuralNet_Def.net_def:add(nn.Linear(30, 20))
NeuralNet_Def.net_def:add(nn.Linear(20, 10))
NeuralNet_Def.net_def:add(nn.Linear(10, outputs))
--NeuralNet_Def.net_def:add(nn.Sigmoid())
--NeuralNet_Def.net_def:add(nn.Sigmoid())

NeuralNets.Nico = NeuralNet_Def

-- #####################################################################
-- criterion = nn.MSECriterion()
-- trainer = nn.StochasticGradient(active_nn.net_def, criterion)
-- trainer.learningRate = 0.0001
-- trainer.maxIteration = 3 -- just do 5 epochs of training.

-- -- Load the data
-- for i = 1,2 do
-- for i = 1, 25 do
-- dataPath = Interface.datapath .. "data_"..i..".txt"
-- labelsPath = Interface.datapath .. "labels_"..i..".txt"
-- dataset={}
-- dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
-- trainer:train(dataset)
-- end
-- end

-- trainer.learningRate = 0.00001
-- trainer.maxIteration = 2 -- just do 5 epochs of training.

-- criterion = nn.MSECriterion()
-- -- Load the data
-- for i = 1,2 do
-- for i = 1, 64 do
-- dataPath = Interface.datapath .. "data_"..i..".txt"
-- labelsPath = Interface.datapath .. "labels_"..i..".txt"
-- dataset={}
-- dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
-- -- trainer:train(dataset)
-- end
-- #####################################################################
local NeuralNet_Def = {}
NeuralNet_Def.meta = {}

local inputs = 169
local input_slice = {{1,13},{1,13}}
local outputs = 3
local HUs = 2
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "NN_Nico.par"
NeuralNet_Def.meta.threshold = {
  0.06967, -- A
  2, -- B
  0 -- right
}
NeuralNet_Def.meta.buttonNames = {
  "A",
  "B",
  "right"
}

NeuralNet_Def.net_def = nn.Sequential()
NeuralNet_Def.net_def:add(nn.MulConstant(3))
NeuralNet_Def.net_def:add(nn.Linear(inputs, 40))
NeuralNet_Def.net_def:add(nn.Linear(40, 30))
NeuralNet_Def.net_def:add(nn.Linear(30, 20))
NeuralNet_Def.net_def:add(nn.Linear(20, 10))
NeuralNet_Def.net_def:add(nn.Linear(10, outputs))
--NeuralNet_Def.net_def:add(nn.Sigmoid())
--NeuralNet_Def.net_def:add(nn.Sigmoid())

NeuralNets.ThreeButtons = NeuralNet_Def

return NeuralNets
