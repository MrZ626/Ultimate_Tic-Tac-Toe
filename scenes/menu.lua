local gc=love.graphics

function sceneInit.menu()
	BG.set("bg1")
end

function Pnt.menu()
	gc.setColor(1,1,1)
	setFont(60)
	gc.print("Ultimate",30,30)
	setFont(45)
	gc.print("Tic-Tac-Toe",80,90)
end

WIDGET.init("menu",{
	WIDGET.newButton({name="play",text="开始",x=180,y=300,w=180,h=80,color="lG",code=WIDGET.lnk.goScene("play")}),
	WIDGET.newButton({name="quit",text="退出",x=180,y=400,w=180,h=80,color="lR",code=function()SCN.swapTo("quit","slowFade")end}),
})