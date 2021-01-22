function scanlineFilter(scan_line, last_scan)
  local filter = scan_line[1]
  scan_line:remove(1)
  for i, channels pairs(scan_line) do
    if (filter == 0 or i == 1) then
    elseif (filter == 1) then
      local a = scan_line[i - 1]
      channels[1] = (channels[1] + a[1])%256
      channels[2] = (channels[2] + a[2])%256
      channels[3] = (channels[2] + a[3])%256
    elseif (filter == 2) then
      local b = last_scan[i]
      channels[1] = (channels[1] + b[1])%256
      channels[2] = (channels[2] + b[2])%256
      channels[3] = (channels[2] + b[3])%256
    elseif (filter == 3) then
      local a = scan_line[i - 1]
      local b = last_scan[i]
      channels[1] = math.floor(a[1] + b[1])%256
      channels[2] = math.floor(a[2] + b[2])%256
      channels[3] = math.floor(a[3] + b[3])%256
    elseif (filter == 4) then

    end
    io.write(" " .. "r" .. channels[1] .. "g" .. channels[2] .. "b" .. channels[3])
  end

end

-- from an inflated string gets filter type and stores scanline values for filtering
function stringToScanline(string, y, width)
  local scanline = {}
  local pos = (y - 1) * (width * 3 + 1) + 1
  -- store filter type
  scanline[1] = (string.byte(s:sub(pos, pos)))
  for i = 1, width, 1 do
    -- get rgb values to fil into array
    local rgb = {}
    r[1] = string.byte(s:sub(pos, pos))
    g[1] = string.byte(s:sub(pos + 1, pos + 1))
    b[1] = string.byte(s:sub(pos + 2, pos + 2))
    scanline[i + 1] = rgb
    pos = pos + 3
  end
  return scanline
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

s = s:sub(1, s:len()-7)

local component = require("component")
local data = component.data

s = data.inflate(s)

--for i = 1, s:len(), 1 do
--  print(string.byte(s:sub(i,i)))
--end

local last_scan
for y = 1, height, 1 do
  local scan = stringToScanline(s, y, width)
  scanlineFilter(scan, last_scan)
  last_scan = scan
  print()
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
