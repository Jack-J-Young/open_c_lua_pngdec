local component = require("component")
local gpu = component.gpu

function line(x1, y1, x2, y2)
  gpu.setBackground(0xffffff)
  local m = (y2-y1)/(x2-x1)
  local c = (y1-m*x1)
  for x = x1, x2, 1 do
    gpu.set(x, m*x+c, " ")
  end
  gpu.setBackground(0x000000)
end

line(3,2, 20, 45)
