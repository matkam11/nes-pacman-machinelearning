package.path = "../lib/?.lua;" .. package.path
torch = require "torch"
ffi = require 'ffi'
nn = require "nn"

Interface = require('Interface')
Fileops = require('Fileops')
-- ####################################################################
function get_int_from_bin(line)
  number = tonumber(line:gsub(" " , ""),2)
  return number
end

-- ####################################################################
function getResizedVectorLine(inputTensorLine)
  local reshaped_file_tensor = {}
  local resized_tensor = {}
  local vectorTensor = {}
    reshaped_file_tensor = torch.DoubleTensor(13,13):copy(inputTensorLine)
    --print(reshaped_file_tensor[i][{{6,10},{6,13}}])
    resized_tensor = reshaped_file_tensor[{{6,10},{6,13}}]
    vectorTensorLine=torch.DoubleTensor(40):copy(resized_tensor)
  return vectorTensorLine
end

-- ####################################################################
function getResizedVector(inputTensor)
  local vectorTensor = {}
  for i=1,(#inputTensor)[1] do
    vectorTensor[i]=getResizedVectorLine(inputTensor[i])
  end
  return vectorTensor
end

-- ----------------------------------------------------------------

if false then
  -- Load NN objsect
  net = torch.load('nnparame.par')

  --load data
  -- Load the data
  dataPath = "data_1.txt"
  labelsPath = "labels_1.txt"
  dataset={}
  dataset = Fileops.get_data_and_labelsMULTILABEL(dataPath,labelsPath)

  setmetatable(dataset,
    {__index = function(t, i)
        return {t.data[i], t.label[i]}
        end}
    );
    dataset.data = dataset.data:double() -- convert the data from a ByteTensor to
    -- a DoubleTensor.

    function dataset:size()
      return self.data:size(1)
    end
    for i=1, 2993 do
      dataset.label[i]=dataset.label[i]+1
    end

    class_performance = {
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0}
    for i=1,dataset:size() do
      local groundtruth = dataset.label[i]
      print(dataset.data[i])
      print(#dataset.data[i])
      local prediction = net:forward(dataset.data[i])
      local confidences, indices = torch.sort(prediction, true) -- true means sort in descending order
      print(indices[1])
      if groundtruth == indices[1] then
        class_performance[groundtruth] = class_performance[groundtruth] + 1
      end
    end

    for i=1, 64 do
      print(i, class_performance[i]/dataset:size() .. ' %')
    end

  end

  if true then
    -- Load NN objsect
    net = torch.load('multilabel.par')

    --load data
    -- Load the data
    dataPath = "../Data/data_0.txt"
    labelsPath = "../Data/labels_0.txt"
    dataset={}
    dataset = Fileops.get_data_and_labelsNEW(dataPath,labelsPath)

    for i=1,#dataset do
      prediction = net:forward(dataset[i][1])
      print(prediction)
    end

  -- this is the order in which the buttos are on the labels file
  classes = {'A', 'B', 'Down', 'Left',
    'Right', 'Up'}
  --print(classes[dataset[2][2]])


  end


  if false then
    -- Load NN objsect
    net = torch.load('multilabel.par')

    --load data
    -- Load the data
    dataPath = "../Data/data_2/data_1.txt"
    labelsPath = "../Data/data_2/labels_1.txt"
    dataset={}
    dataset = Fileops.get_data_and_labelsMATRIX(dataPath,labelsPath)

    for i=1,#dataset do -- BREAKING HERE
      prediction = net:forward((getResizedVectorLine(dataset[i][1])))
      print(prediction)
    end

  -- this is the order in which the buttos are on the labels file
  classes = {'A', 'B', 'Down', 'Left',
    'Right', 'Up'}
  --print(classes[dataset[2][2]])


  end
