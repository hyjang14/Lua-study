-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local timeAttack
local text

function scene:create( event )
	local sceneGroup = self.view
	
-- 1차시 display object ---------------------------------------------------------------------
	local background = display.newImageRect("image/background.png", display.contentWidth, display.contentHeight)
	background.x, background.y = display.contentWidth/2, display.contentHeight/2

	local bunny = display.newImage("image/bunny.png"); --이렇게만 쓰면 0,0으로 초기화돼서 나타남
	bunny.x, bunny.y = display.contentWidth*0.3, display.contentHeight*0.6

	local ground = display.newImage("image/ground.png")
	ground.x, ground.y = display.contentWidth*0.7, display.contentHeight*0.7

	local carrotGroup = display.newGroup()
 	local carrot = {}

 	for i = 1, 5 do
 		carrot[i] = display.newImageRect(carrotGroup, "image/carrot.png", 60, 150)
 		carrot[i].x, carrot[i].y = display.contentWidth*0.55 + 60*i, display.contentHeight*0.6
	--parent에 속할 디스플레이 그룹 이름 적어주면 자동으로 들어간다(insert 나중에 쓸 필요 x)
 		--carrotGroup:insert(carrot[i])
	end
	
	local diceGroup = display.newGroup()
	local dice = {}

	for i = 1, 6 do
		dice[i] = display.newImage(diceGroup, "image/dice ("..i..").png") --..은 문자 이어주는 연산자
		dice[i].x, dice[i].y = display.contentWidth*0.5, display.contentHeight*0.25

		dice[i]:scale(2, 2) --2배로 커진다
		dice[i].alpha = 0; --투명도 0으로하면 사라진
	end
	--1부터 6까지의 정수 중 하나가 반환
	--랜덤함수: 매개변수 개수에 따라 달라지므로(setFillColor처럼) 참고문헌 보기
	dice[math.random(6)].alpha = 1 --ctrl + r(새로고침) 누를 때마다 바뀐다
 
    --점수 0 부터 시작이다 
 	local score = display.newText(0, display.contentWidth*0.1, display.contentHeight*0.15)

 	score.size = 100
 	score:setFillColor(0)
 	score.alpha = 0.5

 	--타이머 추가하기 (10부터 시작하도록 한다 )
 	local time = display.newText(10, display.contentWidth*0.9, display.contentHeight*0.15)

	time.size = 100
 	time:setFillColor(0)
 	time.alpha = 0.5

 	--레이어 정리
 	sceneGroup:insert(background)
 	sceneGroup:insert(bunny)
 	sceneGroup:insert(carrotGroup)
 	sceneGroup:insert(ground)
 	--sceneGroup:insert(carrotGroup)
 	sceneGroup:insert(diceGroup)
 	sceneGroup:insert(score)
 	sceneGroup:insert(time)

 	--ground:toFront() --앞으로 빼기
 	--혹은 위에 sceneGroup을 ground랑 carrotGroup 순서만 바꿔도 됨

 	-- 2차시 Event ---------------------------------------------------------------------
 	--<주사위 터치해서 눈 바꾸기>
 	local function tapDice( event )
 		for i = 1, 6 do
 			dice[i].alpha = 0 --모든 주사위 투명도 0으로 설정
 		end
 		dice[math.random(6)].alpha = 1
 	end

 	diceGroup:addEventListener("tap", tapDice) 
 	--주사위 터치할 때마다 주사위 눈이 바뀐다


 	--<당근 드래그하기>
 	local function dragCarrot( event )
 		if( event.phase == "began" ) then
 			display.getCurrentStage():setFocus( event.target )
 			event.target.isFocus = true
 			-- 드래그 시작할 때
 			event.target.initX = event.target.x --처음 x위치값 저장해두기
 			event.target.initY = event.target.y --처음 y위치값 저장해두기
 		elseif( event.phase == "moved" ) then

 			if ( event.target.isFocus ) then
 				-- 드래그 중일 때
 				event.target.x = event.xStart + event.xDelta
 				event.target.y = event.yStart + event.yDelta
 			end

 		elseif ( event.phase == "ended" or event.phase == "cancelled") then
 			if ( event.target.isFocus ) then
 				display.getCurrentStage():setFocus( nil )
 				event.target.isFocus = false
 				-- 드래그 끝났을 때
 				--<당근을 토끼에게 주기>
 				if(event.target.x > bunny.x - 50 and event.target.x < bunny.x + 50
 					and event.target.y > bunny.y - 50 and event.target.y < bunny.y + 50) then

 					display.remove(event.target) --당근 없애기 
 					score.text = score.text + 1 --점수 올라가게 하기

 					if(score.text == '5') then
 						score.text = '성공!'
 						time.alpha = 0 --성공이라고 뜨고 타이머 없어진다

 						audio.stop()

 						composer.setVariable("text", '성공!')
 						composer.gotoScene('ending')
 					end

 				else
 					event.target.x = event.target.initX
 					event.target.y = event.target.initY
 					--원래는 event.target.x = event.xStart
 					--당근을 엉뚱한 곳에 놓으면 원위치 시키기
 				end
 			else
 				display.getCurrentStage():setFocus( nil )
 				event.target.isFocus = false
 			end
 		end
 	end

 	for i = 1, 5 do
 		carrot[i]:addEventListener("touch", dragCarrot)
 		--당근 1번부터 5번까지 다 추가해
 	end

 	local function counter( event )
 		time.text = time.text - 1

 		if(time.text == '5') then
 			time:setFillColor(1, 0, 0)
 		end

 		if(time.text == '-1') then
 			time.alpha = 0

 			--성공이 아니라면(실패했을 때) 
 			if(score.text ~= '성공!') then 
 				score.text = '실패!'
 				bunny:rotate(90) --90도 돌리기(토끼 쓰러지게 하기 )

 				--게임 끝나면 당근 못 움직이게 당근에 씌었던 drag함수 사라지게 하기 
 				for i = 1, 5 do
 					if(carrot[i] ~= nil) then
 						--carrot[i]:removeEventListener("touch", dragCarrot)
 						display.remove(carrot[i]) 
 					end
 				end

 				audio.stop()
 				composer.setVariable("text", '실패!')
 				composer.gotoScene('ending')
 			end
 		end
 	end
 	-- -1까지 할거라 11번 반복한다. (실패까지 띄울거라서 )
 	timeAttack = timer.performWithDelay(1000, counter, 11)
 
 	--설정 버튼 생성하기 
 	local setting = display.newText("설정", display.contentWidth*0.8, display.contentHeight*0.15)
 	setting.size = 50
 	setting:setFillColor(0.3)

 	function setting:tap( event )
 		timer.pause(timeAttack) --타이머 일시정지 
 		composer.setVariable("timeAttack", timeAttack) --timeAttack으로 timeAttack 변수값 넘기기 
 		composer.showOverlay('setting')
 		--gotoScene하면 뒤에 게임화면 사라지고 검정바탕에 설정창만 뜸 
 	end
 	setting:addEventListener("tap", setting)

 	--배경음악 삽입하기--
 	local audio = require("audio")
 	local sound = audio.loadSound("music1.mp3")
 	audio.play(sound)

 	sceneGroup:insert(setting)
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

		composer.removeScene('game') --다른씬으로 넘어갈때 game.lua가 삭제되게끔 
		timer.cancel(timeAttack) --타이머는 씬 전환되도 계속진행돼서 타이머 끝나도록함 
		--타이머 없애야 오류가 안 난다

		--will이 먼저 실행되고 did가 실행되다보니까 이미지가 조금 깨진다  
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
