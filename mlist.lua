----------------------------------
-- Producer : CHinX2 
-- Finish : 2017 06 13
----------------------------------
-- Main List
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
    composer.removeScene("level_1")
    composer.removeScene("level_2")
    composer.removeScene("level_3")
    composer.removeScene("level_4")
    composer.removeScene("level_5")
    composer.removeScene("level_6")

    if ( phase == "will" ) then  
        
    elseif ( phase == "did" ) then 
      audio.stop()
      
      --------------------------------
      -- add bgm
      --------------------------------
      local bgm = audio.loadStream("WindArk.wav" )
      audio.play( bgm, { loops=-1 } )
      
      --------------------------------
      -- add start button
      --------------------------------   
      local button1,button2,button3,button4,button5,button6
      
      
      -- goto level 1
      local function press_go1(event)
          composer.gotoScene("level_1",{ time=500, effect="fade" } )
      end
      button1 = widget.newButton
      {
        defaultFile = "images/bChose.png", 
        overFile = "images/bChoseo.png",
        label = "1",                         
        font = native.systemFont,                    
        labelColor = { default = { 1, 1, 1 } },     
        fontSize = 150,                             
        onPress = press_go1,                 
      }
      sceneGroup:insert(button1)
      -- 按鈕物件位置
      button1.x = display.contentCenterX-100
      button1.y = display.contentCenterY-150
      -- 按鈕物件長寬
      button1.width = 80
      button1.height = 80

      
      -- goto level 2
      local function press_go2(event)
          composer.gotoScene("level_2",{ time=500, effect="fade" } )
      end
      button2 = widget.newButton
      {
        defaultFile = "images/bChose.png",  
        overFile = "images/bChoseo.png",        
        label = "2",                             
        font = native.systemFont,                     
        labelColor = { default = { 1, 1, 1 } },       
        fontSize = 150,                               
        onPress = press_go2,                    
      }
      sceneGroup:insert(button2)
      button2.x = display.contentCenterX
      button2.y = display.contentCenterY-150
      button2.width = 80
      button2.height = 80
      
      
     -- goto level 3
      local function press_go3(event)
          composer.gotoScene("level_3",{ time=500, effect="fade" } )
      end
      button3 = widget.newButton
      {
        defaultFile = "images/bChose.png", 
        overFile = "images/bChoseo.png",                     
        label = "3",                             
        font = native.systemFont,                     
        labelColor = { default = { 1, 1, 1 } },       
        fontSize = 150,                               
        onPress = press_go3,                    
      }
      sceneGroup:insert(button3)
      button3.x = display.contentCenterX+100
      button3.y = display.contentCenterY-150
      button3.width = 80
      button3.height = 80


      -- goto level 4
      local function press_go4(event)
          composer.gotoScene("level_4",{ time=500, effect="fade" } )

      end
      button4 = widget.newButton
      {
        defaultFile = "images/bChose.png",       
        overFile = "images/bChoseo.png",
        label = "4",                            
        font = native.systemFont,                   
        labelColor = { default = { 1, 1, 1 } },      
        fontSize = 150,                            
        onPress = press_go4,                   
      }
      sceneGroup:insert(button4)
      button4.x = display.contentCenterX-100
      button4.y = display.contentCenterY
      button4.width = 80
      button4.height = 80
   
      
      -- goto level 5
      local function press_go5(event)
          composer.gotoScene("level_5",{ time=500, effect="fade" } )
      end
      button5 = widget.newButton
      {
        defaultFile = "images/bChose.png",      
        overFile = "images/bChoseo.png",    
        label = "5",                             
        font = native.systemFont,                     
        labelColor = { default = { 1, 1, 1 } },       
        fontSize = 150,                               
        onPress = press_go5,                    
      }
      sceneGroup:insert(button5)
      button5.x = display.contentCenterX
      button5.y = display.contentCenterY
      button5.width = 80
      button5.height = 80
   
      
     -- goto level 6
      local function press_go6(event)
          composer.gotoScene("level_6",{ time=500, effect="fade" } )
      end
      button6 = widget.newButton
      {
        defaultFile = "images/bChose.png",            
        overFile = "images/bChoseo.png",          
        label = "6",                             
        font = native.systemFont,                     
        labelColor = { default = { 1, 1, 1 } },       
        fontSize = 150,                               
        onPress = press_go6,                    
      }
      sceneGroup:insert(button6)
      button6.x = display.contentCenterX+100
      button6.y = display.contentCenterY
      button6.width = 80
      button6.height = 80

    end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then  
    elseif ( phase == "did" ) then  
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