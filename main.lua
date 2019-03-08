

local body = { x = 4, y = 1, margin = {left = 0, right = 0, bottom = 0, top = 0}, element = {}, figure = {index = 1, turn = 1} }

local field_hieght = 20
local field_width = 10
local square_size = 18
local thickness_lines_grid = 2

local tick = 0
local score = 0
--local level = 1

local field_body = {}
for i = 1, field_hieght do field_body[i] = {} end

local key_up = false
local key_down = false
local key_left = false
local key_right = false
local move_speed_up = 0
local move_speed_bottom = 0
local move_speed_left = 0
local move_speed_right = 0
local speed_falling_figures = 0
local tick_impossibility_shifts = 0
local f_game_over = false


local figure = {
	{
		{
			{0, 1, 0, 0},
			{1, 1, 1, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0}
		},{
			{0, 1, 0, 0},
			{0, 1, 1, 0},
			{0, 1, 0, 0},
			{0, 0, 0, 0}
		},{
			{1, 1, 1, 0},
			{0, 1, 0, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0}
		},{
			{0, 0, 1, 0},
			{0, 1, 1, 0},
			{0, 0, 1, 0},
			{0, 0, 0, 0}
		}
	},{
		{
			{0, 1, 1, 0},
			{0, 0, 1, 0},
			{0, 0, 1, 0},
			{0, 0, 0, 0}
		},{
			{0, 0, 0, 0},
			{0, 0, 1, 0},
			{1, 1, 1, 0},
			{0, 0, 0, 0}
		},{
			{0, 1, 0, 0},
			{0, 1, 0, 0},
			{0, 1, 1, 0},
			{0, 0, 0, 0}
		},{
			{0, 0, 0, 0},
			{1, 1, 1, 0},
			{1, 0, 0, 0},
			{0, 0, 0, 0}
		}
	},{
		{
			{0, 1, 0, 0},
			{0, 1, 1, 0},
			{0, 0, 1, 0},
			{0, 0, 0, 0}
		},{
			{0, 0, 0, 0},
			{0, 1, 1, 0},
			{1, 1, 0, 0},
			{0, 0, 0, 0}
		}
	},{
		{
			{0, 1, 1, 0},
			{0, 1, 1, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0}
		}
	},{
		{
			{0, 1, 0, 0},
			{0, 1, 0, 0},
			{0, 1, 0, 0},
			{0, 1, 0, 0}
		},{
			{0, 0, 0, 0},
			{1, 1, 1, 1},
			{0, 0, 0, 0},
			{0, 0, 0, 0}
		}
	},{
		{
			{0, 1, 1, 0},
			{0, 1, 0, 0},
			{0, 1, 1, 0},
			{0, 0, 0, 0}
		},{
			{0, 0, 0, 0},
			{1, 1, 1, 0},
			{1, 0, 1, 0},
			{0, 0, 0, 0}
		},{
			{0, 1, 1, 0},
			{0, 0, 1, 0},
			{0, 1, 1, 0},
			{0, 0, 0, 0}
		},{
			{0, 0, 0, 0},
			{1, 0, 1, 0},
			{1, 1, 1, 0},
			{0, 0, 0, 0}
		}
	},{
		{
			{0, 1, 1, 0},
			{0, 0, 1, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0}
		},{
			{0, 0, 1, 0},
			{0, 1, 1, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0}
		},{
			{0, 1, 0, 0},
			{0, 1, 1, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0}
		},{
			{0, 1, 1, 0},
			{0, 1, 0, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0}
		}
	}
}


function RGB(r, g, b) return {r*1/255, g*1/255, b*1/255} end


