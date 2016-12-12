
local Datamanipulation = {}
-- ####################################################################
function Datamanipulation.getResizedMatrixUnit(inputTensorLine, slice)

  local reshaped_file_tensor = {}
  local resized_tensor = {}
    reshaped_file_tensor = torch.DoubleTensor(13,13):copy(inputTensorLine)
    resized_tensor = reshaped_file_tensor[slice]

  return torch.Tensor(resized_tensor)
end

-- ####################################################################
function Datamanipulation.getResizedResMatrix(inputTensor,slice)
  local vectorTensor = {}

  for i=1,(#inputTensor)[1] do
    vectorTensor[i] = Datamanipulation.getResizedMatrixUnit(inputTensor[i],slice)
  end
  return vectorTensor
end

function TableToTensor(table)
  local tensorSize = table[1]:size()
  local tensorSizeTable = {-1}
  for i=1,tensorSize:size(1) do
    tensorSizeTable[i+1] = tensorSize[i]
  end
  merge=nn.Sequential()
    :add(nn.JoinTable(1))
    :add(nn.View(unpack(tensorSizeTable)))

  return merge:forward(table)
end

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

return Datamanipulation
