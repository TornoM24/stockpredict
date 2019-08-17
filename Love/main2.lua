-- http://lua-users.org/wiki/FileInputOutput

-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then
    love.graphics.print("bruh", 400, 300)
    return {} 
  end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

-- tests the functions above
 file = 'test.lua'
 lines = lines_from(file)

-- print all line numbers and their contents
function love.draw ()
-- print all line numbers and their contents
for k,v in pairs(lines) do
  love.graphics.print('line[' .. k .. ']'..v, 400, 300)
end
end