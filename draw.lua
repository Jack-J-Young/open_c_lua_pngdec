local component = require("component")
local gpu = component.gpu

function line(x1, y1, x2, y2)
  gpu.setBackground(0xffffff)
  local m = (y2-y1)/(x2-x1)
  local c = (y1-m*x1)
  local y = 0
  for x = math.min(x1, x2), math.max(x1, x2), 1 do
    if (m*x+c - y > math.abs(1)) then
      local s = m/math.abs(m)
      for iy = y + s, m*x+c, s do
        gpu.set(x, iy, " ")
      end
    end
    y = m*x+c
    gpu.set(x, y, " ")
  end
  gpu.setBackground(0x000000)
end

gpu.fill(1,1,100,50, " ")
line(3,2, 20, 45)
