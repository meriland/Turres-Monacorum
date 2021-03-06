require "ai/ai"

function getAllNodes(map)
	local w = map.width
	local h = map.height
	local nodes = {}

	local k = 1
	for i = 0, w do
		for j = 0, h do
			nodes[k]= {x=i,y=j,id=k}
			k = k + 1
		end
	end
	return nodes
end

function findNode(nodes, x, y)
	for i = 1, #nodes do
		if nodes[i].x == x and nodes[i].y == y then
			return nodes[i]
		end
	end
end

function love.turris.newEnemy(img, map, x,y,baseX, baseY)
	local o = {}
	o.generateWaypoints = function(map, startX, startY, goalX, goalY)
		local all_nodes = getAllNodes(map)
		local start = findNode(all_nodes, startX, startY)
		local goal = findNode(all_nodes, goalX, goalY)
		local path = aStar(start,goal,all_nodes)

		local wp = {{startX,startY},{goalX,goalY}}
		if path then
			for i = 1, #path do
				wp[i] ={path[i].x,path[i].y}
			end
		end
		return wp
	end
	o.img = img
	o.x = x
	o.y = y
	o.dead = false
	o.waypoints = o.generateWaypoints(map,x,y,baseX,baseY)

	o.currentWaypoint = 2
	o.health = 100.0

	-- TODO this depends on the type and not on the particular enemy
	o.maxHealth = 100.0
	o.speed = 1.0
	-- type end

	--o.shadow = {}
	--o.shadow = lightWorld.newImage(o.img)
	--o.shadow.setShadowType("image",32,32, 1.0)

	o.updateVelocity = function(dirX,dirY)
		o.xVel = dirX*o.speed
		o.yVel = dirY*o.speed
	end

	o.getDirection = function()
		return math.atan2(o.xVel, o.yVel)
	end

	o.updateVelocity(1,0) --TODO this should be determined from the current position to the next waypoint

	o.getOrientation = function()
		local x,y = love.turris.normalize(o.xVel, o.yVel)
		return x,y
	end

	return o
end

function love.turris.normalize(x,y)
	local m = math.max(math.abs(x),math.abs(y))
	--print ("normalize: ", x, y, m)
	local xRet = x/m
	local yRet = y/m
	if (xRet ~= xRet) then
		print ("xRet NaN: ",xRet)
	end
	if (yRet ~= yRet) then
		print ("yRet NaN: ",yRet)
	end
	return xRet, yRet
end

function love.turris.updateEnemies(o,dt)
	for i = 1, o.enemyCount do
		local e = o.enemies[i]
		e.x = e.x+e.xVel*dt
		e.y = e.y+e.yVel*dt

		local x = e.x
		local y = e.y

		-- check if waypoint reached
		local wp = e.waypoints[e.currentWaypoint]
		if math.abs(wp[1]-x)<0.1 and math.abs(wp[2] -y)<0.1 then
			-- waypoint reached
			local nextWpIndex = e.currentWaypoint +1
			e.currentWaypoint = nextWpIndex
			local wpNext = e.waypoints[nextWpIndex]
			local dirX,dirY = love.turris.normalize( wpNext[1]-wp[1], wpNext[2]-wp[2])
			e.updateVelocity(dirX,dirY)
		end

		-- write back the changes
		o.enemies[i]= e
		-- check for and handle game over
		if distance_manhattan(o.baseX, o.baseY,x,y) < 1 then
			e.dead = true
			-- Game Over!!! (for now)
			-- TODO: destroy ship (explosion)
			-- TODO: destroy base (explosion!)
			-- TODO: after explosions have finished -> transition to game over state
			love.sounds.playSound("sounds/einschlag.mp3")
			love.setgamestate(4)
			gameOverEffect = 0
		end
	end
end