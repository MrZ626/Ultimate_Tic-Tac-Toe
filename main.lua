local fs=love.filesystem
NONE={}function NULL()end
DBP=print--Use this in permanent code
TIME=love.timer.getTime
math.randomseed(os.time()*626)
love.mouse.setVisible(false)

SAVEDIR=fs.getSaveDirectory()
SYSTEM=love.system.getOS()
VERSION="V0.9"
MOBILE=SYSTEM=="Android"or SYSTEM=="iOS"
SETTING={
	sfx=1,
	bgm=1,
	vib=1,
}
EDITING=""
require"Zframework"--Load framework

SCR.setSize(360,640)--Initialize Screen size

IMG.init{
	batteryImage="power.png",
	snow="life.png",
}IMG.loadAll()
SFX.init{
	"move",
	"button",
	"win",
	"fail",
	"tie",
	"reach",
}SFX.loadAll()
BGM.init{"title","play"}BGM.loadAll()
VOC.init{}VOC.loadAll()

--Load shader files from SOURCE ONLY
SHADER={}
for _,v in next,love.filesystem.getDirectoryItems("parts/shaders")do
	if love.filesystem.getRealDirectory("parts/shaders/"..v)~=SAVEDIR then
		local name=v:sub(1,-6)
		SHADER[name]=love.graphics.newShader("parts/shaders/"..name..".glsl")
	else
		LOG.print("Dangerous file : %SAVE%/parts/shaders/"..v)
	end
end

--Load background files from SOURCE ONLY
for _,v in next,love.filesystem.getDirectoryItems("parts/backgrounds")do
	if love.filesystem.getRealDirectory("parts/backgrounds/"..v)~=SAVEDIR then
		local name=v:sub(1,-5)
		BG.add(name,require("parts/backgrounds/"..name))
	else
		LOG.print("Dangerous file : %SAVE%/parts/backgrounds/"..v)
	end
end

--Load scene files from SOURCE ONLY
for _,v in next,fs.getDirectoryItems("parts/scenes")do
	if fs.getRealDirectory("parts/scenes/"..v)~=SAVEDIR then
		local sceneName=v:sub(1,-5)
		SCN.add(sceneName,require("parts/scenes/"..sceneName))
	else
		LOG.print("Dangerous file : %SAVE%/parts/scenes/"..v)
	end
end