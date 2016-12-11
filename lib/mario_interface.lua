-- MarI/O by SethBling
-- Feel free to use this code, but please do not redistribute it.
-- Intended for use with the BizHawk emulator and Super Mario World or Super Mario Bros. ROM.
-- For SMW, make sure you have a save state named "DP1.state" at the beginning of a level,
-- and put a copy in both the Lua folder and the root directory of BizHawk.
Mario = {}

Mario.Filename = "smb.fc0"

Mario.BoxRadius = 6
Mario.InputSize = (Mario.BoxRadius*2+1)*(Mario.BoxRadius*2+1)

Mario.Inputs = Mario.InputSize+1
Mario.Outputs = #Interface.ButtonNames

function Mario.getPositions()
	marioX = memory.readbyte(0x6D) * 0x100 + memory.readbyte(0x86)
	marioY = memory.readbyte(0x03B8)+16

	screenX = memory.readbyte(0x03AD)
	screenY = memory.readbyte(0x03B8)
end

function Mario.getTile(dx, dy)
	local x = marioX + dx + 8
	local y = marioY + dy - 16
	local page = math.floor(x/256)%2

	local subx = math.floor((x%256)/16)
	local suby = math.floor((y - 32)/16)
	local addr = 0x500 + page*13*16+suby*16+subx
	
	if suby >= 13 or suby < 0 then
		return 0
	end
	
	if memory.readbyte(addr) ~= 0 then
		return 1
	else
		return 0
	end
end

function Mario.getSprites()
	local sprites = {}
	for slot=0,4 do
		local enemy = memory.readbyte(0xF+slot)
		if enemy ~= 0 then
			local ex = memory.readbyte(0x6E + slot)*0x100 + memory.readbyte(0x87+slot)
			local ey = memory.readbyte(0xCF + slot)+24
			sprites[#sprites+1] = {["x"]=ex,["y"]=ey}
		end
	end
	
	return sprites
end

function Mario.getInputs()
	Mario.getPositions()
	
	sprites = Mario.getSprites()
	
	local inputs = {}
	
	for dy=-Mario.BoxRadius*16,Mario.BoxRadius*16,16 do
		for dx=-Mario.BoxRadius*16,Mario.BoxRadius*16,16 do
			inputs[#inputs+1] = 0
			
			tile = getTile(dx, dy)
			if tile == 1 and marioY+dy < 0x1B0 then
				inputs[#inputs] = 1
			end
			
			for i = 1,#sprites do
				distx = math.abs(sprites[i]["x"] - (marioX+dx))
				disty = math.abs(sprites[i]["y"] - (marioY+dy))
				if distx <= 8 and disty <= 8 then
					inputs[#inputs] = -1
				end
			end
		end
	end
	
	--mariovx = memory.read_s8(0x7B)
	--mariovy = memory.read_s8(0x7D)
	
	return inputs
end

function Mario.curr_fitness()
	local score = 0
	xpos = memory.readbyte(0x6D) * 0x100 + memory.readbyte(0x86)
	gui.drawtext(223, 80, xpos, color)
	score = score + xpos
	playerStatus = memory.readbyte(0x000E)
	if playerStatus = 11 or playerStatus = 4  then
		score = score - 1000
	end
	return score
end

return Mario;