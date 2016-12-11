local NeuralNets = {}

-- #####################################################################
-- Insert Commentary here
-- #####################################################################
local NeuralNet_Def  = {}
NeuralNet_Def.meta = {}

local inputs = 20
local input_slice = {{6,10},{7,10}}
local outputs = 6
local HUs = 2
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "NN_first.par"
NeuralNet_Def.meta.threshold = {
	0.424974,	-- A
	0.67, 		-- B
	0.50, 		-- UP
	0.5, 		-- Down
	0.70, 		-- left
	-1, 		-- right
	}


NeuralNet_Def.net_def = nn.Sequential()
NeuralNet_Def.net_def:add(nn.Linear(inputs, HUs))
NeuralNet_Def.net_def:add(nn.Sigmoid())
NeuralNet_Def.net_def:add(nn.Linear(HUs, HUs))
NeuralNet_Def.net_def:add(nn.Sigmoid())
NeuralNet_Def.net_def:add(nn.Linear(HUs, HUs))
NeuralNet_Def.net_def:add(nn.Sigmoid())
NeuralNet_Def.net_def:add(nn.Linear(HUs, HUs))
NeuralNet_Def.net_def:add(nn.Sigmoid())
NeuralNet_Def.net_def:add(nn.Linear(HUs, outputs))
NeuralNet_Def.net_def:add(nn.Sigmoid())

NeuralNets.First = NeuralNet_Def


-- #####################################################################
-- Insert Commentary here
-- #####################################################################
local NeuralNet_Def  = {}
NeuralNet_Def.meta = {}

local inputs = 20
local input_slice = {{6,10},{7,10}}
local outputs = 6
local HUs = 2
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "NN_Nico.par"
NeuralNet_Def.meta.threshold = {
	-- .61701,
	0.7506584, 						-- A
	0.67, 	-- B
	0.50, 	-- UP
	0.5, -- Down
	0.70, 							-- left
	-1, 								-- right
}

NeuralNet_Def.net_def = nn.Sequential()
NeuralNet_Def.net_def:add(nn.Linear(inputs, 25))
NeuralNet_Def.net_def:add(nn.Sigmoid())
NeuralNet_Def.net_def:add(nn.Linear(25, 25))
NeuralNet_Def.net_def:add(nn.Sigmoid())
NeuralNet_Def.net_def:add(nn.Linear(25, 10))
NeuralNet_Def.net_def:add(nn.Sigmoid())
NeuralNet_Def.net_def:add(nn.Linear(10, outputs))
NeuralNet_Def.net_def:add(nn.Sigmoid())

NeuralNets.Nico = NeuralNet_Def

-- #####################################################################
-- Reaches second pipe with the reset trick
-- #####################################################################
local NeuralNet_Def  = {}
NeuralNet_Def.meta = {}

local inputs = 20
local input_slice = {{6,10},{7,10}}
local outputs = 6
local HUs = 2
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "NN_Nico.par"
NeuralNet_Def.meta.threshold = {
	-- .61701,
	0.7506584, 						-- A
	0.67, 	-- B
	0.50, 	-- UP
	0.5, -- Down
	0.70, 							-- left
	-1, 								-- right
}

NeuralNet_Def.net_def = nn.Sequential()
NeuralNet_Def.net_def:add(nn.Linear(inputs, 25))
NeuralNet_Def.net_def:add(nn.Sigmoid())
NeuralNet_Def.net_def:add(nn.Linear(25, 25))
NeuralNet_Def.net_def:add(nn.Sigmoid())
NeuralNet_Def.net_def:add(nn.Linear(25, 10))
NeuralNet_Def.net_def:add(nn.Sigmoid())
NeuralNet_Def.net_def:add(nn.Linear(10, outputs))
NeuralNet_Def.net_def:add(nn.Sigmoid())

NeuralNets.Nico01 = NeuralNet_Def

return NeuralNets
