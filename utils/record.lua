package.path = "../lib/?.lua;" .. package.path

Mario = require('Mario')
Interface = require('Interface')
Fileops = require('Fileops')


smb_savestate = savestate.create(1)
getInputs = Mario.getInputs
displayBoard = Interface.displayBoard
totalGameState = {}
run = 0
Interface.initializeRun(smb_savestate)
while true do
    displayBoard()

	playerStatus = memory.readbyte(0x000E)
	if playerStatus ~= 11 and playerStatus ~= 4  then
  		gamestate = displayBoard()
		table.insert(totalGameState, gamestate)
    else
    	Fileops.write_full_game(totalGameState, run .. ".txt")
    	totalGameState = {}
    	run = run + 1
    	Interface.initializeRun(smb_savestate)
	end

    emu.frameadvance()
end