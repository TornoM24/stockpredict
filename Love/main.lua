--Libraries required
require "fileread"
Menu = require "menu"
--
stockData = {}
stockDates = {}

stockRendered = false

fullscreen = false

menuState = "no"

os.setlocale("C")

function abs(x)
  assert(type(x) == "number", "abs expects a number")
  return x >= 0 and x or -x
end
function Reverse (arr)
	local i, j = 1, #arr

	while i < j do
		arr[i], arr[j] = arr[j], arr[i]

		i = i + 1
		j = j - 1
	end
end

function love.filedropped(file)
	local index = 1
		for line in (file):lines() do
    		--stockData[index] = line
    		--stockData[index] = tostring (stockData[index])
    		--string.format (stockData[index])
    		stockData[index] = line
    		local buf = tonumber (stockData[index])
    		stockData [index] = buf
    		index = index + 1
    	end
	Reverse (stockData)
	Reverse (stockDates)

	stockRendered = true 
end
function renderGraph ()
	local index = 1
	local y = 1
	for index = 1,22,1 do
		for indexBuffer = 0.1,1,0.1 do
			stockBufX = stockData [index]
			stockBufY = stockData [index + 1]
			--print (stockBufX)
			--print ("Drawing from "..index * indexBuffer..","..stockData[index]  * indexBuffer.." to "..(index + 1) * indexBuffer..","..stockData[index + 1]  * indexBuffer)
			--love.graphics.line(index * indexBuffer, stockData[index]  * indexBuffer , (index + 1) * indexBuffer, stockData[index + 1]  * indexBuffer)
			
			love.graphics.line (30, 0, 30, 500)
			love.graphics.line (30, 500, 690, 500)
			love.graphics.line (index * 30, 1000 - stockBufX * 6, (index + 1) * 30, 1000 - stockBufY * 6)
			--love.graphics.line (0,0,400,400)
		end
	end
end
--function convertData (string)
  --  local newData = data
--end
avg = 0
divergence = 0
increases = 0
decreases = 0
function predictOutcome ()
	local index = 1

	for index = 1, 23, 1 do 
		avg = avg + stockData[index]
		if index > 1 then 
			print ("checking - "..stockData[index].." vs. "..stockData[index - 1])
			if stockData[index] > stockData [index - 1] then
				increases = increases + 1
				print ("increased to "..increases)
			else
				decreases = decreases + 1
				print ("decreased to "..decreases)
			end
		end
	end
	avg = avg / 23
	divergence = stockData[index] - avg

	menuState = "predict"
end

function love.quit()
	return quit
end
function love.load()
	testmenu = Menu.new()
	testmenu:addItem{
		name = 'Predict',
		action = function()
			predictOutcome()
		end
	}
	testmenu:addItem{
		name = 'Advise',
		action = function()
			menuState = "advise"
		end
	}
	testmenu:addItem{
		name = 'Quit',
		action = function()
			love.quit()
		end
	}
end
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
function love.update(dt)
	testmenu:update(dt)
end

function love.draw()
    if not stockRendered then 
    	love.graphics.print("Please drag your stock file onto the screen now.", 200, 300)
    	love.graphics.print("Ensure that the file is a list of 23 stock prices in the last month.", 200, 315)
    end

	if stockRendered == true then 
		renderGraph() 
		testmenu:draw(300, 10)
		if menuState == "predict" then
			love.graphics.print ("A stock divergence of $"..round(divergence,2).." has been calculated.", 300, 100)
			--increase = stockGraph [23] - stockGraph [22]
			local incChance
			local decChance
			local unknown
			local rI
			if stockData [23] - stockData [22] > 0 then
				rI = true
			else
				rI = false
			end
			incChance = 100 * (increases / 23 * 0.5)
			decChance = 100 * (decreases / 23 * 0.5)
			unknown = 100 - incChance - decChance

			love.graphics.print ("The chances of increasing are "..round(incChance,2).."%.", 300, 115)
			love.graphics.print ("The chances of decreasing are "..round(decChance,2).."%.", 300, 130)
			love.graphics.print ("The chances of an unknown fluctuation are "..round(unknown,2).."%.", 300, 145)
		end

			--if divergence > 0 then 
				--love.graphics.print ("It is recommended that you invest now, or stay invested." 300, 450)
			--else
				--love.graphics.print ("It is recommended that you sell your stocks, or wait to invest." 300, 450)
			--end
	end
end

function love.keypressed(key)
	testmenu:keypressed(key)
end

--NOTES

-- +0.8 increase in 13 increases
-- -1.56 decrease in 10 descreases
-- -1.13 average of all
-- assessment MUST be risky