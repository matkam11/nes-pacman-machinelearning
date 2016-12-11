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

return NeuralNets