
local Datamanipulation = {}
-- ####################################################################
function Datamanipulation.getResizedVectorLine(inputTensorLine)
  local reshaped_file_tensor = {}
  local resized_tensor = {}
  local vectorTensor = {}
    reshaped_file_tensor = torch.DoubleTensor(13,13):copy(inputTensorLine)
    --print(reshaped_file_tensor[i][{{6,10},{6,13}}])
    local slice = {{6,10},{6,13}}
    resized_tensor = reshaped_file_tensor[slice]
    vectorTensorLine=torch.DoubleTensor(40):copy(resized_tensor)
  return vectorTensorLine
end

-- ####################################################################
function Datamanipulation.getResizedVector(inputTensor)
  local vectorTensor = {}
  for i=1,(#inputTensor)[1] do
    vectorTensor[i]=Datamanipulation.getResizedVectorLine(inputTensor[i])
  end
  return vectorTensor
end

-- ####################################################################
function Datamanipulation.get_int_from_bin(line)
  number = tonumber(line:gsub(" " , ""),2)
  return number
end

return Datamanipulation
