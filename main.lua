local fs=love.filesystem
function NULL()end
math.randomseed(os.time()*626)
love.mouse.setVisible(false)

SYSTEM=love.system.getOS()
gameVersion="V0.9"
MOBILE=SYSTEM=="Android"or SYSTEM=="iOS"
SCR={
	x=0,y=0,--Up-left Coord on screen
	w=0,h=0,--Fullscreen w/h in gc
	W=0,H=0,--Fullscreen w/h in shader
	rad=0,--Radius
	k=1,--Scale size
	dpi=1--DPI from gc.getDPIScale()
}--1280:720-Rect Screen Info
SETTING={
	sfx=1,
	bgm=.7,
	vib=0,
}
EDITING=""


require("Zframework")--Load framework
--Load Scene files
for _,v in next,fs.getDirectoryItems("scenes")do
	require("scenes/"..v:sub(1,-5))
end

IMG.loadAll()