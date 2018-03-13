----------------------------------
-- Producer : CHinX2 
-- Finish : 2017 06 13
----------------------------------
-- Special Thanks to Brent Sorrentino's Tutorial
-- https://coronalabs.com/blog/2013/05/07/physics-raycasting-and-reflection/
-- https://github.com/coronalabs/samples-coronasdk
----------------------------------
-- Level 1
----------------------------------

local composer  = require( "composer" )   --�ഫ����
local widget    = require( "widget" )     --���s
local movieclip = require( "movieclip" )  --�ʵe
local physics   = require( "physics" )    --���z����
physics.start()                           --���z�����Ұ�
physics.setGravity( 0, 0 )


local scene = composer.newScene()         --�إ߷s����

------------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
------------------------------------------------------------------------------------------------------------------


-- "scene:create()" �e����������إߡA���]�Anative����AEX�G��J�ءA���Ӧbscene:show()��Ƹ̫إ�
function scene:create( event )

    local sceneGroup = self.view     --�e����������[�J�s�աA���}��������

      -- Initialize the scene here
      -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    local background = display.newImageRect( sceneGroup, "images/bg.png", 800, 1000 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    
    ----------------------------
    -- add buttom to next level
    ----------------------------
    local b_Press = function( event )      
        composer.gotoScene("mlist",{ time=500, effect="fade" } )
    end
       
    -- �]�w���s�ݩ�(�ݩʧ��O��ܩʪ��A�i���]�w)
    local button = widget.newButton
    {
        defaultFile = "images/bMain.png",          -- �������s����ܪ��Ϥ�
        overFile = "images/bMaino.png",
        onPress = b_Press,                            -- Ĳ�o���U���s�ƥ�n���檺�禡
    }
    -- ���s�����m
    button.width = 70
    button.height = 45
    button.x = 280; button.y = 5
    sceneGroup:insert(button)
        
       
end


