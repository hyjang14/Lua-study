-----------------------------------------------------------------------------------------
--
-- intro.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	
	-- BACKGROUND
	local bg = {}
	
	bg[1] = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight)
	
	bg[2] = display.newImage("image/background.png")
	bg[2].x, bg[2].y  = display.contentWidth, display.contentHeight*0.5
	bg[2]:scale( 2, 2 )

	local logo = display.newImage("image/logo.png")
	logo.x, logo.y  = display.contentWidth*0.5, display.contentHeight*0.15
	logo:scale( 2, 2 )

	-- DIALOG
	local dialog = display.newGroup()

	local image = display.newRect(dialog, display.contentWidth*0.15, display.contentHeight*0.75, 200, 200)
	
	local speaker = display.newText(dialog, "캐릭터 이름", display.contentWidth*0.35, display.contentHeight*0.67, display.contentWidth*0.2, display.contentHeight*0.1)
	speaker:setFillColor(0)
	speaker.size = 50

	local content = display.newText(dialog, "솰라솰라 불라불라", display.contentWidth*0.6, display.contentHeight*0.85, display.contentWidth*0.7, display.contentHeight*0.2)
	content:setFillColor(0)
	content.size = 30


	-- json에서 정보 읽기
	local Data = jsonParse("json/intro.json")
	if(Data) then --콘솔창에 출력해서 확인해보기 
		print(Data[1].speaker)
		print(Data[1].content)
		print(Data[1].image)
	end

	-- json에서 읽은 정보 적용하기
	local index = 0

	local function nextScript( event )
		index = index + 1

		if(index > #Data) then
			composer.gotoScene("home") --홈화면으로 돌아가기 
			return
		end

		speaker.text = Data[index].speaker
		content.text = Data[index].content  
		image.fill = {
			type = "image",
			filename = Data[index].image
		}
		
	end
	--하얀색 네모 클릭하면 함수 실행하게끔 하기 
	bg[1]:addEventListener("tap", nextScript)

	nextScript() --처음에는 함수 호출해서 첫번째 장면 보여지게끔 하기 

	function logo:tap( event )
		composer.gotoScene("home")
	end
	logo:addEventListener("tap", logo)

	sceneGroup:insert(bg[1])
	sceneGroup:insert(bg[2])
	sceneGroup:insert(logo)
	sceneGroup:insert(dialog)
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
		composer.removeScene("intro")
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
