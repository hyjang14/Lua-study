-----------------------------------------------------------------------------------------
--
-- setting.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()


function scene:create( event )
	local sceneGroup = self.view
	
 	local background = display.newRoundedRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth/2, display.contentHeight*0.6, 55)
 	background.strokeWidth = 10
	background:setStrokeColor( 0.4, 0.2, 0.2 )
 	background:setFillColor(0.6, 0.5, 0.5)

 	local title = display.newText("Setting", display.contentWidth/2, display.contentHeight*0.3)
 	title.size = 70

 	--title 제목을 누르면 사라지게끔 한다. 
 	function title:tap( event )
 		local timerAttack = composer.getVariable("timeAttack")
 		timer.resume(timerAttack) --다시 실행하게끔 

 		composer.hideOverlay('setting')
 	end
 	title:addEventListener("tap", title)

 	sceneGroup:insert(background)
 	sceneGroup:insert(title)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.

	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen

	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene