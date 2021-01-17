local component = require("component")
local gpu = component.gpu

function line(x1, y1, x2, y2)
  gpu.setBackground(0xffffff)
  local m = (y2-y1)/(x2-x1)
  local c = (y1-m*x1)
  local y = 0
  for x = x1, x2, 1 do
    if (m*x+c - y > 1) then
      for iy = y + 1, m*x+c, 1 do
        gpu.set(x, iy, " ")
      end
    else
    gpu.set(x, y, " ")
    end
    y = m*x+c
  end
  gpu.setBackground(0x000000)
end

line(3,2, 20, 45)
