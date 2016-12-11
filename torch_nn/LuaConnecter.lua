package.path = "../lib/?.lua;../config/?.lua;" .. package.path

Interface = require('Interface')
Mario = require('Mario')
Fileops = require('Fileops')
Datamanipulation=require("Datamanipulation")

torch = require "torch"
ffi = require 'ffi'
nn = require "nn"

NeuralNets = require("NeuralNets")
Config = require("config")
active_nn = NeuralNets.Active
net = torch.load( Interface.path .. 'torch_nn/' .. active_nn.meta.output_file)


smb_savestate = savestate.create(1)
getInputs = Mario.getInputs
displayBoard = Interface.displayBoard
totalGameState = {}
run = 0
Interface.initializeRun(smb_savestate)
while true do
	Interface.initializeRun(smb_savestate)
	fitness = curr_fitness
	no_move = 0
	myframe = 0
	reset_count = 0
	while true do
		print('\n\n')
	    displayBoard()
		playerStatus = memory.readbyte(0x000E)
		--prediction = net:forward(torch.DoubleTensor(displayBoard()['frame']))
		prediction = net:forward(
				Datamanipulation.getResizedVectorLine(
							torch.DoubleTensor(displayBoard()['frame'])
							,active_nn.meta.input_slice
							,active_nn.meta.inputs)
						)
		Interface.press_keys(Interface.key_table_to_table_t_table(prediction,active_nn.meta.thershold))
		old_fitness = fitness
		fitness = Mario.curr_fitness()
		if old_fitness == fitness then
			no_move = no_move + 1
		end

		if no_move > 100 then

			Interface.clearJoypad()
			no_move=0
			reset_count = reset_count+1
			if reset_count >3 then
				no_move = 0
				reset_count = 0
				break
			end
		end

		if playerStatus == 11 and playerStatus == 4  then
	    	run = run + 1
	    	break
		end
		emu.frameadvance()
		myframe  = myframe  +1
	end
end
