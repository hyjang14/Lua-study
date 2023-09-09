-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- json parsing 함수 작성 
local json = require "json"

function jsonParse( src )
	local filename = system.pathForFile( src )

	local data, pos, msg = json.decodeFile( filename )
	--pos, msg는 json 파일에 오류가 있을 때 몇 번째 줄에 어떤 오류가 있는지
	--정보를 받아오게 됨 

	if( data ) then
		return data
	else
		print("WARNING: " .. pos, msg)
		return nil
	end
end

-- 

local composer = require "composer"

local function onFirstView( event )
	composer.gotoScene( "home" )
end

onFirstView()