-- "scene:show()" �i�H�[�J�ݭn������ʧ@�A--����⦸
function scene:show( event ) 

    local sceneGroup = self.view
    local phase = event.phase
    
    --�p�S�]�wwill or did �|����⦸
    if ( phase == "will" ) then      --���b�ù��ɰ���AEX�G�����e�@�����B��������
    
        -- Called when the scene is still off screen (but is about to come on screen)
        
    elseif ( phase == "did" ) then   --�w�b�ù������
    
        local shoot = audio.loadSound( "shoot.wav" )
        local hit = audio.loadSound( "hit.wav" )
        
        --------------------------
        --  Static mirror
        --------------------------  
        
        --build a static mirror set
        local mirrorSet = {
           { 0, -125, 90,"images/wall.png", 20, 80 },
        }

        local mirrors = {}

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
        local mirror_d = display.newImageRect( sceneGroup, "images/mirror.png", 20, 80 )
        physics.addBody( mirror_d, "static", { shape={-9,-39,9,-39,9,39,-9,39} } )
        mirror_d.x = display.contentCenterX + 105
        mirror_d.y = display.contentCenterY + 60
        mirror_d.rotation = -35

        
        ------------------------
        -- add paddle
        ------------------------
        local paddle = display.newImageRect( sceneGroup,"images/box.png", 58, 50 )
        paddle.x = 170 
        paddle.y = 320
        physics.addBody( paddle, "static", { density=1, friction=0.3, bounce=0.7 } )
        
        
        -------------------------
        -- paddle remove function
        -------------------------        
        local switch_1 = 0        --�����}���ϥ�
        
        local function onColl(x)
                  audio.play( hit )
                  local Forest = movieclip.newAnim({"images/explode1.png","images/explode2.png","images/explode3.png","images/explode4.png","images/explode5.png","images/explode6.png","images/explode7.png","images/explode8.png","images/explode9.png"})
                  Forest:play({startFrame=1,endFrame=9,loop=1,remove=true})
                  Forest.x,Forest.y = paddle.x,paddle.y --��m
                  Forest.width,Forest.height=150,150
                  Forest:setDrag{drag=true} --�즲���ʪ���         
                  paddle:removeSelf()
                  paddle = nil
                  switch_1=switch_1+1
        end
        
        ------------------------
        -- add turrent
        ------------------------
        local turret = display.newImageRect( sceneGroup,"images/turret.png", 48, 55 )
        physics.addBody( turret, "static", { radius=18 } )
        turret.x = display.contentCenterX
        turret.y = display.contentCenterY
        turret.rotation = 0
        
        ------------------------
        -- Ray Function
        ------------------------
        local beamGroup = display.newGroup()
        
        local function resetBeams()
        -- Clear all beams/bursts from display
        
          for i = beamGroup.numChildren,1,-1 do
            local child = beamGroup[i]
            display.remove( child )
            child = nil
          end
          
          -- Reset beam group alpha
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

          -- Perform ray cast
          local hits = physics.rayCast( startX, startY, endX, endY, "closest" )

          -- There is a hit; calculate the entire ray sequence (initial ray and reflections)

          if ( hits and beamGroup.numChildren <= 50 ) then

            -- Store first hit to variable (just the "closest" hit was requested, so use 'hits[1]')
            local hitFirst = hits[1]


            -- Store the hit X and Y position to local variables
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

            -- Else, ray casting sequence is complete
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

           -- Calculate ending x/y of beam
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
            local mirror = event.target -- the object which was touched/tapped
            local phase = event.phase   -- began/moved/ended/cancelled
            
            if ( "began" == phase ) then
            -- Set touch focus on the mirror
            display.currentStage:setFocus( mirror )
            
            -- Store initial offset position
            mirror.touchOffsetX = event.x - mirror.x
            mirror.touchOffsetY = event.y - mirror.y
            
            elseif ( "moved" == phase and mirror.touchOffsetX and mirror.touchOffsetY ) then
            -- Move the mirror to the new touch position
            mirror.x = event.x - mirror.touchOffsetX
            mirror.y = event.y - mirror.touchOffsetY
            
            elseif ( "ended" == phase or "cancelled" == phase ) then
            -- Release touch focus on the mirror
            display.currentStage:setFocus( nil )
            
            end
            
            return true  -- Prevents touch propagation to underlying objects
      end
        
      mirror_d:addEventListener( "touch", dragmirror )
      
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
            turret:removeEventListener( "tap", fireOnTimer ) 

            local clear1 = display.newImageRect(sceneGroup, "images/ms_clear.png", 250, 200 )
            clear1.x = 160 
            clear1.y = 200 
                 
            sceneGroup:insert(clear1)
            switch_1=0
                   
            --goto next scene
            local function clear()       
               composer.gotoScene("level_2",{ time=500, effect="fade" } )                        
            end      
            clear1:addEventListener("touch", clear)   --���@�U����clear���    
                                  
          end
      end
      
      timer.performWithDelay( 100, run,-1 )
      
    end
end


-- "scene:hide()" --����⦸
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then     --�����b�ù��N�n�����ɰ���  EX:�פ�֡B����ʵe
        -- Called when the scene is on screen (but is about to go off screen)
        -- Insert code here to "pause" the scene
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then  --�����b�ù������ɥߨ����
        -- Called immediately after scene goes off screen
        composer.removeScene("level_1")
    end
end


-- "scene:destroy()"
function scene:destroy( event )

        local sceneGroup = self.view   
        sceneGroup:removeSelf()        --����s�ժ���
        sceneGroup = nil
        
        local beamGroup = self.view   
        beamGroup:removeSelf()        --����s�ժ���
        beamGroup = nil

end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )   --�����ɥ��Q�I�s���a��A�i�H�[�J�����ݭn������H�ά۹��������
scene:addEventListener( "show", scene )     --�����n�}�l�B�@���i�J�I�A�b�o�̥i�H�[�J�ݭn������ʧ@
scene:addEventListener( "hide", scene )     --�����n�Q�����ɷ|�I�s�A�]�N�O�n���}������
scene:addEventListener( "destroy", scene )  --�����Q�����ɩI�s

-- -------------------------------------------------------------------------------

return scene