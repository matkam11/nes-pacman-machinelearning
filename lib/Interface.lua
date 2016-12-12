Interface = {}

Interface.ButtonNames = {
	"A",
	"B",
	"up",
	"down",
	"left",
	"right",
}

Interface.Outputs = #Interface.ButtonNames

function Interface.clearJoypad()
	controller = {}
	for b = 1,#Interface.ButtonNames do
		controller[Interface.ButtonNames[b]] = false
	end
	joypad.set(1,controller)
end

function Interface.initializeRun(game_savestate)
	savestate.load(game_savestate);
	Interface.clearJoypad()
end


function Interface.displayBoard()
	local controller = joypad.get(1)
	for o = 1,Interface.Outputs do
		local color
		if controller[Interface.ButtonNames[o]] then
			color = 0xFF0000FF
		else
			color = 0xFF000000
		end
		gui.drawtext(223, 24+8*o, Interface.ButtonNames[o], color)
	end
	y = 48
	x = 26
    board = getInputs()
    for i = 1,169 do
		local opacity = 0xFF000000
		if board[i] == "0" then
		    opacity = 0x00000000
		    color = 0
		elseif board[i] == "1" then
            color = 100
		else
            color = 255
        end
        color = opacity + color*0x10000 + color*0x100 + color
		gui.drawbox(x-2,y-2,x+2,y+2,opacity,color)
        if i % 13 == 0 then
        	x = 26
        	y = y + 4
        else
        	x = x + 4
        end
    end
    gui.drawbox(49,71,51,78,0x00000000,0x80FF0000)
	gameState = {}
	gameState['labels'] = controller
	gameState['frame'] = board
	return gameState
end

function Interface.key_table_to_table(input_key_table,thershold)
	key_table = {}
	local button_names = {
		"A",
		"B",
		"down",
		"left",
		"right",
		"up"
	}
	for i = 1,6 do
		if input_key_table[i] > thershold then
			key_table[button_names[i]] = true
		else
			key_table[button_names[i]] = false
		end
	end
	return key_table
end

function Interface.key_tensor_to_table_t_table(input_key_table)
	key_table = {}
	for i = 1,6 do
 	 if input_key_table[i]==1 then
 		 key_table[Interface.ButtonNames[i]] = true
 	 else
 		 key_table[Interface.ButtonNames[i]] = false
 	 end
  end
	return key_table
end


function Interface.key_table_to_table_t_table(input_key_table,thershold)
	key_table = {}
--i=1
--if input_key_table[i] < thershold[i] then
--	key_table[Interface.ButtonNames[i]] = true
--	print(" INPUT: ".. input_key_table[i] .. " "
--		.. Interface.ButtonNames[i] .. "\n\tTHERS " .. thershold[i].." T")
--else
--	key_table[Interface.ButtonNames[i]] = false
--	print("INPUT: ".. input_key_table[i] .. " "
--		.. Interface.ButtonNames[i]  .."\n\tTHERS " .. thershold[i].." F")
--end

	for i = 1,6 do
		if input_key_table[i] > thershold[i] then
			key_table[Interface.ButtonNames[i]] = true
			print(" INPUT: ".. input_key_table[i] .. " "
				.. Interface.ButtonNames[i] .. "\n\tTHERS " .. thershold[i].." T")
		else
			key_table[Interface.ButtonNames[i]] = false
			print("INPUT: ".. input_key_table[i] .. " "
				.. Interface.ButtonNames[i]  .."\n\tTHERS " .. thershold[i].." F")
		end
	end
	return key_table
end

function Interface.key_string_to_table(key_string)
	local key_table = {}
	local button_names = {
		"A",
		"B",
		"down",
		"left",
		"right",
		"up"
	}
	j = 1
	for i in string.gmatch(key_string,"%S") do
		if i == "1" then
			key_table[button_names[j]] = true
		else
			key_table[button_names[j]] = false
		end
		j=j+1;
	end
	return key_table
end

function Interface.press_keys(key_table)
	joypad.set(1,key_table)
end

return Interface
