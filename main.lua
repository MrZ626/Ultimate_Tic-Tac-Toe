local fs=love.filesystem
function NULL()end
math.randomseed(os.time()*626)
love.mouse.setVisible(false)

SYSTEM=love.system.getOS()
VERSION="V0.9"
MOBILE=SYSTEM=="Android"or SYSTEM=="iOS"
SETTING={
	sfx=true,
	bgm=true,
	vib=true,
}
EDITING=""

require("Zframework")--Load framework

SCR.setSize(360,640)--Initialize Screen size

SFX.set{}BGM.set{}VOC.set{}

--Load shader files
SHADER={}
for _,v in next,love.filesystem.getDirectoryItems("shaders")do
	local name=v:sub(1,-6)
	SHADER[name]=love.graphics.newShader("shaders/"..name..".glsl")
end

--Load background files
for _,v in next,fs.getDirectoryItems("backgrounds")do
	local name=v:sub(1,-5)
	BG.add(name,require("backgrounds/"..name))
end

--Load scene files
for _,v in next,fs.getDirectoryItems("scenes")do
	require("scenes/"..v:sub(1,-5))
end

IMG.loadAll()