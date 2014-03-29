require "postshader"
require "light"
<<<<<<< HEAD
require "world"
require "game"
require "map"
=======
require "sound"
require "TESound"
>>>>>>> Added SoundManager and Sound "Class"

function love.load()
	G = love.graphics
	W = love.windows
	T = love.turris

	turGame = love.turris.newGame()
	turMap = love.turris.newMap(20, 20)
	print(turMap.getWidth())
end

function love.update(dt)
<<<<<<< HEAD
	turMap.setState(4, 3, 1)
	turGame.setMap(turMap.getMap())
=======
	TEsound.cleanup()  --Important, Clears all the channels in TEsound
>>>>>>> Added SoundManager and Sound "Class"
end

function love.draw()
	turGame.drawMap()
end

function love.mousepressed(x, y, key)
	
end

function love.keypressed(key, code)
	
	--Start Sound
	if key == "1" then
		love.sounds.addSound("sounds/Explosion.wav")
	end
	
	if key == "2" then
		love.sounds.background("sounds/Explosion.wav")
	end
end