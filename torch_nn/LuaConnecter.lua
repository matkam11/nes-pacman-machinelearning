package.path = "../lib/?.lua;../config/?.lua;" .. package.path

Interface = require('Interface')
Mario = require('Mario')
Config = require('config')
Fileops = require('Fileops')

torch = require "torch"
ffi = require 'ffi'
nn = require "nn"

totalGameState = {}
run = 0
net = torch.load( Interface.path .. 'torch_nn/multilabel.par')
thershold = {
	.59551463,
	.5,
	.5,
	.68,
	.634,
	.4551517,
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

		if no_move > 200 then
			no_move = 0
			break
		end

		if playerStatus == 11 and playerStatus == 4  then
	    	run = run + 1
	    	break
		end
		emu.frameadvance()
		myframe  = myframe  +1
	end
end

