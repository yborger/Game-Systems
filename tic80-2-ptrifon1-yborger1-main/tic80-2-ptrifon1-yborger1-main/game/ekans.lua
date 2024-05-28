-- title:   ekans
-- author:  Paulina & Yael
-- desc:    reverse snake! using the official tic80 snake tutorial
-- site:    website link
-- license: Unsure, probably Nesbox Tic80 Copyright?
-- version: 0.1
-- script:  lua

-- sets the location of the starting pixel
t=0
x=96
y=24

dirs={ -- arrow keys effect on head
	[0]={x= 0,y=-1}, --up
	[1]={x= 0,y= 1}, --down
	[2]={x=-1,y= 0}, --left
	[3]={x= 1,y= 0} --right
	}
	
	function init() -- setting initial values
		t=0 --time
		score=0
		snake={ 
			{x=15,y=8}, --tail
			{x=14,y=8}, --neck
			{x=13,y=8} --head
		}
		food={x=10,y=10}
		dir=dirs[0]
		realStart = false;
	end
	
	function update() -- determines when the snake moves (time based)
		if #snake > 10 or realStart==false then
			return t%10==0
		else
			return t%#snake==0
		end
	end
	
	function gotFood()
		if head.x==food.x and head.y==food.y then
			return true
		end
	end
	
	function setFood()
		food.x=math.random(0,29)
		food.y=math.random(0,16)
		for i,v in pairs(snake) do
			if v.x==food.x and v.y==food.y then
				setFood()
			end
		end
	end
	
	function draw()
		cls(0) --our gifs were recording before we fixed the background, I am so sorry
		for i,v in pairs(snake) do
			rect(v.x*8,v.y*8,8,8,15)
		end
	
		rect(food.x*8,food.y*8,8,8,6)
	end
	
	init()
	setFood()
	function TIC()
		t=t+1 --time incrimenting upward
		head = snake[#snake] --head is the highest adderess
		neck = snake[#snake-1] -- neck has adress directly after head
		tail = snake[1] -- tail has lowest adress
		if update() then
			
			if score == 1 then
				realStart=true
			end			
			
			for i,v in pairs(snake) do -- i is some number, v has the coordinates of the head (?)
				if i~=#snake and v.x==head.x and v.y==head.y then
					trace("Game OVER!") -- Trace seems to be used to write
					trace("Score: "..score)
					exit()
				end
			end
			
			table.insert(snake,#snake+1,{x=(head.x+dir.x)%30,y=(head.y+dir.y)%17}) -- adds new head
			
			if not gotFood() and realStart then -- if we haven't gotten the food remove the end MODIFY TO ADD CONDITIONAL IF NOT FIRST FOOD GOTTEN
				table.remove(snake,1)
			elseif not gotFood() then
				--blank
			else
				table.remove(snake,1)
				table.remove(snake,1)
				setFood()
				score=score+1
			end
			
			--Win Condition
			if #snake==2 then
				trace("YOU WIN!")
				trace("Score: "..score)
				exit()
			end

		end
	
		local last_dir=dir
	
		if btn(0) then dir=dirs[0]
			elseif btn(1) then dir=dirs[1]
			elseif btn(2) then dir=dirs[2]
			elseif btn(3) then dir=dirs[3]
		end
	
		if head.x+dir.x==neck.x and head.y+dir.y==neck.y then
			dir=last_dir
		end
	
		draw()
	end

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 005:eccccccccc888888caaaaaaaca888888cacccccccaccccccca0c0ccccac00ccc
-- 006:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0c0a0c0c00ca0c0c
-- 007:eccccccccc888888caaaaaaaca888888cacccccccac80ccccac90ccccaca0ccc
-- 008:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc08ca0c0c09ca0c0c0aca0c0c
-- 009:eccccccccc888888caaaaaaa888888888dcccdd8ddcdddeedddddeee8deeeee8
-- 010:ccccceee8888cceeaaa98cee8a998cce88998acc88998a8c8899898c8899898c
-- 011:eccccccccc777777c5555555777777777dcccdd7ddcdddeedddddeee7deeeee7
-- 012:ccccceee7777ccee55567cee75667cce776675cc7766757c7766767c7766767c
-- 013:eccccccccc111111c3333333111111111dcccdd1ddcdddeedddddeee1deeeee1
-- 014:ccccceee1111ccee33321cee13221cce112213cc1122131c1122121c1122121c
-- 017:cacccccccaaaaa2acaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:caccc222caaaa222caaac222caaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 021:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 022:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 023:caccccccca22aaaacaaa0aaacaaaa000caaaaaaac8888888cc000cccecccccec
-- 024:ccca00cca22a0cce0aaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 025:88888888caaaaaaac9aaaaa9c99aaa99c9999999c8888888cc000cccecccccec
-- 026:8999898c999988cc99998cce99998cce99998cce8888ccee000cceeecccceeee
-- 027:77777777c5555555c6555556c6655566c6666666c7777777cc000cccecccccec
-- 028:7666767c666677cc66667cce66667cce66667cce77777cce000ccceecccceeee
-- 029:11111111c3333333c2333332c2233322c2222222c1111111cc000cccecccccec
-- 030:1222121c222211cc22221cce22221cee22221cee1111ccee000cceeecccceeee
-- </TILES>

-- <MAP>
-- 007:000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c8d1c08b23e53ce4c57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

