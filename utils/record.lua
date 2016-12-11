package.path = "../lib/?.lua;../config/?.lua;" .. package.path

Interface = require('Interface')
Mario = require('Mario')
Config = require('config')
Fileops = require('Fileops')


smb_savestate = savestate.create(1)
getInputs = Mario.getInputs
displayBoard = Interface.displayBoard
totalGameState = {}
run = 1
Interface.initializeRun(smb_savestate)
while true do
    displayBoard()
	playerStatus = memory.readbyte(0x000E)
    ypos =  memory.readbyte(0x03B8)+16
    gui.drawtext(223, 88, ypos, color)

	if playerStatus ~= 11 and playerStatus ~= 4  and ypos < 220 then
  		gamestate = displayBoard()
		table.insert(totalGameState, gamestate)
    else 
        if playerStatus ~= 11 and ypos < 220 then
        	Fileops.write_full_game(totalGameState, run .. ".txt")
        	run = run + 1
        end
        totalGameState = {}
    	Interface.initializeRun(smb_savestate)
    end

    emu.frameadvance()
end
