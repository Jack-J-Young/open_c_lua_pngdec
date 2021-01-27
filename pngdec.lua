-- reads file and outputs string (maybe issue with end of line char)
function pngFileToTable(location)
  local file = assert(io.open(location, "rb"))
  local out = {string.byte(file:read(1)), string.byte(file:read(1)), string.byte(file:read(1)), string.byte(file:read(1))}
  local i = 5
  -- check header
  if (out[1] == 137 and out[2] == 80 and out[3] == 78 and out[4] == 71) then
    -- check for IEND
    while not(out[i - 4] == 73 and out[i - 3] == 69 and out[i - 2] == 78 and out[i - 1] == 68) do
      out[i] = string.byte(file:read(1))
      i = i + 1
    end
    file:close()
    return out
  end
  file:close()
  return {}
end

-- splits data table into chunk positions based on headers
function chunkSplit(data, headers)
  local p_headers = {}
  for i, item in pairs(headers) do p_headers[i] = item end
  local out = {}
  for i, item in pairs(data) do
    for j, h in pairs(p_headers) do
      if (string.char(item) == h:sub(1,1)) then
        if (h:len() > 1) then
          p_headers[j] = h:sub(2)
        else
          table.insert(out, {headers[j], i})
          p_headers[j] = headers[j]
        end
      elseif not(h == headers[j]) then
        p_headers[j] = headers[j]
      end
    end
  end
  return out
end

-- given a chunks position and titles returns an array in the form {{header title, chunk length}, chunk data}
function chunkGetter(data, title, pos)
  local length = fourByteToInt(data, pos - 4 - (title:len() - 1))
  local c_dat = {}
  for i = 1, length, 1 do
    c_dat[i] = data[pos + i]
  end
  return {{title, length}, c_dat}
end
-- reads four bytes and returns big endian 32bit number
function fourByteToInt(table, pos)
  return table[pos]*256^3 + table[pos + 1]*256^2 + table[pos + 2]*256^1 + table[pos + 3]*1
end

local s = pngFileToTable("C:\\Users\\jackj\\Documents\\Repos\\test_image.png")

local c = chunkSplit(s, {"IDAT", "IHDR", "IEND", "PLTE", "tRNS", "gAMA", "pHYs", "sRGB"})

for i, k in pairs(c) do
  --print(k[1] .. ": " .. k[2])
  local dat = chunkGetter(s, c[i][1], c[i][2])
  print(dat[1][1] .. "; Length: " .. dat[1][2])
  for j = 1, dat[1][2], 1 do
    io.write(dat[2][j] .. " ")
  end
  print()
end

--[[ihdr = chunkGetter(s, c[1][1], c[1][2])
print(ihdr[1][1] .. "; Length: " .. ihdr[1][2])
for i = 1, ihdr[1][2], 1 do
  io.write(ihdr[2][i] .. " ")
end]]--

--for i = 1, 16, 1 do
--  print(s[i])
--end
