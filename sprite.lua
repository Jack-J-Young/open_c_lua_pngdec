function lineFilter(string, type, pos , width)
  local r = string.byte(s:sub(pos, pos))
  local g = string.byte(s:sub(pos + 1, pos + 1))
  local b = string.byte(s:sub(pos + 2, pos + 2))
  if (type == 0) then
  elseif (type == 1) then
    r = (r + string.byte(s:sub(pos + 4, pos + 4)))%255
    g = (g + string.byte(s:sub(pos + 5, pos + 5)))%255
    b = (b + string.byte(s:sub(pos + 6, pos + 6)))%255
  elseif (type == 2) then
    r = (r + string.byte(s:sub(pos - (width * 3) + 1, pos - (width * 3) + 1)))%255
    g = (g + string.byte(s:sub(pos - (width * 3) + 1 + 1, pos - (width * 3) + 1 + 1)))%255
    b = (b + string.byte(s:sub(pos - (width * 3) + 1 + 2, pos - (width * 3) + 1 + 2)))%255
  elseif (type == 3) then
    r = (r + math.floor((string.byte(s:sub(pos + 4, pos + 4)) + string.byte(s:sub(pos - (width * 3) + 1, pos - (width * 3) + 1)))/2))%255
    g = (g + math.floor((string.byte(s:sub(pos + 5, pos + 5)) + string.byte(s:sub(pos - (width * 3) + 1 + 1, pos - (width * 3) + 1 + 1)))/2))%255
    b = (b + math.floor((string.byte(s:sub(pos + 6, pos + 6)) + string.byte(s:sub(pos - (width * 3) + 1 + 2, pos - (width * 3) + 1 + 2)))/2))%255
  elseif (type == 4) then

  end
  return r*265^2+g*265+b
end

function idatString(table, start)
  out = ""
  for i, dec in pairs(table) do
    if (i >= start) then
      out = out .. string.char(dec)
      --print(string.char(dec))
    end
  end
  return out
end

function findDecSequence(table, seq)
  local cur_seq = seq
  for i, dec in pairs(table) do
    if (table[i] == string.byte(cur_seq)) then
      cur_seq = cur_seq:sub(2)
    elseif (cur_seq == "") then
      return i
    elseif not(cur_seq == seq) then
      cur_seq = seq
    end
  end
end

function fourByteToInt(table, pos)
  return table[pos]*256^3 + table[pos + 1]*256^2 + table[pos + 2]*256^1 + table[pos + 3]*1
end

function fileToDecTable(file)
  local table = {}
  local n = 0
  local i = 1
  local end_c = 0
  while not(n == null) do
    n = string.byte(file:read(1))
    if (end_c == 0) and (n == 73) then end_c = 1
    elseif (end_c == 1) and (n == 69) then end_c = 2
    elseif (end_c == 2) and (n == 78) then end_c = 3
    elseif (end_c == 3) and (n == 68) then end_c = 4
    else end_c = 0 end
    --print(n)
    if (end_c == 4) then n = null
    else
      table[i] = n
      i = i + 1
    end
  end
  return table
end

local image = assert(io.open("C:\\Users\\jackj\\Documents\\Repos\\test_image.png", "rb"))
--local image = assert(io.open("\\test_image.png", "rb"))
--a = image:read("*a")
local t = fileToDecTable(image)
--print(t[17])
local width = fourByteToInt(t, 17)
local height = fourByteToInt(t, 21)
--print(findDecSequence(t, "IDAT"))
local n = findDecSequence(t, "IDAT")
local s = idatString(t, n)

s = s:sub(3, s:len()-7)

local component = require("component")
local data = component.data

s = data.inflate(s)

for i = 1, s:len(), 1 do
  print(string.byte(s:sub(i,i)))
end

for y = 1, height, 1 do
  local filter = 1 + (height - 1) * width * 3
  for x = 1, (width - 1)/3, 1 do
    print(lineFilter((x - 1) * 3 + 1))
  end
end

--[[
for y = 1, height, 1 do
  for x = 1, width - 1, 1 do
    local f = s:sub(y*width + x,y*width + x)
    if not(f == null) then
      io.write(string.format("%x", string.byte(f)))
      if (x%3 == 0) then
        io.write(", ")
      end
    end
    --print(f)
  end
  print()
end]]--
