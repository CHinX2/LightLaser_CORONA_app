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
scene:addEventListener( "create", scene )   --�����ɥ��Q�I�s���a��A�i�H�[�J�����ݭn������H�ά۹��������
scene:addEventListener( "show", scene )     --�����n�}�l�B�@���i�J�I�A�b�o�̥i�H�[�J�ݭn������ʧ@
scene:addEventListener( "hide", scene )     --�����n�Q�����ɷ|�I�s�A�]�N�O�n���}������
scene:addEventListener( "destroy", scene )  --�����Q�����ɩI�s

-- -------------------------------------------------------------------------------

return scene