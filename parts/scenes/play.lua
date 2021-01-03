local gc=love.graphics
local int,rnd=math.floor,math.random
local sort,ins=table.sort,table.insert
local Timer=love.timer.getTime

local function full(L)--Check if L is full in 1~9
	for i=1,9 do
		if not L[i]then
			return false
		end
	end
	return true
end

local board={{},{},{},{},{},{},{},{},{}}
local point={}

local score
local lastX,lastx
local curX,curx
local round
local target
local placeTime
local gameover
local AItimer

local function restart()
	lastX,lastx=false,false
	curX,curx=nil
	round=0
	target=false
	placeTime=Timer()
	gameover=false
	if rnd()>.4 then
		AItimer=20
		round=1
	else
		AItimer=false
	end
	for X=1,9 do
		point[X]=false
		for x=1,9 do
			board[X][x]=false
		end
	end
end

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
local function checkBoard(b,p)--Check if square b is win by p
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
local function place(X,x)--Place at (X,x)
	board[X][x]=round
	lastX,lastx=X,x
	curX,curx=nil
	placeTime=Timer()
	if checkBoard(board[X],round)then
		point[X]=round
		if checkBoard(point,round)then
			gameover=round
			score[round]=score[round]+1
			return
		else
			if full(point)then
				gameover=true
				return
			end
		end
	else
		if full(board[X])then
			point[X]=true
			if full(point)then
				gameover=true
				return
			end
		end
	end
	if point[x]then
		target=false
	else
		target=x
	end
	round=1-round
end
local function amoutAdvantage(b)--Check amount advantage in board b (for current round)
	local count=0
	for i=1,9 do
		if b[i]then
			if b[i]==round then
				count=count+.5
			else
				count=count-.5
			end
		end
	end
	return count
end
local toX={1,2,3,1,2,3,1,2,3}
local toY={1,1,1,2,2,2,3,3,3}
local lineVal={--Thanks for Particle_G's idea
	{1,0,1,0,1},
	{0,1,1,1,0},
	{1,1,9,1,1},
	{0,1,1,1,0},
	{1,0,1,0,1},
}
local function valComp(a,b)
	return a[1]>b[1]
end
local function getScore(b,x)--Get score for position x(for board b)
	local sc=0

	--Calculate lining points
	for i=1,9 do
		if b[i]then
			--Try connect & block lines
			local dv=lineVal[3+toY[i]-toY[x]][3+toX[i]-toX[x]]
			if b[i]==round then
				sc=sc+dv
			else
				sc=sc+dv*1.5
			end
		end
	end

	--Avoid opponement's win
	local after=copyList(b);after[x]=1-round
	if checkBoard(after,1-round)then sc=sc+6 end

	--Check winning a square
	after=copyList(b);after[x]=round
	if checkBoard(after,round)then sc=sc+10 end

	--Avoid amout-dangerous board
	sc=sc+amoutAdvantage(board[x])

	--Avoid let opponement free
	if point[x]then sc=sc-8 end
	return sc+rnd()-.5
end
local function getAIpos()--Get a best position (X,x)
	local vals={}
	if target then
		local t=board[target]
		for x=1,9 do
			if not t[x]then
				ins(vals,{getScore(t,x),x})
			end
		end
		sort(vals,valComp)
		return target,vals[1][2]
	else
		for X=1,9 do
			if not point[X]then
				t=board[X]
				for x=1,9 do
					if not t[x]then
						ins(vals,{getScore(t,x),X,x})
					end
				end
			end
		end
		sort(vals,valComp)
		return vals[1][2],vals[1][3]
	end
end

local scene={}

function scene.sceneInit()
	score={[0]=0,0}
	restart()
	BG.set("bg2")
end

function scene.update()
	if AItimer then
		AItimer=AItimer-1
		if AItimer==0 then
			place(getAIpos())
			AItimer=false
		end
	end
end

