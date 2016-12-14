local NeuralNets = {}

-- #####################################################################
-- Insert Commentary here
-- #####################################################################
local NeuralNet_Def  = {}
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
	0.5,	-- A
	0.5, 		-- B
	0.5, 		-- UP
	0.5, 		-- Down
	0.5, 		-- left
	0.5, 		-- right
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
local NeuralNet_Def  = {}
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
-- 	0.5,	-- A
-- 	0.5, 		-- B
-- 	0.5, 		-- UP
-- 	0.5, 		-- Down
-- 	0.5, 		-- left
-- 	0.5, 		-- right
-- 	}


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
--   dataPath = Interface.datapath .. "data_"..i..".txt"
--   labelsPath = Interface.datapath .. "labels_"..i..".txt"
--   dataset={}
--   dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
--   trainer:train(dataset)
-- end
-- end

-- trainer.learningRate = 0.00001
-- trainer.maxIteration = 2 -- just do 5 epochs of training.


-- criterion = nn.MSECriterion()
-- -- Load the data
-- for i = 1,2 do
-- for i = 1, 64 do
--   dataPath = Interface.datapath .. "data_"..i..".txt"
--   labelsPath = Interface.datapath .. "labels_"..i..".txt"
--   dataset={}
--   dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
-- --   trainer:train(dataset)
-- end
-- #####################################################################
local NeuralNet_Def  = {}
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
	0.054,	-- A
	2, 		-- B
	0, 		-- UP
	1, 		-- Down
	2.37, 		-- left
	0, 		-- right
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
-- criterion = nn.MSECriterion()
-- trainer = nn.StochasticGradient(active_nn.net_def, criterion)
-- trainer.learningRate = 0.0001
-- trainer.maxIteration = 3 -- just do 5 epochs of training.

-- -- Load the data
-- for i = 1,2 do
-- for i = 1, 25 do
--   dataPath = Interface.datapath .. "data_"..i..".txt"
--   labelsPath = Interface.datapath .. "labels_"..i..".txt"
--   dataset={}
--   dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
--   trainer:train(dataset)
-- end
-- end
-- #####################################################################

local NeuralNet_Def  = {}
NeuralNet_Def.meta = {}

local inputs = 169
local input_slice = {{1,13},{1,13}}
local outputs = 6
local HUs = 2 
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "NN_Fourth.par"
NeuralNet_Def.meta.threshold = {
	0.02,	-- A
	2, 		-- B
	0, 		-- UP
	1, 		-- Down
	2.37, 		-- left
	0, 		-- right
	}


NeuralNet_Def.net_def = nn.Sequential()
NeuralNet_Def.net_def:add(nn.MulConstant(3))
NeuralNet_Def.net_def:add(nn.Linear(inputs, 50))
NeuralNet_Def.net_def:add(nn.Linear(50, 40))
NeuralNet_Def.net_def:add(nn.Linear(40, 30))
NeuralNet_Def.net_def:add(nn.Linear(30, 20))
NeuralNet_Def.net_def:add(nn.Linear(20, 10))
NeuralNet_Def.net_def:add(nn.Linear(10, 6))
--NeuralNet_Def.net_def:add(nn.Sigmoid())
--NeuralNet_Def.net_def:add(nn.Sigmoid())

NeuralNets.Fourth = NeuralNet_Def


-- #####################################################################
-- criterion = nn.MSECriterion()
-- trainer = nn.StochasticGradient(active_nn.net_def, criterion)
-- trainer.learningRate = 0.0001
-- trainer.maxIteration = 2 -- just do 5 epochs of training.

-- -- Load the data
-- for j = 1,1 do
-- for i = 1, 117 do
--   print(i .. " " .. j)
--   dataPath = Interface.datapath .. "data_"..i..".txt"
--   labelsPath = Interface.datapath .. "labels_"..i..".txt"
--   dataset={}
--   dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
--   trainer:train(dataset)
-- end
-- for i = 201, 209 do
--   print(i .. " " .. j)
--   dataPath = Interface.datapath .. "data_"..i..".txt"
--   labelsPath = Interface.datapath .. "labels_"..i..".txt"
--   dataset={}
--   dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
--   trainer:train(dataset)
-- end
-- end
-- #####################################################################

local NeuralNet_Def  = {}
NeuralNet_Def.meta = {}

local inputs = 169
local input_slice = {{1,13},{1,13}}
local outputs = 6
local HUs = 2 
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "NN_Five.par"
NeuralNet_Def.meta.threshold = {
	0.196, --0.05279, --0.0509,	-- A
	2, 		-- B
	0, 		-- UP
	1, 		-- Down
	2.37, 		-- left
	-10, 		-- right
	}


NeuralNet_Def.net_def = nn.Sequential()
--NeuralNet_Def.net_def:add(nn.MulConstant(3))
NeuralNet_Def.net_def:add(nn.Linear(inputs, 5))
NeuralNet_Def.net_def:add(nn.Linear(5, 5))
NeuralNet_Def.net_def:add(nn.Linear(5, 5))
NeuralNet_Def.net_def:add(nn.Linear(5, 5))
NeuralNet_Def.net_def:add(nn.Linear(5, 6))
--NeuralNet_Def.net_def:add(nn.Sigmoid())
--NeuralNet_Def.net_def:add(nn.Sigmoid())

NeuralNets.Five = NeuralNet_Def

-- #####################################################################
-- criterion = nn.MSECriterion()
-- trainer = nn.StochasticGradient(active_nn.net_def, criterion)
-- trainer.learningRate = 0.0001
-- trainer.maxIteration = 3 -- just do 5 epochs of training.

-- -- Load the data
-- for i = 1,2 do
-- for i = 1, 25 do
--   dataPath = Interface.datapath .. "data_"..i..".txt"
--   labelsPath = Interface.datapath .. "labels_"..i..".txt"
--   dataset={}
--   dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath,active_nn.meta.input_slice, active_nn.meta.inputs)
--   trainer:train(dataset)
-- end
-- end
-- #####################################################################

local NeuralNet_Def  = {}
NeuralNet_Def.meta = {}

local inputs = 169
local input_slice = {{1,13},{1,13}}
local outputs = 6
local HUs = 2 
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "NN_Six.par"
NeuralNet_Def.meta.threshold = {
	0.081,	-- A
	0.572, 		-- B
	0, 		-- UP
	1, 		-- Down
	2.37, 		-- left
	.98, 		-- right
	}


NeuralNet_Def.net_def = nn.Sequential()
--NeuralNet_Def.net_def:add(nn.MulConstant(3))
NeuralNet_Def.net_def:add(nn.Linear(inputs, 5))
NeuralNet_Def.net_def:add(nn.Linear(5, 5))
--NeuralNet_Def.net_def:add(nn.Sigmoid())
NeuralNet_Def.net_def:add(nn.Linear(5, 5))
NeuralNet_Def.net_def:add(nn.Linear(5, 5))
--NeuralNet_Def.net_def:add(nn.Sigmoid())
NeuralNet_Def.net_def:add(nn.Linear(5, 6))
--NeuralNet_Def.net_def:add(nn.Sigmoid())

NeuralNets.Six = NeuralNet_Def


return NeuralNets