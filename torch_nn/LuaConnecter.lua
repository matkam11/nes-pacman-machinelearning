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

    local temp = Datamanipulation.getResizedMatrixUnit(
      torch.DoubleTensor(displayBoard()['frame'])
      ,active_nn.meta.input_slice)
    local input =torch.DoubleTensor(1,13,13)
    for j=1,1 do
      for k=1,13 do
        for z=1,13 do
          input[j][k][z]=temp[k][z]

        end
      end
    end

    --prediction = net:forward(Datamanipulation.getResizedVectorLine(torch.DoubleTensor(displayBoard()['frame']),active_nn.meta.input_slice,active_nn.meta.inputs))

		print("================================================================")
		local thres = -3.5560620383429
		prediction = net:forward(input)
    if prediction[3]>(thres) then
			print(" INPUT: ".. prediction[3] .. " " ..
				"\n\tTHERS " .. thres.." T")
			prediction[3] = 1
			print("HAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		else
			print(" INPUT: ".. prediction[3] .. " " ..
				"\n\tTHERS " .. thres.." F")
    end
		print("prediction")
		print(prediction)

		local confidences, indices = torch.sort(prediction, true)
    --Interface.press_keys(Interface.key_table_to_table_t_table(prediction,active_nn.meta.thershold))
    local inputTable = {}
    inputTable = Datamanipulation.getArrayFromLabelNumber(indices[1])

    Interface.press_keys(Interface.key_tensor_to_table_t_table(inputTable))
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

    if playerStatus == 11 and playerStatus == 4 then
      run = run + 1
      break
    end
    emu.frameadvance()
    myframe = myframe +1
  end
end
