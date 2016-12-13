local Datamanipulation = {}
-- ####################################################################
function Datamanipulation.getResizedVectorLine(inputTensorLine, slice, input_size)
  local reshaped_file_tensor = {}
  local resized_tensor = {}
  local vectorTensor = torch.DoubleTensor(input_size)
  reshaped_file_tensor = torch.DoubleTensor(13,13):copy(inputTensorLine)
  --print(reshaped_file_tensor[i][{{6,10},{6,13}}])
  resized_tensor = reshaped_file_tensor[slice]
  vectorTensorLine=torch.DoubleTensor(input_size):copy(resized_tensor)
  return vectorTensorLine
end

-- ####################################################################
function Datamanipulation.getResizedVector(inputTensor,slice,input_size)
  local vectorTensor = {}
  for i=1,(#inputTensor)[1] do
    vectorTensor[i]=Datamanipulation.getResizedVectorLine(inputTensor[i],slice,input_size)
  end
  return vectorTensor
end

-- ####################################################################
function Datamanipulation.get_int_from_bin(line)
  number = tonumber(line:gsub(" " , ""),2)
  return number
end

-- ####################################################################
--for i=1,#dataset do for i=1,#dataset do
-- trainset.label[i] = getLabelFromArray(dataset[i])
--end
-- ####################################################################
function Datamanipulation.getLabelFromArray(inputData)
  local A={}
  local B={}
  local UP={}
  local DOWN={}
  local LEFT={}
  local RIGHT={}

  A=inputData[2][1]
  B=inputData[2][2]
  UP=inputData[2][3]
  DOWN=inputData[2][4]
  LEFT=inputData[2][5]
  RIGHT=inputData[2][6]
  local label
  if UP==0 and DOWN==0 and LEFT==0 then
    if A~=0 and B~=0 and RIGHT~=0 then
      label = 4
    elseif A~=0 and B~=1 and RIGHT~=0 then
      label = 3
    elseif A~=1 and B~=0 and RIGHT~=0 then
      label = 2
    elseif A~=1 and B~=1 and RIGHT~=0 then
      label = 1
    else
      label = 5
    end
  else
    label = 5
  end
  return label
end

-- ####################################################################
--for i=1,#dataset do for i=1,#dataset do
-- trainset.label[i] = getLabelFromArray(dataset[i])
--end
-- ####################################################################
function Datamanipulation.getThreeLabelFromArray(inputData)
  local A={}
  local B={}
  local UP={}
  local DOWN={}
  local LEFT={}
  local RIGHT={}

  A=inputData[2][1]
  B=inputData[2][2]
  UP=inputData[2][3]
  DOWN=inputData[2][4]
  LEFT=inputData[2][5]
  RIGHT=inputData[2][6]
  local label={0, 0, 1} -- ############# Change to zero perhaps?
  -- label A B RIGHT
  if A~=0 then
    label[1] = 1
  end

  if B~=0 then
    label[2] = 1
  end

  if RIGHT~=0 then
    label[3] = 1
  end

  return torch.DoubleTensor(label)
end

function Datamanipulation.datasetAdjust(dataset, manipulationType)

  --##################################################
  if manipulationType=="Three Labels" then
    local thelabels={}
    for i=1,#dataset do
      -- thelabels should be a matrix [datasetsize X numberoflabels]
      thelabels[i] = Datamanipulation.getThreeLabelFromArray(dataset[i])
    end

    for i=1,#dataset do
      -- thelabels should be a matrix [datasetsize X numberoflabels]
      dataset[i][2]={}
      dataset[i][2] = thelabels[i]

    end

    --##################################################
  elseif manipulationType=="MultiLabelMarginCriterion" then
    local numberoflabels = (#dataset[1][2])[1]
    local thelabels={}
    local x = torch.Tensor(numberoflabels)

    for i = 1, numberoflabels do
      x[i]=i
    end

    for i=1,#dataset do
      -- thelabels should be a matrix [datasetsize X numberoflabels]
      dataset[i][2]:cmul(x)
    end

    --##################################################
  else
    -- Chain other if elseif
    -- leave the lest else blank so in case of fail it the same dataset
    print("No dataset manipulation performed. Returning Original (169 I; 6 L) dataset")
  end

  return dataset
end

return Datamanipulation
