local NeuralNetslib = {}

function NeuralNetslib.visualize(active_nn, threshold)
	button_x_start = 223
	screen_x_stop = 80
	num_layers = #active_nn.net_def.modules+1
	line_length = (button_x_start - screen_x_stop)/num_layers
	num_inputs = 169
	y_soft_max = 87
	y_hard_max = 256/4
	y = 48
	x = 26
	graph = {}
    board = getInputs()
    graph[0] = {}
    for i = 1,169 do
		graph[0][i] = {}
		graph[0][i]["x"] = x
		graph[0][i]["y"] = y
		graph[0][i]["value"] = board[i]
		graph[0][i]["weight"] = 1
		local opacity = 0xFF000000
		if board[i] == 0 then
		    opacity = 0x00000000
		    graph[0][i]["color"] = 0x00000000
		    color = 0
		elseif board[i] == 1 then
            color = 100
		    graph[0][i]["color"] = 0xFFFFFF00
		else
            color = 255
		    graph[0][i]["color"] = 0xFF000000
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
	x = screen_x_stop
	for i =	1,(num_layers-1) do
		graph[i] ={}
		y = 1
		x = x+line_length
		if torch.typename(active_nn.net_def.modules[i]) == "nn.MulConstant" then
			num_outputs = num_inputs
		else
			num_outputs = (torch.totable(#active_nn.net_def.modules[i].weight)[1])
		end
		if num_outputs < 30 then
			y = ((87-y)/2) - (num_outputs/2)
			y_delta = 2
			y_shift = 8
		elseif num_outputs < 64 then
			y = ((87-y)/2) - (num_outputs/2)
			y_delta = 1
			y_shift = 2
		else
			y_delta = 0
			y_shift = .75
		end
		for j=1, num_outputs do
			graph[i][j] = {}
			graph[i][j]["x"] = x
			graph[i][j]["y"] = y
			graph[i][j]["value"] = 0
			gui.drawbox(x-2,y-y_delta,x+2,y+y_delta,"black")
			for k = 1,#graph[i-1] do
				-- print('gt+zero')
				-- --if i > 1 and torch.typename(active_nn.net_def.modules[i-1]) ~= "nn.MulConstant" or dispAll then
				-- 	print("i = " .. i .. "," .. (num_layers-1))
				-- 	print("j = " .. j .. "," .. (num_outputs-1))
				-- 	print("k = "  .. k .. "," .. #graph[i-1])
				-- 	-- print
				-- 	print(#(active_nn.net_def.modules[i].weight))
				-- 	print(#(active_nn.net_def.modules[i].weight[j]))
				-- 	print(active_nn.net_def.modules[i].weight[j][k])
				-- 	print(tonumber(active_nn.net_def.modules[i].weight[j][k]))
				-- 	print("test")

					if  tonumber(active_nn.net_def.modules[i].weight[j][k]) > 0  then
					    graph[i][j]["color"] = "0xFFFFFF00"
					else
						graph[i][j]["color"] = "0xFF000000"
					end
					color_step = 0xFFFFFFFF
					-- print(tonumber(active_nn.net_def.modules[i].weight[j][k]))
					-- print(graph[i-1][k]["value"])
					graph[i][j]["value"] = graph[i][j]["value"] + graph[i-1][k]["value"]*tonumber(active_nn.net_def.modules[i].weight[j][k])
					-- print(graph[i-1][k]["value"])
					-- print(tonumber(active_nn.net_def.modules[i].weight[j][k]))
					-- print(graph[i][j]["value"])
				--end
				graph[i][j]["value"] = graph[i][j]["value"] + active_nn.net_def.modules[i].bias[j]
				if graph[i-1][k]["value"] ~= 0  then

					-- print((0xFF*math.abs(graph[i-1][k]["value"])))
					-- print("k = "  .. k .. "," .. #graph[i-1])
					-- print(graph[i-1][k]["color"])
					gui.drawline(graph[i-1][k]["x"], graph[i-1][k]["y"], x, y, (color_step*math.abs(graph[i-1][k]["value"])*math.abs(tonumber(active_nn.net_def.modules[i].weight[j][k]))))
				end
			end
			y = y + (2*y_shift)
		end
		num_inputs = num_outputs
	end

    -- local network = genome.network
    -- local cells = {}
    -- local i = 1
    -- local cell = {}
    -- for dy=-BoxRadius,BoxRadius do
    --     for dx=-BoxRadius,BoxRadius do
    --         cell = {}
    --         cell.x = 50+5*dx
    --         cell.y = 70+5*dy
    --         cell.value = network.neurons[i].value
    --         cells[i] = cell
    --         i = i + 1
    --     end
    -- end
    -- local biasCell = {}
    -- biasCell.x = 80
    -- biasCell.y = 110
    -- biasCell.value = network.neurons[Inputs].value
    -- cells[Inputs] = biasCell
    
    -- for o = 1,Outputs do
    --     cell = {}
    --     cell.x = 220
    --     cell.y = 30 + 8 * o
    --     cell.value = network.neurons[MaxNodes + o].value
    --     cells[MaxNodes+o] = cell
    --     local color
    --     if cell.value > 0 then
    --         color = 0xFF0000FF
    --     else
    --         color = 0xFF000000
    --     end
    --     gui.drawtext(223, 24+8*o, Interface.ButtonNames[o], color, 9)
    -- end
    
    -- for n,neuron in pairs(network.neurons) do
    --     cell = {}
    --     if n > Inputs and n <= MaxNodes then
    --         cell.x = 140
    --         cell.y = 40
    --         cell.value = neuron.value
    --         cells[n] = cell
    --     end
    -- end
    
    -- for n=1,4 do
    --     for _,gene in pairs(genome.genes) do
    --         if gene.enabled then
    --             local c1 = cells[gene.into]
    --             local c2 = cells[gene.out]
    --             if gene.into > Inputs and gene.into <= MaxNodes then
    --                 c1.x = 0.75*c1.x + 0.25*c2.x
    --                 if c1.x >= c2.x then
    --                     c1.x = c1.x - 40
    --                 end
    --                 if c1.x < 90 then
    --                     c1.x = 90
    --                 end
                    
    --                 if c1.x > 220 then
    --                     c1.x = 220
    --                 end
    --                 c1.y = 0.75*c1.y + 0.25*c2.y
                    
    --             end
    --             if gene.out > Inputs and gene.out <= MaxNodes then
    --                 c2.x = 0.25*c1.x + 0.75*c2.x
    --                 if c1.x >= c2.x then
    --                     c2.x = c2.x + 40
    --                 end
    --                 if c2.x < 90 then
    --                     c2.x = 90
    --                 end
    --                 if c2.x > 220 then
    --                     c2.x = 220
    --                 end
    --                 c2.y = 0.25*c1.y + 0.75*c2.y
    --             end
    --         end
    --     end
    -- end
    
    -- gui.drawbox(50-BoxRadius*5-3,70-BoxRadius*5-3,50+BoxRadius*5+2,70+BoxRadius*5+2,0xFF000000, 0x80808080)
    -- for n,cell in pairs(cells) do
    --     if n > Inputs or cell.value ~= 0 then
    --         local color = math.floor((cell.value+1)/2*256)
    --         if color > 255 then color = 255 end
    --         if color < 0 then color = 0 end
    --         local opacity = 0xFF000000
    --         if cell.value == 0 then
    --             opacity = 0x50000000
    --         end
    --         color = opacity + color*0x10000 + color*0x100 + color
    --         gui.drawbox(cell.x-2,cell.y-2,cell.x+2,cell.y+2,opacity,color)
    --     end
    -- end
    -- for _,gene in pairs(genome.genes) do
    --     if gene.enabled then
    --         local c1 = cells[gene.into]
    --         local c2 = cells[gene.out]
    --         local opacity = 0x000000A0
    --         if c1.value == 0 then
    --             opacity = 0x00000020
    --         end
            
    --         local color = 0x80-math.floor(math.abs(sigmoid(gene.weight))*0x80)
    --         if gene.weight > 0 then 
    --             color = opacity + 0x8000 + 0x1000000*color
    --         else
    --             color = opacity + 0x800000 + 0x10000*color
    --         end
    --         gui.drawline(c1.x+1, c1.y, c2.x-3, c2.y, color)
    --     end
    -- end
    
    -- gui.drawbox(49,71,51,78,0x00000000,0x80FF0000)
end

return NeuralNetslib