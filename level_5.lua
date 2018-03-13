----------------------------------
-- Producer : CHinX2 
-- Finish : 2017 06 13
----------------------------------
-- Special Thanks to Brent Sorrentino's Tutorial
-- https://coronalabs.com/blog/2013/05/07/physics-raycasting-and-reflection/
-- https://github.com/coronalabs/samples-coronasdk
----------------------------------
-- Level 5
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
    
    ----------------------------
    -- add buttom to next level
    ----------------------------
    local b_Press = function( event )      
        composer.gotoScene("mlist",{ time=500, effect="fade" } )
    end

    local button = widget.newButton
    {
        defaultFile = "images/bMain.png", 
        overFile = "images/bMaino.png",
        onPress = b_Press,                        
    }
    button.width = 70
    button.height = 45
    button.x = 280; button.y = 5
    sceneGroup:insert(button)
        
       
end

function scene:show( event ) 

    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then   
        
    elseif ( phase == "did" ) then 
        local shoot = audio.loadSound( "shoot.wav" )
        local hit = audio.loadSound( "hit.wav" )
        --------------------------
        --  add mirror
        --------------------------  
        local mirrorSet = {
           { -50, -30, 0,"images/wall.png", 20, 150 },
        }

        local mirrors = {}

    -- Static mirror
        for m = 1,#mirrorSet do
           local mirror = display.newImageRect( sceneGroup, mirrorSet[m][4] , mirrorSet[m][5], mirrorSet[m][6] )
           physics.addBody( mirror, "static", 
           { shape={-(mirrorSet[m][5]/2-1),
                    -(mirrorSet[m][6]/2-1),
                    (mirrorSet[m][5]/2-1),
                    -(mirrorSet[m][6]/2-1),
                    (mirrorSet[m][5]/2-1),
                    (mirrorSet[m][6]/2-1),
                    -(mirrorSet[m][5]/2-1),
                    (mirrorSet[m][6]/2-1)} }  )
           mirror.x = display.contentCenterX + mirrorSet[m][1]
           mirror.y = display.contentCenterY + mirrorSet[m][2]
           mirror.rotation = mirrorSet[m][3]
           mirrors[m] = mirror
        end
        
        ------------------------
        -- Dynamic mirror   
        ------------------------ 
        local mirror_d = display.newImageRect( sceneGroup, "images/mirror.png", 20, 50 )
        physics.addBody( mirror_d, "static", { shape={-9,-24,9,-24,9,24,-9,24} } )
        mirror_d.x = display.contentCenterX + 105
        mirror_d.y = display.contentCenterY + 60
        mirror_d.rotation = 0
        
        local mirror_d2 = display.newImageRect( sceneGroup, "images/mirror.png", 20, 50 )
        physics.addBody( mirror_d2, "static", { shape={-9,-24,9,-24,9,24,-9,24} } )
        mirror_d2.x = display.contentCenterX + 105
        mirror_d2.y = display.contentCenterY
        mirror_d2.rotation = -20

        
        ------------------------
        -- add paddle
        ------------------------
        local paddle = display.newImageRect( sceneGroup,"images/box.png", 30, 30 )
        paddle.x = display.contentCenterX -75
        paddle.y = display.contentCenterY -10
        physics.addBody( paddle, "static", { density=1, friction=0.3, bounce=0.7 } )
        
        -------------------------
        -- paddle remove function
        -------------------------
        local switch_1 = 0
        
        local function onColl(x)
                  audio.play( hit )
                  local Forest = movieclip.newAnim({"images/explode1.png","images/explode2.png","images/explode3.png","images/explode4.png","images/explode5.png","images/explode6.png","images/explode7.png","images/explode8.png","images/explode9.png"})
                  Forest:play({startFrame=1,endFrame=9,loop=1,remove=true})
                  Forest.x,Forest.y = paddle.x,paddle.y 
                  Forest.width,Forest.height=150,150
                  Forest:setDrag{drag=true}
                  paddle:removeSelf()
                  paddle = nil
                  switch_1=switch_1+1
        end
        
        ------------------------
        -- add turrent
        ------------------------
        local turret = display.newImageRect( sceneGroup,"images/turret.png", 48, 55 )
        physics.addBody( turret, "static", { radius=18 } )
        turret.x = display.contentCenterX-120
        turret.y = display.contentCenterY+220
        turret.rotation = 25
        
        ------------------------
        -- Ray Function
        ------------------------
        local beamGroup = display.newGroup()
        
        local function resetBeams()
        
          for i = beamGroup.numChildren,1,-1 do
            local child = beamGroup[i]
            display.remove( child )
            child = nil
          end

          beamGroup.alpha = 1
        end
        
        local function drawBeam( startX, startY, endX, endY )
        -- Draw a series of overlapping lines to represent the beam
          local beam1 = display.newLine( beamGroup, startX, startY, endX, endY )
          beam1.strokeWidth = 2 ; beam1:setStrokeColor( 1, 0.312, 0.157, 1 ) ; beam1.blendMode = "add" ; beam1:toBack()
          local beam2 = display.newLine( beamGroup, startX, startY, endX, endY )
          beam2.strokeWidth = 4 ; beam2:setStrokeColor( 1, 0.312, 0.157, 0.706 ) ; beam2.blendMode = "add" ; beam2:toBack()
          local beam3 = display.newLine( beamGroup, startX, startY, endX, endY )
          beam3.strokeWidth = 6 ; beam3:setStrokeColor( 1, 0.196, 0.157, 0.392 ) ; beam3.blendMode = "add" ; beam3:toBack()
          
        end


        local function castRay( startX, startY, endX, endY )

          local hits = physics.rayCast( startX, startY, endX, endY, "closest" )
          if ( hits and beamGroup.numChildren <= 50 ) then
            local hitFirst = hits[1]
            local hitX, hitY = hitFirst.position.x, hitFirst.position.y
            
            if ( hitFirst.object == paddle) then
             --paddle break
             onColl()
            end
            
            -- Draw the next beam
            drawBeam( startX, startY, hitX, hitY )

            -- Check for and calculate the reflected ray
            local reflectX, reflectY = physics.reflectRay( startX, startY, hitFirst )
            local reflectLen = 1600
            local reflectEndX = ( hitX + ( reflectX * reflectLen ) )
            local reflectEndY = ( hitY + ( reflectY * reflectLen ) )

            -- If the ray is reflected, cast another ray
            if ( reflectX and reflectY ) then
              timer.performWithDelay( 40, function() castRay( hitX, hitY, reflectEndX, reflectEndY ); end )
            end
            
            else
            -- Draw the final beam
            drawBeam( startX, startY, endX, endY )

            -- Fade out entire beam group after a short delay
            transition.to( beamGroup, { time=800, delay=400, alpha=0, onComplete=resetBeams } )
          end
       end


       local function fireOnTimer( event )

         -- Ensure that all previous beams/bursts are cleared/complete before firing
         if ( beamGroup.numChildren == 0 ) then
           audio.play( shoot )
           local xDest = turret.x - (math.cos(math.rad(turret.rotation+90)) * 1600 )
           local yDest = turret.y - (math.sin(math.rad(turret.rotation+90)) * 1600 )

           -- Cast the initial ray
           castRay( turret.x, turret.y, xDest, yDest )
         end
       end
      
      
      --------------------------------
      -- Moving Mirror
      --------------------------------
      
      local function dragmirror(event)
            local mirror = event.target
            local phase = event.phase
            
            if ( "began" == phase ) then
            display.currentStage:setFocus( mirror )
            
            mirror.touchOffsetX = event.x - mirror.x
            mirror.touchOffsetY = event.y - mirror.y
            
            elseif ( "moved" == phase and mirror.touchOffsetX and mirror.touchOffsetY ) then
            mirror.x = event.x - mirror.touchOffsetX
            mirror.y = event.y - mirror.touchOffsetY
            
            elseif ( "ended" == phase or "cancelled" == phase ) then
            display.currentStage:setFocus( nil )
            
            end
            
            return true 
      end
        
      mirror_d:addEventListener( "touch", dragmirror )
      mirror_d2:addEventListener( "touch", dragmirror )
      
      --------------------------------
      -- add start button
      --------------------------------
      
      local start_b = display.newText( sceneGroup,"Start", turret.x, turret.y+5, native.systemFont, 16 )
      start_b:setFillColor( 1, 1, 1)
      turret:addEventListener( "tap", fireOnTimer ) 

      -------------------------------
      -- checking
      -------------------------------
      local function run()
         if(switch_1==1) then

            mirror_d:removeEventListener( "touch", dragmirror )
            mirror_d2:removeEventListener( "touch", dragmirror )
            turret:removeEventListener( "tap", fireOnTimer ) 

            local clear1 = display.newImageRect(sceneGroup, "images/ms_clear.png", 250, 200 )
            clear1.x = 160 
            clear1.y = 200 
                 
            sceneGroup:insert(clear1)
            switch_1=0
                   
            --goto next scene
            local function clear()       
               composer.gotoScene("level_6",{ time=500, effect="fade" } )                        
            end      
            clear1:addEventListener("touch", clear)
                                  
          end
      end
      
      timer.performWithDelay( 100, run,-1 )
      
    end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then 
    elseif ( phase == "did" ) then
        composer.removeScene("level_5")
    end
end

function scene:destroy( event )

        local sceneGroup = self.view   
        sceneGroup:removeSelf()        --釋放群組物件
        sceneGroup = nil
        
        local beamGroup = self.view   
        beamGroup:removeSelf()        --釋放群組物件
        beamGroup = nil
 
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )   --場景時先被呼叫的地方，可以加入場景需要的物件以及相對應的函數
scene:addEventListener( "show", scene )     --場景要開始運作的進入點，在這裡可以加入需要的執行動作
scene:addEventListener( "hide", scene )     --場景要被切換時會呼叫，也就是要離開場景時
scene:addEventListener( "destroy", scene )  --場景被移除時呼叫

-- -------------------------------------------------------------------------------

return scene