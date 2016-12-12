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

local inputs = 169
local input_slice = {{1,13},{1,13}}
local outputs = 5
local HUs = 2
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "NN_Nico.par"
NeuralNet_Def.meta.thershold = {
	-- .602960,
--0.71227789100868, 						-- A
  0.80693000000,
  0.50, 	-- B
	2, 	-- UP
	2, -- Down
	2, 							-- left
	-1.4, 								-- right
}

NeuralNet_Def.net_def = nn.Sequential()
-- 1 input image channel, 6 output channels, 5x5 convolution kernel
NeuralNet_Def.net_def:add(nn.SpatialConvolution(1, 6, 3, 3))
NeuralNet_Def.net_def:add(nn.ReLU())                       -- non-linearity
NeuralNet_Def.net_def:add(nn.SpatialMaxPooling(2,2,2,2))
-- reshapes from a 3D tensor of 16x5x5 into 1D tensor of 16*5*5
NeuralNet_Def.net_def:add(nn.SpatialConvolution(6, 16, 2, 2))
NeuralNet_Def.net_def:add(nn.ReLU())                       -- non-linearity
NeuralNet_Def.net_def:add(nn.SpatialMaxPooling(2,2,2,2))
NeuralNet_Def.net_def:add(nn.View(16*2*2))
NeuralNet_Def.net_def:add(nn.Linear(16*2*2, 120))
NeuralNet_Def.net_def:add(nn.ReLU())
NeuralNet_Def.net_def:add(nn.Linear(120, 84))
NeuralNet_Def.net_def:add(nn.ReLU())
NeuralNet_Def.net_def:add(nn.Linear(84, 10))
NeuralNet_Def.net_def:add(nn.ReLU())
NeuralNet_Def.net_def:add(nn.Linear(10, outputs))
NeuralNet_Def.net_def:add(nn.LogSoftMax())

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
NeuralNet_Def.meta.thershold = {
	-- .61701,
	0.738645, 						-- A
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

-- #####################################################################
-- Jumps in the whole
-- Has to reset input number 3 with
--
-- local thres = -3.5560620383429
-- prediction = net:forward(input)
--if prediction[3]>(thres) then
--  print(" INPUT: ".. prediction[3] .. " " ..
--    "\n\tTHERS " .. thres.." T")
--  prediction[3] = 1
--  print("HAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
--else
--  print(" INPUT: ".. prediction[3] .. " " ..
--    "\n\tTHERS " .. thres.." F")
--end
-- #####################################################################
local NeuralNet_Def  = {}
NeuralNet_Def.meta = {}

local inputs = 169
local input_slice = {{1,13},{1,13}}
local outputs = 5
local HUs = 2
NeuralNet_Def.meta.inputs = inputs
NeuralNet_Def.meta.input_slice = input_slice
NeuralNet_Def.meta.outputs = outputs
NeuralNet_Def.meta.output_file = "NN_Nico02.par"
NeuralNet_Def.meta.thershold = {
	-- .602960,
--0.71227789100868, 						-- A
  0.80693000000,
  0.50, 	-- B
	2, 	-- UP
	2, -- Down
	2, 							-- left
	-1.4, 								-- right
}

NeuralNet_Def.net_def = nn.Sequential()
-- 1 input image channel, 6 output channels, 5x5 convolution kernel
NeuralNet_Def.net_def:add(nn.SpatialConvolution(1, 6, 3, 3))
NeuralNet_Def.net_def:add(nn.ReLU())                       -- non-linearity
NeuralNet_Def.net_def:add(nn.SpatialMaxPooling(2,2,2,2))
-- reshapes from a 3D tensor of 16x5x5 into 1D tensor of 16*5*5
NeuralNet_Def.net_def:add(nn.SpatialConvolution(6, 16, 2, 2))
NeuralNet_Def.net_def:add(nn.ReLU())                       -- non-linearity
NeuralNet_Def.net_def:add(nn.SpatialMaxPooling(2,2,2,2))
NeuralNet_Def.net_def:add(nn.View(16*2*2))
NeuralNet_Def.net_def:add(nn.Linear(16*2*2, 120))
NeuralNet_Def.net_def:add(nn.ReLU())
NeuralNet_Def.net_def:add(nn.Linear(120, 84))
NeuralNet_Def.net_def:add(nn.ReLU())
NeuralNet_Def.net_def:add(nn.Linear(84, 10))
NeuralNet_Def.net_def:add(nn.ReLU())
NeuralNet_Def.net_def:add(nn.Linear(10, outputs))
NeuralNet_Def.net_def:add(nn.LogSoftMax())

NeuralNets.Nico2 = NeuralNet_Def

return NeuralNets
