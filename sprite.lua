function scanlineFilter(scan_line, last_scan)
  local filter = scan_line[1]
  io.write("F: " .. filter)
  table.remove(scan_line, 1)
  for i, channels in pairs(scan_line) do
    if (filter == 0) then
    elseif (filter == 1) then
      local a = {0, 0, 0}
      if not(i == 1)  then a = scan_line[i - 1] end
      for i, ch in pairs(channels) do
        channels[i] = (channels[i] + a[i])%256
      end
    elseif (filter == 2) then
      local b = {0, 0, 0}
      if not(y == 1)  then b = last_scan[i] end
      for i, ch in pairs(channels) do
        channels[i] = (channels[i] + b[i])%256
      end
    elseif (filter == 3) then
      local a = {0, 0, 0}
      local b = {0, 0, 0}
      if not(i == 1)  then a = scan_line[i - 1] end
      if not(y == 1)  then b = last_scan[i] end
      for i, ch in pairs(channels) do
        channels[i] = math.floor(a[i] + b[i])%256
      end
    elseif (filter == 4) then
      local a = {0, 0, 0}
      local b = {0, 0, 0}
      local c = {0, 0, 0}
      if not(i == 1)  then a = scan_line[i - 1] end
      if not(y == 1)  then b = last_scan[i] end
      if not(y == 1 or i == 1)  then c = last_scan[i - 1] end
      for i, ch in pairs(channels) do
        local p = a[i] + b[i] - c[i]
        local pa = math.abs(p - a[i])
        local pb = math.abs(p - b[i])
        local pc = math.abs(p - c[i])
        local pr = 0
        if (pa <= pb and pa <= pc) then pr = a[i]
        elseif (pb <= pc) then pr = b[i]
        else pr = c[i] end
        channels[i] = (channels[i] + pr)%256
      end
    end
    io.write(" r" .. channels[1] .. "g" .. channels[2] .. "b" .. channels[3])
  end

end

-- from an inflated string gets filter type and stores scanline values for filtering
function stringToScanline(string, y, width)
  local scanline = {}
  local pos = (y - 1) * (width * 3 + 1) + 1
  -- store filter type
  scanline[1] = (string.byte(s:sub(pos, pos)))
  pos = pos + 1
  for i = 1, width, 1 do
    -- get rgb values to fil into array
    local rgb = {}
    rgb[1] = string.byte(s:sub(pos, pos))
    rgb[2] = string.byte(s:sub(pos + 1, pos + 1))
    rgb[3] = string.byte(s:sub(pos + 2, pos + 2))
    scanline[i + 1] = rgb
    pos = pos + 3
  end
  return scanline
end

function drawScanline(x, y, scanline, gpu)
  for i, channels in pairs(scanline) do
    gpu.setBackground(channels[1] * 256^2 + channels[2] * 256 + channels[3])
    gpu.set(x + i - 1, y, " ")
  end
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

--local image = assert(io.open("C:\\Users\\jackj\\Documents\\Repos\\test_image.png", "rb"))
local image = assert(io.open("\\test_image.png", "rb"))
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
local gpu = component.gpu

s = data.inflate(s)

local last_scan
for y = 1, height, 1 do
  local scan = stringToScanline(s, y, width)
  scanlineFilter(scan, last_scan)
  drawScanline(1, y, scan, gpu)
  last_scan = scan
  print()
end
