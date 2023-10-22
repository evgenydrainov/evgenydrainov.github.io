local sprite = app.activeSprite
if not sprite then
	app.alert("No active sprite.")
	return
end

local d = Dialog("Add border to tileset.")
d:label{ text="Make sure color mode is set to RGB." }
 :number{ id="tile_w", label="Tile Width:", text="16", focus=true }
 :number{ id="tile_h", label="Tile Height:", text="16" }
 :button{ id="ok", text="&OK", focus=true }
 :button{ text="&Cancel" }
 :show()

local data = d.data
if not data.ok then return end

local TILE_W = data.tile_w
local TILE_H = data.tile_h

if (sprite.width % TILE_W) ~= 0 or (sprite.height % TILE_H) ~= 0 then
	app.alert("Sprite size must be divisible by tile size.")
	return
end

local tiles_w = sprite.width  / TILE_W
local tiles_h = sprite.height / TILE_H

local spr_img = Image(sprite)
local new_img = Image(tiles_w * (TILE_W + 2), tiles_h * (TILE_H + 2), sprite.spec)

for tile_y = 0, tiles_h - 1 do
	for tile_x = 0, tiles_w - 1 do
		local x_in_orig = tile_x * TILE_W
		local y_in_orig = tile_y * TILE_H
		local x_in_new = 1 + tile_x * (TILE_W + 2)
		local y_in_new = 1 + tile_y * (TILE_H + 2)
		local color
		
		for j = 0, TILE_W-1 do
			for i = 0, TILE_H-1 do
				color = spr_img:getPixel(x_in_orig + i, y_in_orig + j)
				new_img:drawPixel(x_in_new + i, y_in_new + j, color)
			end
		end
		
		color = spr_img:getPixel(x_in_orig, y_in_orig)
		new_img:drawPixel(x_in_new - 1, y_in_new - 1, color)
		
		color = spr_img:getPixel(x_in_orig + TILE_W - 1, y_in_orig)
		new_img:drawPixel(x_in_new + TILE_W, y_in_new - 1, color)
		
		color = spr_img:getPixel(x_in_orig, y_in_orig + TILE_H - 1)
		new_img:drawPixel(x_in_new - 1, y_in_new + TILE_H, color)
		
		color = spr_img:getPixel(x_in_orig + TILE_W - 1, y_in_orig + TILE_H - 1)
		new_img:drawPixel(x_in_new + TILE_W, y_in_new + TILE_H, color)
		
		for xx = 0, TILE_W-1 do
			color = spr_img:getPixel(x_in_orig + xx, y_in_orig)
			new_img:drawPixel(x_in_new + xx, y_in_new - 1, color)
			
			color = spr_img:getPixel(x_in_orig + xx, y_in_orig + TILE_H - 1)
			new_img:drawPixel(x_in_new + xx, y_in_new + TILE_H, color)
		end
		
		for yy = 0, TILE_H-1 do
			color = spr_img:getPixel(x_in_orig, y_in_orig + yy)
			new_img:drawPixel(x_in_new - 1, y_in_new + yy, color)
			
			color = spr_img:getPixel(x_in_orig + TILE_W - 1, y_in_orig + yy)
			new_img:drawPixel(x_in_new + TILE_W, y_in_new + yy, color)
		end
	end
end

local newsprite = Sprite(new_img.width, new_img.height)
newsprite.cels[1].image = new_img