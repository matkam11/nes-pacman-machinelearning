package.path = "../lib/?.lua;../config/?.lua;" .. package.path

Interface = require('Interface')
Mario = require('Mario')
Config = require('config')
Fileops = require('Fileops')

torch = require "torch"
ffi = require 'ffi'
nn = require "nn"


net = torch.load( Interface.path .. 'torch_nn/multilabel.par')
thershold = {
	-- .61701,
	0.60580, 						-- A
	-0.18808802089208, 	-- B
	-0.25735338572036, 	-- UP
	-0.046505756755972, -- Down
	0.50851015217468, 							-- left
	-10, 								-- right
}

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
		prediction = net:forward(torch.DoubleTensor(displayBoard()['frame']))
		Interface.press_keys(Interface.key_table_to_table_t_table(prediction,thershold))
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