function scene.draw()
	gc.push("transform")
	gc.translate(0,140)
	gc.scale(4)

	--Draw board
	gc.setColor(0,0,0,.4)
	gc.rectangle("fill",0,0,90,90)

	--Draw target area
	gc.setColor(1,1,AItimer and .5 or 1,math.sin((Timer()-placeTime)*5)/5+.2)
	if target then
		gc.rectangle("fill",(target-1)%3*30,int((target-1)/3)*30,30,30)
	elseif not gameover then
		gc.rectangle("fill",0,0,90,90)
	end

	--Draw cursor
	if curX then
		gc.setColor(1,1,1,.3)
		gc.rectangle("fill",(curX-1)%3*30+(curx-1)%3*10-.5,int((curX-1)/3)*30+int((curx-1)/3)*10-.5,11,11)
	end

	gc.setLineWidth(.8)
	for X=1,9 do
		if point[X]then
			if point[X]==0 then
				gc.setColor(.5,0,0)
			elseif point[X]==1 then
				gc.setColor(0,0,.5)
			else
				gc.setColor(0,0,0)
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

	--Draw board line
	gc.setLineWidth(.8)
	for x=0,9 do
		gc.setColor(1,1,1,x%3==0 and 1 or .3)
		gc.line(10*x,0,10*x,90)
		gc.line(0,10*x,90,10*x)
	end

	--Draw last pos
	if lastX then
		gc.setColor(.5,1,.4,.8)
		local r=.5+.5*math.sin(Timer()*6.26)
		gc.rectangle("line",(lastX-1)%3*30+(lastx-1)%3*10-r,int((lastX-1)/3)*30+int((lastx-1)/3)*10-r,10+2*r,10+2*r)
	end
	gc.pop()

	if gameover then
		--Draw result
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
	else
		--Draw current round mark
		gc.setColor(.8,.8,AItimer and .4 or .8,.8)
		gc.rectangle("fill",80-40,70-40,80,80)
		gc.setColor(1,1,1)
		gc.setLineWidth(3)
		gc.rectangle("line",80-40,70-40,80,80)

		gc.setLineWidth(5)
		if round==0 then
			gc.setColor(1,0,0)
			gc.circle("line",80,70,25)
		else
			gc.setColor(0,0,1)
			gc.line(80-23,70-23,80+23,70+23)
			gc.line(80-23,70+23,80+23,70-23)
		end
	end
	if AItimer then
		setFont(15)
		gc.setColor(1,1,1)
		mStr("电脑思考中...",180,90)
	end
	setFont(30)
	gc.setColor(1,.6,.6)
	mStr(score[0],50,505)
	gc.setColor(.6,.6,1)
	mStr(score[1],310,505)
end

function scene.touchDown(_,x,y)
	scene.mouseMove(x,y)
end

function scene.touchMove(_,x,y)
	scene.mouseMove(x,y)
end

function scene.touchUp(_,x,y)
	scene.mouseDown(x,y)
end

function scene.mouseMove(x,y)
	x,y=int(x/40),int((y-140)/40)
	curX,curx=int(x/3)+int(y/3)*3+1,x%3+y%3*3+1
	if
		curX<1 or curX>9 or
		curx<1 or curx>9 or
		AItimer or
		point[curX]or
		not(target==curX or not target)or
		board[curX][curx]or
		gameover
	then
		curX,curx=nil
	end
end

function scene.mouseDown(x,y)
	scene.mouseMove(x,y)
	if curX then
		place(curX,curx)
		if not gameover then
			AItimer=rnd(40,80)
		end
	end
end

scene.widgetList={
	WIDGET.newButton({name="quit",text="返回",x=300,y=40,w=90,h=50,font=20,color="lY",code=WIDGET.lnk_BACK}),
	WIDGET.newButton({name="again",text="重新开始",x=300,y=100,w=90,h=50,font=20,color="lG",code=restart,hide=function()return not gameover end}),
}

return scene