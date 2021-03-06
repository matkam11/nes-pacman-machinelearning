package.path = "../lib/?.lua;../config/?.lua;" .. package.path

Interface = require('Interface')
Mario = require('Mario')
Fileops = require('Fileops')
Datamanipulation=require("Datamanipulation")
NeuralNetslib = require("NeuralNetslib")
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
bestFitess = 0
bestThreshold = active_nn.meta.threshold[1]
while true do
	Interface.initializeRun(smb_savestate)
	fitness = curr_fitness
	no_move = 0
	myframe = 0
	reset_count = 0
	active_nn.meta.threshold[1] = active_nn.meta.threshold[1] - .00001
	curr_best_fitness = 0
	while true do
		--NeuralNetslib.visualize(active_nn, active_nn.threshold)
		gui.drawtext(1, 100, 'CT: ' .. active_nn.meta.threshold[1], 'white')
		gui.drawtext(1, 108, 'Best: ' .. bestFitess .. '@' .. bestThreshold, 'white')
		print('\n\n')
	    --displayBoard()
		playerStatus = memory.readbyte(0x000E)
		lives = memory.readbyte(0x075A)
		gui.drawtext(1, 116, 'Lives: ' .. lives, 'white')


		--prediction = net:forward(torch.DoubleTensor(displayBoard()['frame']))
		prediction = net:forward(
				Datamanipulation.getResizedVectorLine(
							torch.DoubleTensor(displayBoard()['frame'])
							,active_nn.meta.input_slice
							,active_nn.meta.inputs)
						)
		Interface.press_keys(Interface.key_table_to_table_t_table(prediction,active_nn.meta.threshold))
		old_fitness = fitness
		fitness = Mario.curr_fitness()
		if fitness > curr_best_fitness then
			curr_best_fitness = fitness
		end
		if old_fitness == fitness then
			no_move = no_move + 1
		else
			no_move = 0
			reset_count = 0
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

		if playerStatus == 11 or playerStatus == 4 or lives < 2 then
	    	run = run + 1
	    	break
		end
		emu.frameadvance()
		myframe  = myframe  +1
	end
	if fitness > bestFitess then
		bestFitess = curr_best_fitness
		bestThreshold = active_nn.meta.threshold[1]
	end
end
