local points = {}
local currentLength = 1
local magnitudes = {}
local cascade = 0

local wait = 0

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local cx = width / 2
local cy = height / 2

for i = 1, 100 do
	points[i] = {cx, cy}
	magnitudes[i] = 0
end

function love.load()
	love.filesystem.setIdentity('circle');
end

function love.update(dt)
	currentLength = currentLength + (dt * 5 * (math.pow(currentLength, 1.25)))

	if currentLength >= 500 then
		wait = wait + dt

		if wait > 0.5 then
			currentLength = 500

			if cascade <= #points then
				cascade = cascade + (dt * 30)
			end

			for i = 1, math.floor(cascade) do
				magnitudes[i] = magnitudes[i] + (dt * 2)

				if magnitudes[i] > 1 then
					magnitudes[i] = 1
				end
			end
		end
	 else
		 for i, v in ipairs(points) do
			 points[i][1] = cx + (currentLength * math.cos(i * ((2 * math.pi) / #points)))
			 points[i][2] = cy + (currentLength * math.sin(i * ((2 * math.pi) / #points)))
		 end
	end
end

function love.draw()
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)

	for i, v in ipairs(points) do
		love.graphics.circle("fill", v[1], v[2], 1, 100)

		if i < cascade then
			local end_idx = i + math.floor(0.25 * #points)

			if end_idx > #points then
				end_idx = end_idx - #points
			end

			local dx = points[i][2] - points[end_idx][2]
			local dy = points[i][1] - points[end_idx][1]
			local hyp = -math.sqrt(dx^2 + dy^2) * magnitudes[i]
			local theta = math.atan2(dx, dy)

			love.graphics.line(points[i][1], points[i][2], points[i][1] + (hyp * math.cos(theta)), points[i][2] + (hyp * math.sin(theta)))
		end
	end
end

function love.keypressed()
    local screenshot = love.graphics.newScreenshot();
    screenshot:encode('png', os.time() .. '.png');
end
