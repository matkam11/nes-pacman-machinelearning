-- MarI/O by SethBling
-- Feel free to use this code, but please do not redistribute it.
-- Intended for use with the BizHawk emulator and Super Mario World or Super Mario Bros. ROM.
-- For SMW, make sure you have a save state named "DP1.state" at the beginning of a level,
-- and put a copy in both the Lua folder and the root directory of BizHawk.
torch = require "torch"
ffi = require 'ffi'
nn = require "nn"

Filename = "smb.fc0"
ButtonNames = {
	"A",
	"B",
	"up",
	"down",
	"left",
	"right",
}

BoxRadius = 6
InputSize = (BoxRadius*2+1)*(BoxRadius*2+1)

Inputs = InputSize+1
Outputs = #ButtonNames

Population = 300
DeltaDisjoint = 2.0
DeltaWeights = 0.4
DeltaThreshold = 1.0

StaleSpecies = 15

MutateConnectionsChance = 0.25
PerturbChance = 0.90
CrossoverChance = 0.75
LinkMutationChance = 2.0
NodeMutationChance = 0.50
BiasMutationChance = 0.40
StepSize = 0.1
DisableMutationChance = 0.4
EnableMutationChance = 0.2

TimeoutConstant = 20

MaxNodes = 1000000
smb_savestate = savestate.create(1)
function getPositions()
	marioX = memory.readbyte(0x6D) * 0x100 + memory.readbyte(0x86)
	marioY = memory.readbyte(0x03B8)+16

	screenX = memory.readbyte(0x03AD)
	screenY = memory.readbyte(0x03B8)
end

function getTile(dx, dy)
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

function getSprites()
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

function getInputs()
	getPositions()
	
	sprites = getSprites()	
	local inputs = {}
	
	for dy=-BoxRadius*16,BoxRadius*16,16 do
		for dx=-BoxRadius*16,BoxRadius*16,16 do
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

function clearJoypad()
	controller = {}
	for b = 1,#ButtonNames do
		controller[ButtonNames[b]] = false
	end
	joypad.set(1,controller)
end

function initializeRun()
	savestate.load(smb_savestate);
	rightmost = 0
	timeout = TimeoutConstant
	clearJoypad()
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end


function displayBoard()
	local controller = joypad.get(1)
	for o = 1,Outputs do
		local color
		if controller[ButtonNames[o]] then
			color = 0xFF0000FF
		else
			color = 0xFF000000
		end
		gui.drawtext(223, 24+8*o, ButtonNames[o], color)
	end
	y = 48
	x = 26
    board = getInputs()
    for i = 1,169 do
		local opacity = 0xFF000000
		if board[i] == 0 then
		    opacity = 0x00000000
		    color = 0
		elseif board[i] == 1 then
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

function displayGenome(genome)
	frame = joypad.get(1)
	labels = joypad.get(1)
	local network = genome.network
	local cells = {}
	local i = 1
	local cell = {}
	for dy=-BoxRadius,BoxRadius do
		for dx=-BoxRadius,BoxRadius do
			cell = {}
			cell.x = 50+5*dx
			cell.y = 70+5*dy
			cell.value = network.neurons[i].value
			cells[i] = cell
			i = i + 1
		end
	end
	local biasCell = {}
	biasCell.x = 80
	biasCell.y = 110
	biasCell.value = network.neurons[Inputs].value
	cells[Inputs] = biasCell
	controller = joypad.get(1)	
	for o = 1,Outputs do
		cell = {}
		cell.x = 220
		cell.y = 30 + 8 * o
		cell.value = network.neurons[MaxNodes + o].value
		cells[MaxNodes+o] = cell
		local color
		if controller[ButtonNames[o]] then
			color = 0xFF0000FF
		else
			color = 0xFF000000
		end
		gui.drawtext(223, 24+8*o, ButtonNames[o], color, 9)
	end

	gui.drawbox(50-BoxRadius*5-3,70-BoxRadius*5-3,50+BoxRadius*5+2,70+BoxRadius*5+2,0xFF000000, 0x80808080)
	for n,cell in pairs(cells) do
		if n > Inputs or cell.value ~= 0 then
			status = 0
			--printline(cell.value)
			local color = math.floor((cell.value+1)/2*256)
			if cell.value ~= 0 and color == 0 then status = 2 end
			if color > 255 then 
				color = 100 
				status = 1
			end -- Ground Tiles
			if color < 0 then color = 0 end
			local opacity = 0xFF000000
			if cell.value == 0 then
				opacity = 0x00000000
			end
			color = opacity + color*0x10000 + color*0x100 + color
			gui.drawbox(cell.x-2,cell.y-2,cell.x+2,cell.y+2,opacity,color)
			table.insert(frame, status)
		end
	end
	gameState = {}
	gameState['labels'] = labels
	gameState['frame'] = frame
	gui.drawbox(49,71,51,78,0x00000000,0x80FF0000)
	return gameState
end

