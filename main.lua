Window_width = 1280
Window_height = 720

virtual_width = 432
virtual_height = 243

paddle_speed = 200

Class = require 'class'
push = require 'push'

require 'Paddle'
require 'Ball'

function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle("Pong")
 
    smallFont = love.graphics.newFont("04B_03__.TTF",8)

    scorefont = love.graphics.newFont("04B_03__.TTF",32)

    victoryFont = love.graphics.newFont("04B_03__.TTF",24)

    sounds = {
        ['paddlehit'] = love.audio.newSource('paddlehit.wav', 'static'), 
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['wallhit'] = love.audio.newSource('wallhit.wav', 'static')
    }

    player1_Score = 0
    player2_Score = 0

    servingPlayer = 1
    winningPlayer = 0

    

    player1 = Paddle(5, 20, 5, 20)
    player2 = Paddle(virtual_width - 10, virtual_height - 30, 5, 20)
    ball = Ball(virtual_width / 2 - 2, virtual_height / 2 -2, 5, 5)

    if servingPlayer == 1 then
        ball.dx = 100
    else
        ball.dx = -100
    end

   

    gameState= "start"



    push:setupScreen(virtual_width, virtual_height, Window_width, Window_height, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end
function love.update(dt)
    if gameState == 'serve' then
        ball.dy = math.random(-70, 70)
        if servingPlayer == 1 then
            ball.dx = math.random(150, 200)
        else
            ball.dx = - math.random(150, 200)
        end
    elseif gameState == 'play' then
        if ball:collides(player1) then 
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
    
            sounds['paddlehit']:play()
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4
    
            sounds['paddlehit']:play()
            
            if ball.dy < 0 then 
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball.x < 0 then
            player2_Score = player2_Score + 1
            servingPlayer = 1

            sounds['score']:play()
            ball.dx = 100
            if player2_Score == 10 then
                gameState = 'victory'
                winningPlayer = 2
            else
                gameState = 'serve'
                ball:reset()
                
            end
        end
        
        if ball.x >= virtual_width then
            player1_Score = player1_Score + 1
            servingPlayer = 2
            sounds['score']:play()
            ball.dx = -100
            if player1_Score >= 10 then
                gameState = 'victory'
                winningPlayer = 1
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    

    

        if ball.y <= 0 then
             ball.dy = -ball.dy
             ball.y = 0

             sounds['wallhit']:play()
         end

        if ball.y >= virtual_height - 4 then
             ball.dy = -ball.dy
             ball.y = virtual_height - 4

            sounds['wallhit']:play()
        end
     end







    player1:update(dt)
    player2:update(dt)
-- AI setting
    if player1:down(ball) then
        player1.dy = - paddle_speed

    elseif player1:up(ball) then
        player1.dy = paddle_speed
    else 
        player1.dy = 0
    
    end
-- Player setting
    if love.keyboard.isDown('up') then
        player2.dy = - paddle_speed

    elseif love.keyboard.isDown('down') then
        player2.dy = paddle_speed
    else
        player2.dy = 0
    end

    if gameState== 'play' then
        ball:update(dt)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState== 'start' then
            gameState= 'serve'
        elseif gameState == 'victory' then
            gameState = 'start'
            player1_Score = 0
            player2_Score = 0
            if winningPlayer == 1 then
                servingPlayer = 2
            else 
                servingPlayer = 1
            end
        elseif gameState== 'serve' then
            gameState= 'play'
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40/225, 45/255, 52/225, 255/255)

    love.graphics.setFont(smallFont)

    if gameState == "start" then
         love.graphics.printf("Welcome to Pong!", 0, 10, virtual_width, 'center')
         love.graphics.printf("Print Enter to Play!", 0, 20, virtual_width, 'center')
    elseif gameState == 'serve' then
         love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s turn!" , 0, 10, virtual_width, 'center')
         love.graphics.printf("Press Enter to Serve!", 0, 20, virtual_width, 'center')
    elseif gameState == 'victory' then
         love.graphics.setFont(victoryFont)
         love.graphics.printf("Player " .. tostring(winningPlayer) .. "'s wins!" , 0, 10, virtual_width, 'center')
         love.graphics.setFont(smallFont)
         love.graphics.printf("Welcome to Pong!", 0, 42, virtual_width, 'center')
    elseif gameState == 'play' then

    end

    


    player1:render()
    player2:render()

    ball:render()


    displayFPS()
    



    

    

    
    love.graphics.setFont(scorefont)

    love.graphics.print(player1_Score, virtual_width / 2 -50, virtual_height / 3)

    love.graphics.print(player2_Score, virtual_width / 2 +30, virtual_height / 3)
    
    push:apply('end')

end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1, 1, 1, 1)
end

function displayScore()
    love.graphics.setFont(scorefont)
    love.graphics.print(tostring(player1_Score), virtual_width/2 - 50, virtual_height / 3)
    ove.graphics.print(tostring(player2_Score), virtual_width/2 + 30, virtual_height / 3)
end
