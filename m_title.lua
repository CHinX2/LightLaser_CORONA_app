----------------------------------
-- Producer : CHinX2 
-- Finish : 2017 06 13
----------------------------------
-- Title
----------------------------------

local composer  = require( "composer" ) 
local widget    = require( "widget" ) 
local movieclip = require( "movieclip" )
local physics   = require( "physics" )
physics.start()                    
physics.setGravity( 0, 0 )


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
    composer.removeScene("mlist")

    if ( phase == "will" ) then 
    
    elseif ( phase == "did" ) then 
    
        local shoot = audio.loadSound( "shoot.wav" )
        local hit = audio.loadSound( "hit.wav" )
        
        --add title
        local title = display.newImageRect(sceneGroup, "images/title.png", 250, 80 )
        physics.addBody( title, "static")
        title.x = display.contentCenterX
        title.y = display.contentCenterY - 120
        
        --add turret
        local turret = display.newImageRect( sceneGroup,"images/turret.png", 48, 55 )
        physics.addBody( turret, "static", { radius=18 } )
        turret.x = display.contentCenterX
        turret.y = display.contentCenterY+120
        turret.rotation = 0
        
        local function drawBeam( startX, startY, endX, endY )
        -- Draw a series of overlapping lines to represent the beam
          local beam1 = display.newLine( sceneGroup, startX, startY, endX, endY )
          beam1.strokeWidth = 2 ; beam1:setStrokeColor( 1, 0.312, 0.157, 1 ) ; beam1.blendMode = "add" ; beam1:toBack()
          local beam2 = display.newLine( sceneGroup, startX, startY, endX, endY )
          beam2.strokeWidth = 4 ; beam2:setStrokeColor( 1, 0.312, 0.157, 0.706 ) ; beam2.blendMode = "add" ; beam2:toBack()
          local beam3 = display.newLine( sceneGroup, startX, startY, endX, endY )
          beam3.strokeWidth = 6 ; beam3:setStrokeColor( 1, 0.196, 0.157, 0.392 ) ; beam3.blendMode = "add" ; beam3:toBack()
          
        end
        
        local function press_go(event)
                  audio.play( shoot )
                  drawBeam(turret.x,turret.y,title.x,title.y+38);
                  audio.play( hit )
                  local Forest = movieclip.newAnim({"images/explode1.png","images/explode2.png","images/explode3.png","images/explode4.png","images/explode5.png","images/explode6.png","images/explode7.png","images/explode8.png","images/explode9.png"})
                  Forest:play({startFrame=1,endFrame=9,loop=1,remove=true})
                  Forest.x,Forest.y = title.x,title.y 
                  Forest.width,Forest.height=250,250
                  Forest:setDrag{drag=true}
                  audio.dispose( shoot )
                  audio.dispose( hit )
                  
                  composer.gotoScene("mlist",{ time=300, effect="fade" } )
        end
        
        --add tap-to continue
        local tapp = display.newImageRect( sceneGroup, "images/tap.png", 600, 1000 )
        tapp.x = display.contentCenterX
        tapp.y = display.contentCenterY + 100
             
        tapp:addEventListener( "tap", press_go ) 
        

 
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then 
    elseif ( phase == "did" ) then
        composer.removeScene("m_title")
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