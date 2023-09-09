-----------------------------------------------------------------------------------------
--
-- rectangle.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	
	local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	-- background:setFillColor(1, 0, 0, 0.5) --alpha는 투명도
	-- background.alpah = 0.5 --따로 설정도 가능

	-- background.x = background.x + 100 --lua는 연산자 풀어서 쓰기
	-- background.x = background.y - 100

	-- background:scale(0.5, 0.5);

	local object = {}

	object[1] = display.newRect(display.contentCenterX, display.contentCenterY, 500, 500)
	object[1]:setFillColor(1, 0, 0) --빨강색
	--object[1].width = object[1].width - 100

	object[2] = display.newRect(display.contentCenterX, display.contentCenterY, 300, 300)
	object[2]:setFillColor(1, 0.5, 0) --주황색

	object[3] = display.newRect(display.contentCenterX, display.contentCenterY, 100, 100)
	object[3]:setFillColor(1, 1, 0) --노란색

	local objectGroup = display.newGroup()
	objectGroup:insert(object[1])
	objectGroup:insert(object[3])
	objectGroup:insert(object[2])

	object[3]:toFront() --맨 앞으로 오는 함수
	-- object:toBack() //뒤로 보내는 함

	--그룹 단위로 옮기기
	objectGroup.x = objectGroup.x + 100
	objectGroup.y = objectGroup.y - 100

	--특별한 경우가 아니라면 sceneGroup에 속하도록 한다
	sceneGroup:insert(background)
	sceneGroup:insert(objectGroup)

	-- local function tapEventListener(event) --eventListner 함수 만들기 
	-- 	print("클릭!!!") --클릭할 때마다 콘솔창에 이 문구 나온
	-- end
	-- object[3]:addEventListener("tap", tapEventListener)

	-- --object[3].alpha = 0 --투명도가 0이면 이벤트가 나타나지 않는다.
	-- --object[2]:toFront() --이때는 object[3]가 클릭이 된다
-----------------------------------------------------------------------
	-- local function touchEventListener( event )
 -- 		if( event.phase == "began" ) then
 -- 			print("터치를 시작함")
 -- 		elseif( event.phase == "moved" ) then
 -- 			print("객체를 누르고 있는 상태로 움직임(드래그)")
 -- 		elseif ( event.phase == "ended" or event.phase == "cancelled") then
 -- 			print("터치가 끝남")
 -- 		end
 -- 	end
 
 -- 	object[3]:addEventListener("touch", touchEventListener)
------------------------------------------------------------------------
	local function drag( event )
 		if( event.phase == "began" ) then
 			display.getCurrentStage():setFocus( event.target )
 			event.target.isFocus = true
 			-- 드래그 시작할 때

 		elseif( event.phase == "moved" ) then

 			if ( event.target.isFocus ) then
 				-- 드래그 중일 때
 				event.target.x = event.xStart + event.xDelta - event.target.parent.x
 				--xStart는 처음 x값, xDelta는 마우스가 이동한 정도
 				--object가 마우스를 따라가게됨
 				--위에서 그룹단위로 옮긴만큼 빼주기(- event.target.parent.x)
 				--ctrl-r 새로고
 				event.target.y = event.yStart + event.yDelta - event.target.parent.y
 			end

 		elseif ( event.phase == "ended" or event.phase == "cancelled") then
 			if ( event.target.isFocus ) then
 				display.getCurrentStage():setFocus( nil )
 				event.target.isFocus = false
 				-- 드래그 끝났을 때
 			else
 				display.getCurrentStage():setFocus( nil )
 				event.target.isFocus = false
 			end
 		end
 	end

 	local function tapRec( event )
 		print("터치되었습니다!")
 		--object[3].x = object[3].x + math.random(-180, 180)
 		--object[3].y = object[3].y + math.random(-180, 180)

 		--if(object[3].x > 0 and object[3].x < background
 			--and object[3].y > 0 and object[3].y < 800) then
 			object[3].x = object[3].x + math.random(-180, 180)
 			object[3].y = object[3].y + math.random(-180, 180)
 		--end

 		--if(object[3].x <= 0 or object[3].x > background.contentWidth
 			--or object[3].y <= 0 or object[3].y >= background.contentHeight)
 			--object[3].x = 0
 		   -- object[3].y = 0
 		--end

 	end

 	--object[3] = display.newRect(display.contentCenterX, display.contentCenterY, math.random(100), math.random(100))
 	object[3]:addEventListener("tap", tapRec) 

 	-- local function alarm(event)
 	-- 	print("1초 뒤입니다.")
 	-- end

 	-- local timeAttack = timer.performWithDelay(1000, alarm) 
 	--1초가 1000, 2초가 2000
 	--여기서 생성된 타이머를 timeAttack에 담아둔다
	--timer.cancle( timerName ): 정지
	--timer.pause( timerName ): 일시 정지
	--timer.resume( timerName ): 재시작

	local count = 1
	local function counter(event)
		print(count.."초가 지났습니다.")
		count = count + 1 
	end

	local timeAttack = timer.performWithDelay(1000, counter, 10) 
	--0 또는 -1은 무한반복

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then --화면에 보여지기 직전에 실행 
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then --화면에 보여지는 직후에 실행  
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then --사라지기 직전에 실행  
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then --사라진 직후에 실행 
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