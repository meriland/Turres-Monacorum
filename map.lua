function love.turris.newMap(width, height, tileWidth, tileHeight)
	local o = {}
	o.width = width or 16
	o.height = height or 16
	o.tileWidth = tileWidth or 64
	o.tileHeight = tileHeight or 48
	o.data = {}
	for i = 1, o.width do
		o.data[i] = {}
		for k = 1, o.height do
			o.data[i][k] = {}
			o.data[i][k].id = 0
			o.data[i][k].maxHealth = 100.0
			o.data[i][k].health = o.data[i][k].maxHealth
		end
	end
	o.shadow = {}
	local img = love.graphics.newImage("gfx/ground01.png")
	local normal = love.graphics.newImage("gfx/ground01_normal.png")
	local glow = love.graphics.newImage("gfx/ground01_glow.png")
	o.shadowGround = lightWorld.newImage(img, o.width * o.tileWidth, o.height * o.tileHeight, o.width * o.tileWidth * 0.5, o.height * o.tileHeight * 0.5)
	o.shadowGround.setNormalMap(normal, o.width * o.tileWidth, o.height * o.tileHeight)
	o.shadowGround.setPosition(o.width * o.tileWidth * 0.5, o.height * o.tileHeight * 0.5)
	--o.shadowGround.setGlowMap(glow)
	o.shadowGround.setShadow(false)
	for i = 0, o.width - 1 do
		o.shadow[i + 1] = {}
		for k = 0, o.height - 1 do
			o.shadow[i + 1][k + 1] = lightWorld.newImage(img, i * o.tileWidth + o.tileWidth * 0.5, k * o.tileHeight + o.tileHeight * 0.5, o.tileWidth, o.tileHeight)
			o.shadow[i + 1][k + 1].setShadow(false)
			--o.shadow[i + 1][k + 1].setNormalMap(normal)
			--o.shadow[i + 1][k + 1].setGlowMap(glow)
		end
	end
	o.getState = function(x, y)
		if x and y and x>0 and y>0 then
			return o.data[x][y].id
		else
			return nil
		end
	end
	o.getHeight = function()
		return o.height
	end
	o.getMap = function()
		return o
	end
	o.getTileHeight = function()
		return o.tileHeight
	end
	o.getTileWidth = function()
		return o.tileWidth
	end
	o.getWidth = function()
		return o.width
	end
	o.setState = function(x, y, n)
		print(x, y, n)
		local d = o.data[x][y]
		d.id = n
		if n > 0 then
			o.shadow[x][y].setImage(turGame.towerType[n].img)
			o.shadow[x][y].setImageOffset(o.tileWidth * 0.5, o.tileHeight * 0.5 + (turGame.towerType[n].img:getHeight() - o.tileHeight))
			o.shadow[x][y].setNormalMap(turGame.towerType[n].normal)
			o.shadow[x][y].setNormalOffset(o.tileWidth * 0.5, o.tileHeight * 0.5 + (turGame.towerType[n].img:getHeight() - o.tileHeight))
			o.shadow[x][y].setGlowMap(turGame.towerType[n].glow)
			o.shadow[x][y].setShadow(true)
		else
			o.shadow[x][y].setNormalMap(nil)
			o.shadow[x][y].setGlowMap(nil)
			o.shadow[x][y].setShadow(false)
		end
	end

	return o
end