local gc=love.graphics
local int=math.floor

local lines={
	{1,2,3},
	{4,5,6},
	{7,8,9},
	{1,4,7},
	{2,5,8},
	{3,6,9},
	{1,5,9},
	{3,5,7},
}

local board={{},{},{},{},{},{},{},{},{}}
local score={}

local round
local target
local gameover

local function checkBoard(b,p)
	for i=1,8 do
		for j=1,3 do
			if b[lines[i][j]]~=p then
				goto nextLine
			end
		end
		do return true end
		::nextLine::
	end
end

function sceneInit.play()
	round=0
	target=false
	gameover=false
	for X=1,9 do
		score[X]=false
		for x=1,9 do
			board[X][x]=false
		end
	end
	BG.set("bg2")
end

function Pnt.play()
	gc.push("transform")
	gc.translate(0,140)
	gc.scale(4)
	gc.setColor(0,0,0,.4)
	gc.rectangle("fill",0,0,90,90)
	gc.setLineWidth(.8)
	if not gameover then
		gc.setColor(1,1,1,math.sin(love.timer.getTime()*5)/5+.2)
		if target then
			gc.rectangle("fill",(target-1)%3*30,int((target-1)/3)*30,30,30)
		else
			gc.rectangle("fill",0,0,90,90)
		end
	end
	for X=1,9 do
		if score[X]then
			if score[X]==0 then
				gc.setColor(.4,0,0)
			elseif score[X]==1 then
				gc.setColor(0,0,.5)
			else
				gc.setColor(.5,.5,.5)
			end
			gc.rectangle("fill",(X-1)%3*30,int((X-1)/3)*30,30,30)
		end
		for x=1,9 do
			local c=board[X][x]
			if c then
				if c==0 then
					gc.setColor(1,.2,.2)
					gc.circle(
						"line",
						5+(X-1)%3*30+(x-1)%3*10,
						5+int((X-1)/3)*30+int((x-1)/3)*10,
						3.5
					)
				else
					gc.setColor(.3,.3,1)
					gc.line(
						2+(X-1)%3*30+(x-1)%3*10,
						2+int((X-1)/3)*30+int((x-1)/3)*10,
						8+(X-1)%3*30+(x-1)%3*10,
						8+int((X-1)/3)*30+int((x-1)/3)*10
					)
					gc.line(
						2+(X-1)%3*30+(x-1)%3*10,
						8+int((X-1)/3)*30+int((x-1)/3)*10,
						8+(X-1)%3*30+(x-1)%3*10,
						2+int((X-1)/3)*30+int((x-1)/3)*10
					)
				end
			end
		end
	end
	gc.setLineWidth(.8)
	for x=0,9 do
		gc.setColor(1,1,1,x%3==0 and 1 or .3)
		gc.line(10*x,0,10*x,90)
		gc.line(0,10*x,90,10*x)
	end
	gc.pop()
	if gameover then
		setFont(60)
		if gameover==0 then
			gc.setColor(1,.6,.6)
			mStr("RED WON",180,525)
		elseif gameover==1 then
			gc.setColor(.6,.6,1)
			mStr("BLUE WON",180,525)
		else
			gc.setColor(.8,.8,.8)
			mStr("TIE",180,525)
		end
	end
end

function touchDown.play(_,x,y)
	x,y=int(x/40),int((y-140)/40)
	x,y=int(x/3)+int(y/3)*3+1,x%3+y%3*3+1
	if x<1 or x>9 or y<1 or y>9 then return end
	--Notice: x,y is not x,y
	if not board[x][y]and not score[x]and(target==x or not target)then
		board[x][y]=round
		if checkBoard(board[x],round)then
			score[x]=round
			if checkBoard(score,round)then
				gameover=round
				return
			else
				for i=1,9 do
					if not score[i]then
						goto continueGame
					end
				end
				gameover=true
				::continueGame::
			end
		else
			for i=1,9 do
				if not board[x][i]then
					goto continueGame
				end
			end
			score[x]=true
			::continueGame::
		end
		if score[y]then
			target=false
		else
			target=y
		end
		round=1-round
	end
end

function mouseDown.play(x,y)
	touchDown.play(nil,x,y)
end

WIDGET.init("play",{
	WIDGET.newButton({name="quit",text="返回",x=300,y=40,w=90,h=50,font=20,color="lY",code=WIDGET.lnk.BACK}),
	WIDGET.newButton({name="again",text="重新开始",x=300,y=100,w=90,h=50,font=20,color="lG",code=function()sceneInit.play()end,hide=function()return not gameover end}),
})