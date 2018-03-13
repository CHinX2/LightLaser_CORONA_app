----------------------------------
-- Producer : CHinX2 
-- Finish : 2017 06 13
----------------------------------
-- Ending
----------------------------------

local composer  = require( "composer" )
local widget    = require( "widget" )
local movieclip = require( "movieclip" )

local scene = composer.newScene() 

------------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
------------------------------------------------------------------------------------------------------------------

function scene:create( event )

    local sceneGroup = self.view 

    local background = display.newImageRect( sceneGroup, "images/bg.png", 800, 1000 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    
end


function scene:show( event ) 

    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then  
 
    elseif ( phase == "did" ) then 
    
        local function press_go(event)
          audio.stop() --stop all music
          composer.gotoScene("m_title",{ time=500, effect="fade" } )
        end   
        
        local function b_add(event)
             local tapp = display.newImageRect( sceneGroup, "images/tap.png", 600, 1000 )
             tapp.x = display.contentCenterX
             tapp.y = display.contentCenterY + 100
             
             tapp:addEventListener( "tap", press_go ) 
        end
        
        local function n_add(event)
             --show Name
             local nam = display.newImageRect(sceneGroup, "images/name.png", 280, 120 )
             nam.x = display.contentCenterX
             nam.y = display.contentCenterY
             
             --wait 3 sec than show tap-to-continue
             timer.performWithDelay( 3000, b_add)
        end
             
        --show Congraduration
        local con = display.newImageRect(sceneGroup, "images/allclear.png", 300, 30 )
        con.x = display.contentCenterX
        con.y = display.contentCenterY - 120
        
        -- wait 2 sec than show name
        timer.performWithDelay(2000,n_add)
        

 
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then 
    elseif ( phase == "did" ) then 
        composer.removeScene("m_end")
    end
end

function scene:destroy( event )

        local sceneGroup = self.view   
        sceneGroup:removeSelf() 
        sceneGroup = nil
        
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )   --場景時先被呼叫的地方，可以加入場景需要的物件以及相對應的函數
scene:addEventListener( "show", scene )     --場景要開始運作的進入點，在這裡可以加入需要的執行動作
scene:addEventListener( "hide", scene )     --場景要被切換時會呼叫，也就是要離開場景時
scene:addEventListener( "destroy", scene )  --場景被移除時呼叫

-- -------------------------------------------------------------------------------

return scene