function RecalculateMargin(body_margin, body_element)
	
	for y = 0, 3, 1 do
		body_margin.top = y
		if body_element[y+1][1] ~= 0 or 
		   body_element[y+1][2] ~= 0 or 
		   body_element[y+1][3] ~= 0 or 
		   body_element[y+1][4] ~= 0 then 
			break
		end
	end
	
	for y = 0, 3, 1 do
		body_margin.bottom = y
		if body_element[4-y][1] ~= 0 or 
		   body_element[4-y][2] ~= 0 or 
		   body_element[4-y][3] ~= 0 or 
		   body_element[4-y][4] ~= 0 then 
			break
		end
	end
	
	for x = 0, 3, 1 do
		body_margin.left = x
		if body_element[1][x+1] ~= 0 or 
		   body_element[2][x+1] ~= 0 or 
		   body_element[3][x+1] ~= 0 or 
		   body_element[4][x+1] ~= 0 then 
			break
		end
	end
	
	for x = 0, 3, 1 do
		body_margin.right = x
		if body_element[1][4-x] ~= 0 or 
		   body_element[2][4-x] ~= 0 or 
		   body_element[3][4-x] ~= 0 or 
		   body_element[4][4-x] ~= 0 then 
			break
		end
	end
	
end


function MoveFigureTop()
	local body_shift = true
	
	if ( body.y + body.margin.top ) > 1 then
		
		for y = 1+body.margin.top, 4-body.margin.bottom, 1 do
			for x = 1+body.margin.left, 4-body.margin.right, 1 do
				
				if ( field_body[body.y+y-1-1][body.x+x-1] ~= 0 ) and
					( body.element[y][x] ~= 0 ) then
					body_shift = false
				end
				
			end
		end
		
		if body_shift then
			body.y = body.y - 1
		end
		
	end
end


function MoveFigureBottom(test)
	local body_shift = true
	test = test or false
	
	if ( body.y + 3 - body.margin.bottom ) < field_hieght then
		
		for y = 1+body.margin.top, 4-body.margin.bottom, 1 do
			for x = 1+body.margin.left, 4-body.margin.right, 1 do
				
				if ( field_body[body.y+y-1+1][body.x+x-1] ~= 0 ) and
					( body.element[y][x] ~= 0 ) then
					body_shift = false
				end
				
			end
		end
		
		if body_shift and not test then
			body.y = body.y + 1
		end
	
	else
		body_shift = false
	end
	
	return body_shift
end


function MoveFigureLeft()
	local body_shift = true
	
	if ( body.x + body.margin.left ) > 1 then
		
		for y = 1+body.margin.top, 4-body.margin.bottom, 1 do
			for x = 1+body.margin.left, 4-body.margin.right, 1 do
				
				if ( field_body[body.y+y-1][body.x+x-1-1] ~= 0 ) and
					( body.element[y][x] ~= 0 ) then
					body_shift = false
				end
				
			end
		end
		
		if body_shift then
			body.x = body.x - 1
		end
		
	end
end


function MoveFigureRight()
	local body_shift = true
	
	if ( body.x + 3 - body.margin.right ) < field_width then
		
		for y = 1+body.margin.top, 4-body.margin.bottom, 1 do
			for x = 1+body.margin.left, 4-body.margin.right, 1 do
				
				if ( field_body[body.y+y-1][body.x+x-1+1] ~= 0 ) and
					( body.element[y][x] ~= 0 ) then
					body_shift = false
				end
				
			end
		end
		
		if body_shift then
			body.x = body.x + 1
		end
		
	end
end


function TurnFigure()
	
	-- ####################################################################
	local body_turn = true
	local turn = 0
	
	if body.figure.turn < #figure[body.figure.index] then
		turn = body.figure.turn + 1
	else
		turn = 1
	end
	
	local margin = {left = 0, right = 0, bottom = 0, top = 0}
	RecalculateMargin(margin, figure[body.figure.index][turn])
	
	for y = 1+margin.top, 4-margin.bottom, 1 do
		for x = 1+margin.left, 4-margin.right, 1 do
			
			if ( (body.y+y-1 > field_hieght) or (body.y+y-1 <= 0) ) or 
			   ( field_body[body.y+y-1][body.x+x-1] ~= 0 ) and 
			   ( figure[body.figure.index][turn][y][x] ~= 0 ) then
				body_turn = false
			end
			
		end
	end
	-- ####################################################################
	
	if body_turn then
		if body.figure.turn < #figure[body.figure.index] then
			body.figure.turn = body.figure.turn + 1
		else
			body.figure.turn = 1
		end
	end
	
	body.element = figure[body.figure.index][body.figure.turn]
	
	RecalculateMargin(body.margin, body.element)
