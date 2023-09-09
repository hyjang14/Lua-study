-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

-- include Corona's "widget" library
local widget = require "widget"
local composer = require "composer"


-- event listeners for tab buttons:
local function onFirstView( event ) 
	composer.gotoScene( "game" )--첫번째로 불러올 루아 파일 이름
end



onFirstView()	-- invoke first tab button's onPress event manually
