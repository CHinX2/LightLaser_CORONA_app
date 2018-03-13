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

local composer  = require( "composer" )   --轉換場景
local widget    = require( "widget" )     --按鈕
local movieclip = require( "movieclip" )  --動畫
local physics   = require( "physics" )    --物理引擎
physics.start()                           --物理引擎啟動
physics.setGravity( 0, 0 )


local scene = composer.newScene()         --建立新場景

------------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
------------------------------------------------------------------------------------------------------------------


-- "scene:create()" 畫面相關物件建立，不包括native物件，EX：輸入框，應該在scene:show()函數裡建立
function scene:create( event )

    local sceneGroup = self.view     --畫面相關物件加入群組，離開此場景時

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
       
    -- 設定按鈕屬性(屬性均是選擇性的，可不設定)
    local button = widget.newButton
    {
        defaultFile = "images/bMain.png",          -- 未按按鈕時顯示的圖片
        overFile = "images/bMaino.png",
        onPress = b_Press,                            -- 觸發按下按鈕事件要執行的函式
    }
    -- 按鈕物件位置
    button.width = 70
    button.height = 45
    button.x = 280; button.y = 5
    sceneGroup:insert(button)
        
       
end


-- "scene:show()" 可以加入需要的執行動作，--執行兩次
function scene:show( event ) 

    local sceneGroup = self.view
    local phase = event.phase
    
    --如沒設定will or did 會執行兩次
    if ( phase == "will" ) then      --未在螢幕時執行，EX：移除前一場景、移除場景
    
        -- Called when the scene is still off screen (but is about to come on screen)
        
    elseif ( phase == "did" ) then   --已在螢幕後執行
    
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
        local switch_1 = 0        --做為開關使用
        
        local function onColl(x)
                  audio.play( hit )
                  local Forest = movieclip.newAnim({"images/explode1.png","images/explode2.png","images/explode3.png","images/explode4.png","images/explode5.png","images/explode6.png","images/explode7.png","images/explode8.png","images/explode9.png"})
                  Forest:play({startFrame=1,endFrame=9,loop=1,remove=true})
                  Forest.x,Forest.y = paddle.x,paddle.y --位置
                  Forest.width,Forest.height=150,150
                  Forest:setDrag{drag=true} --拖曳移動物件         
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
            clear1:addEventListener("touch", clear)   --按一下執行clear函數    
                                  
          end
      end
      
      timer.performWithDelay( 100, run,-1 )
      
    end
end


-- "scene:hide()" --執行兩次
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then     --場景在螢幕將要卸載時執行  EX:終止音樂、停止動畫
        -- Called when the scene is on screen (but is about to go off screen)
        -- Insert code here to "pause" the scene
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then  --場景在螢幕卸載時立刻執行
        -- Called immediately after scene goes off screen
        composer.removeScene("level_1")
    end
end


-- "scene:destroy()"
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