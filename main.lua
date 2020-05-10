io.stdout:setvbuf('no')

if arg[#arg] == "-debug" then require("mobdebug").start() end

local pad = {}
pad.x=0
pad.y=0
pad.largeur = 74
pad.hauteur = 10

local ball = {}
ball.x = 0
ball.y = 0
ball.radius = 6
ball.stick = false
ball.vy = 0
ball.vx = 0

local brique = {}

vie = 3

function DemarreJeu()
    ball.stick = true
    ball.vy = 0
    ball.vx = 0
  end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  brique.hauteur = 25
  brique.largeur = largeur / 15
    
    a = 0
   
  DemarreJeu()
    
  niveau = {}
  local l,c
  local m = 0
  local r = 0
  
  for l=1,6 do
    niveau[l] = {}
    for c=1,15 do
      niveau[l][c] = 1
      m = m+1
      if m == 13 then
        m=0
        niveau[l][c] = niveau[l][c] + 1
      end
      if m > 13 then
        m = m-2
      end
      r = r + 2
       if r > 31 then
        r = r -1
      end
      if r == 33 then
        r = r - 2*m
        niveau[l][c] = niveau[l][c] + 1
      end
    end
    m = m + 1
    r = r - 1
  end
  
end
  
  function love.update(dt)
    -- Piloter la raquette
    if love.mouse.getX() + pad.largeur > largeur + pad.largeur/2
      then pad.x = largeur - pad.largeur - 3
      else pad.x = love.mouse.getX() - pad.largeur/ 2
    end
    if love.mouse.getX() < pad.largeur/2 then
      pad.x = 3
    end
    pad.y = 5*hauteur/6
    
    -- Collisions murs
    if ball.x + ball. radius > largeur then
      ball.vx = -ball.vx
      ball.x = largeur - ball.radius
    end
    if ball.x - ball.radius < 0 then
      ball.vx = - ball.vx
      ball.x = ball.radius
    end
    
    -- Balle collée
    if ball.stick == true then 
      ball.x = pad.x + pad.largeur/2
      ball.y = pad.y - (ball.radius*1.5 + 8)
    else ball.x = ball.vx*dt + ball.x
      if ball.vy > 0 and ball.y + ball.radius < 0 then
        ball.vy = -ball.vy
      else ball.y = ball.y + ball.vy*dt 
      end
    end
    
    -- Collision Raquette
    if ball.y + ball.radius > pad.y - 3 and ball.y + ball.radius < pad.y + 6 and pad.x - 3 < ball.x and ball.x < pad.x + pad.largeur + 3 then
      ball.vy = -ball.vy
      local b
      for b = 0,9 do
        if ball.x > pad.x - 3 + 8*b and ball.x < pad.x + 5 +8*b then
          ball.vx = -280 + 56*b
        end
      end
    end
    
    --Collision plafond
    if ball.y - ball.radius < 0 then
      ball.vy = - ball.vy
    end
    
    --Perte de vie
    if ball.y - ball.radius > hauteur then
      vie = vie - 1
        if vie > 0 then
          DemarreJeu()
        end
    end
    
    local c = math.floor (ball.x / brique.largeur) + 1
    local l = math.floor ((ball.y - ball.radius) / brique.hauteur) + 1
    -- Check si les briques sont cassées
    if l > 0 and l < 7 and  c>0 and c <= 15 then
      if niveau[l][c] >0 then
        niveau[l][c] = niveau[l][c] -1
        ball.vy = -ball.vy
      end
    end
    
  end
  
function love.draw()
    
    if a < 120 then
    love.graphics.print('Start', largeur/2 - 13, hauteur/2)
    a = a + 1
    end
    
    love.graphics.rectangle("fill", pad.x, pad.y, pad.largeur, pad.hauteur)
    love.graphics.rectangle("line", pad.x - 3, pad.y - 3, pad.largeur + 6, pad.hauteur + 6)
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)
  
  
    bx = 0
    by = 0
    
  for l=1,6 do
    bx = 0
    for c=1,15 do
      if niveau[l][c] == 1 then
        love.graphics.rectangle("fill", bx + 8, by + 8, brique.largeur - 16, brique.hauteur - 16)
        love.graphics.rectangle("line", bx, by, brique.largeur, brique.hauteur)
      end
      if niveau[l][c] == 2 then
          love.graphics.rectangle("fill", bx + 4, by + 4, brique.largeur - 8, brique.hauteur - 8)
          love.graphics.rectangle("line", bx, by, brique.largeur, brique.hauteur)
        end
      if niveau[l][c] == 3 then
          love.graphics.rectangle("fill", bx, by, brique.largeur, brique.hauteur)
        end
      bx = bx + brique.largeur
    end
  by = by + brique.hauteur
  end

  love.graphics.rectangle("line", largeur, hauteur, -18*ball.radius, -4*ball.radius)
  love.graphics.print('Vies : ', largeur - 17*ball.radius, hauteur - 3*ball.radius)

  for v= 1,vie do
    love.graphics.circle("fill", largeur - 3*ball.radius*v, hauteur - 2*ball.radius, ball.radius)
  end

end
    
  function love.mousepressed(x,y,n)
    a=200
    if ball.stick == true then
    ball.stick = false
    ball.vx = 200
    ball.vy = -330
    end
  end
  