function loadFile(filename)
    local file = io.open(filename, "r")
	pool = newPool()
	pool.generation = file:read("*number")
	pool.maxFitness = file:read("*number")
	forms.settext(maxFitnessLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
        local numSpecies = file:read("*number")
        for s=1,numSpecies do
		local species = newSpecies()
		table.insert(pool.species, species)
		species.topFitness = file:read("*number")
		species.staleness = file:read("*number")
		local numGenomes = file:read("*number")
		for g=1,numGenomes do
			local genome = newGenome()
			table.insert(species.genomes, genome)
			genome.fitness = file:read("*number")
			genome.maxneuron = file:read("*number")
			local line = file:read("*line")
			while line ~= "done" do
				genome.mutationRates[line] = file:read("*number")
				line = file:read("*line")
			end
			local numGenes = file:read("*number")
			for n=1,numGenes do
				local gene = newGene()
				table.insert(genome.genes, gene)
				local enabled
				gene.into, gene.out, gene.weight, gene.innovation, enabled = file:read("*number", "*number", "*number", "*number", "*number")
				if enabled == 0 then
					gene.enabled = false
				else
					gene.enabled = true
				end
				
			end
		end
	end
        file:close()
	
	while fitnessAlreadyMeasured() do
		nextGenome()
	end
	initializeRun()
	pool.currentFrame = pool.currentFrame + 1
end
 

function playTop()
	local maxfitness = 0
	local maxs, maxg
	for s,species in pairs(pool.species) do
		for g,genome in pairs(species.genomes) do
			if genome.fitness > maxfitness then
				maxfitness = genome.fitness
				maxs = s
				maxg = g
			end
		end
	end
	
	pool.currentSpecies = maxs
	pool.currentGenome = maxg
	pool.maxFitness = maxfitness
	forms.settext(maxFitnessLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
	initializeRun()
	pool.currentFrame = pool.currentFrame + 1
	return
end

function curr_fitness()
	gui.drawtext(223, 80, memory.readbyte(0x6D) * 0x100 + memory.readbyte(0x86), color)
	return memory.readbyte(0x6D) * 0x100 + memory.readbyte(0x86)
end

function writeData(data,filename)
    local file = io.open(filename, "w")
    -- lenOfData = table.getn(data)
    -- for f = 1,lenOfData do
    	--printline("On frame " .. f .. " of " .. lenOfData)
    	for i = 1,169 do
    		file:write(data["frame"][i] .. " ")
    	end
    	file:write("\n")
    -- end
    file:close()

    -- local file = io.open("labels_" .. filename, "w")
    -- lenOfData = table.getn(data)
    -- for f = 1,lenOfData do
    -- 	--printline("On Label " .. f .. " of " .. lenOfData)
    -- 	currLabel = data[f]['labels']
    -- 	file:write(tostring(currLabel["A"]) .. " " .. tostring(currLabel["B"]) .. " " .. tostring(currLabel["Down"]) .. " " .. tostring(currLabel["Left"]) .. " " .. tostring(currLabel["Right"]) .. " " .. tostring(currLabel["Up"]))
    -- 	file:write("\n")
    -- end
    -- print(currLabel)
    -- file:close()
end

-- function key_num_to_table(key_num)
-- 	key_table = {}
-- 	local button_names = {
-- 		"up"
-- 		"right",
-- 		"left",
-- 		"down",
-- 		"B",
-- 		"A",
-- 	}
-- 	for i = 1,5 do
-- 		if (math.fmod(key_num,2*i) == 1)  then
-- 			key_table[button_names[i]] = tu
-- 			key_table["right"] = (math.fmod(key_num-(key_num2),4))
-- 		end
-- 	end
-- 	return key_table
-- end

function key_table_to_table(input_key_table,thershold)
	key_table = {}
	local button_names = {
		"A",
		"B",
		"down",
		"left",
		"right",
		"up"
	}
	for i = 1,5 do
		if input_key_table[i] > thershold then
			key_table[button_names[i]] = true
		else
			key_table[button_names[i]] = false
		end
	end
	return key_table
end

function key_string_to_table(key_string)
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

function press_keys(key_table)
	joypad.set(1,key_table)
end

totalGameState = {}
run = 0
--net = torch.load('nnparame.par')
bestNN = 1
bestFitness = 0
for n = 130,1000 do
	print("Testing " .. n)
	net = torch.load('/home/matkam11/School/nes-pacman-machinelearning/torch_nn/nn/multilabel ' .. n .. '.par')
	initializeRun()
	fitness = curr_fitness
	no_move = 0
	myframe = 0
	while true do
	    displayBoard()
		playerStatus = memory.readbyte(0x000E)
		--print(displayBoard()['frame'])
		prediction = net:forward(torch.DoubleTensor(displayBoard()['frame']))
		--print(prediction)
		press_keys(key_table_to_table(prediction,.5))
		old_fitness = fitness
		fitness = curr_fitness()
		if old_fitness == fitness then
			no_move = no_move + 1
		end

		if no_move > 100 then
			no_move = 0
			break
		end

		-- local confidences, indices = torch.sort(prediction, true)
		-- print(indices)
		-- print(indices[1] == 3)
		-- print(indices[1] == 4)
		-- for i = 1,#indices do
		-- 	print()
		-- end

		--print(type(indices[1]))
		--press_keys(key_string_to_table(stringOut))
		if playerStatus ~= 11 and playerStatus ~= 4  then
	  		--gamestate = displayBoard()
			--table.insert(totalGameState, gamestate)
	    else
	    	--writeData(totalGameState, run .. ".txt")
	    	--totalGameState = {}
	    	run = run + 1
	    	--initializeRun()
	    	break
		end
		emu.frameadvance()
		myframe  = myframe  +1
	end
	if fitness > bestFitness then
		bestFitness = fitness
		bestNN = n
		print(myframe )
		print("Found new Best! NN: " .. n .. " Fitness: " .. fitness )
	end
end
print(bestNN)
print(bestFitness)