end


function NewFigure()
	
	-- Запекаем текущую фигуру
	
	for y = 1+body.margin.top, 4-body.margin.bottom, 1 do
		for x = 1+body.margin.left, 4-body.margin.right, 1 do
			
			if field_body[body.y+y-1][body.x+x-1] == 0 then
				field_body[body.y+y-1][body.x+x-1] = figure[body.figure.index][body.figure.turn][y][x]
			end
			
		end
	end
	
	
	-- Ищем заполненные линии и удаляем их
	
	local bonus = 0
	local y = field_hieght
	while y >= 1 do
		local line_filled = true
		
		for x = 1, field_width, 1 do
			
			if field_body[y][x] == 0 then
				line_filled = false
				break
			end
			
		end
		
		if line_filled then
			
			for yi = 1, y, 1 do
				for xi = 1, field_width, 1 do
					field_body[y-yi+1][xi] = ((y - yi) > 0) and field_body[y-yi][xi] or 0
				end
			end
			
			bonus = bonus + 1
		else
			y = y - 1
		end
		
	end
	score = score + 2^bonus
	
	
	-- Вытаскиваем новую фигуру
	
	--[[
	if body.figure.index < #figure then
		body.figure.index = body.figure.index + 1
	else
		body.figure.index = 1
	end
	]]
	body.figure.turn = 1
	
	-- Берем случайную фигуру
	body.figure.index = love.math.random(1, #figure)
	
	body.element = figure[body.figure.index][body.figure.turn]
	
	RecalculateMargin(body.margin, body.element)
	
	body.x = 4
	body.y = 1
	
	
	
	-- проверяем доступно-ли место для фигуры
	
	for y = 1+body.margin.top, 4-body.margin.bottom, 1 do
		for x = 1+body.margin.left, 4-body.margin.right, 1 do
			
			if ( field_body[body.y+y-1][body.x+x-1] ~= 0 ) and
				( body.element[y][x] ~= 0 ) then
				f_game_over = true
			end
			
		end
	end
	
	
end

-- ## LOVE.LOAD ###############################################################
function love.load(arg)
	if arg[#arg] == "-debug" then require("mobdebug").start() end
	
	
	for y = 1, field_hieght, 1 do
		for x = 1, field_width, 1 do
			field_body[y][x] = 0
		end
	end
	
	body.figure.index = love.math.random(1, #figure)
	body.element = figure[body.figure.index][body.figure.turn]
	
	RecalculateMargin(body.margin, body.element)
	
	
	local f = love.graphics.newFont("font/Tahoma.ttf", 12, 'mono')
	love.graphics.setFont(f)
	--love.graphics.setColor(0,0,0,255)
	love.graphics.setBackgroundColor(RGB(200,200,200))
	
	love.graphics.setLineStyle('rough')
	love.graphics.setLineWidth(thickness_lines_grid)
	
end

-- ## LOVE.UPDATE #############################################################
function love.update(dt)
	
	if f_game_over then return end
	
	
	tick = tick + 1000 * dt
	tick_impossibility_shifts = tick_impossibility_shifts + 1000 * dt
	
	-- Скорость падения фигур
	if score > speed_falling_figures + 10 then
		speed_falling_figures = speed_falling_figures + 10
		--level = level + speed_falling_figures / 10 - 1
	end
	if tick > 1000 - speed_falling_figures then
		if MoveFigureBottom() then
			tick_impossibility_shifts = 0
		end
		tick = 0
	end
	
	if tick_impossibility_shifts > 600 then
		if not MoveFigureBottom(true) then
			NewFigure()
		end
		tick_impossibility_shifts = 0
	end
	
	
	-- ## KEY: up #############################################################
	if key_up then
		move_speed_up = move_speed_up + 1000 * dt
		if (move_speed_up > 300) then
			MoveFigureTop()
			move_speed_up = move_speed_up / 1.2
		end
	end
	-- ## KEY: down ###########################################################
	if key_down then
		move_speed_bottom = move_speed_bottom + 1000 * dt
		if (move_speed_bottom > 300) then
			if MoveFigureBottom() then
				tick_impossibility_shifts = 0
			end
			move_speed_bottom = move_speed_bottom / 1.2
		end
	end
	-- ## KEY: left ###########################################################
	if key_left then
		move_speed_left = move_speed_left + 1000 * dt
		if (move_speed_left > 300) then
			MoveFigureLeft()
			move_speed_left = move_speed_left / 1.2
		end
	end
	-- ## KEY: right ##########################################################
	if key_right then
		move_speed_right = move_speed_right + 1000 * dt
		if (move_speed_right > 300) then
			MoveFigureRight()
			move_speed_right = move_speed_right / 1.2
		end
	end
	
end

-- ## LOVE.DRAW ###############################################################
function love.draw()
	love.graphics.translate(10, 10)
	
	love.graphics.setColor(RGB(0, 0, 255))
	love.graphics.print("Score: "..score, field_width*(square_size+thickness_lines_grid)+5, 0)
	--love.graphics.print("Level: "..level, field_width*(square_size+thickness_lines_grid)+5, 14)
	--love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), field_width*(square_size+thickness_lines_grid)+5, 14)
	--love.graphics.print("tick: "..tick, 0, field_hieght*(square_size+thickness_lines_grid)+5)
	--love.graphics.print("speed: "..speed_falling_figures, 0, field_hieght*(square_size+thickness_lines_grid)+20)
	
	
	-- Рисуем сетку
	love.graphics.setColor(RGB(0, 40, 0))
	for i = 0, field_hieght*(square_size+thickness_lines_grid), (square_size+thickness_lines_grid) do
		love.graphics.line((thickness_lines_grid/2), (thickness_lines_grid/2)+i, field_width*(square_size+thickness_lines_grid)+(thickness_lines_grid/2), (thickness_lines_grid/2)+i)
	end
	for i = 0, field_width*(square_size+thickness_lines_grid), (square_size+thickness_lines_grid) do
		love.graphics.line((thickness_lines_grid/2)+i, (thickness_lines_grid/2), (thickness_lines_grid/2)+i, field_hieght*(square_size+thickness_lines_grid)+(thickness_lines_grid/2))
	end
	
	-- Закрашиваем квадраты
	for y = 1, field_hieght, 1 do
		for x = 1, field_width, 1 do
			
			if field_body[y][x] ~= 0 then
				love.graphics.setColor(RGB(200, 0, 200))
				love.graphics.rectangle("fill", x*(square_size+thickness_lines_grid)-square_size, y*(square_size+thickness_lines_grid)-square_size, square_size, square_size)
			end
			
			if (body.x <= x and body.x+3 >= x) and (body.y <= y and body.y+3 >= y) then
				if body.element[(y+1)-body.y][(x+1)-body.x] ~= 0 then
					love.graphics.setColor(RGB(200, 0, 0))
					love.graphics.rectangle("fill", x*(square_size+thickness_lines_grid)-square_size, y*(square_size+thickness_lines_grid)-square_size, square_size, square_size)
				end
			end
			
		end
	end
	
end


function love.keypressed(key, unicode)
	if key == 'space' then
		TurnFigure()
	elseif key == 'return' then
		--NewFigure()
	elseif key == 'up' then
		--MoveFigureTop()
		--key_up = true
		TurnFigure()
	elseif key == 'down' then
		MoveFigureBottom()
		key_down = true
	elseif key == 'left' then
		MoveFigureLeft()
		key_left = true
	elseif key == 'right' then
		MoveFigureRight()
		key_right = true
	end
end


function love.keyreleased(key, unicode)
	if key == 'up' then
		key_up = false
		move_speed_up = 0
	elseif key == 'down' then
		key_down = false
		move_speed_bottom = 0
	elseif key == 'left' then
		key_left = false
		move_speed_left = 0
	elseif key == 'right' then
		key_right = false
		move_speed_right = 0
	end
end

