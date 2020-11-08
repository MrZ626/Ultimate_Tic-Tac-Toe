local IMG={
	batteryImage="power.png",
	snow="life.png",
}
local list={}
local count=0
for k,_ in next,IMG do
	count=count+1
	list[count]=k
end
function IMG.getCount()
	return count
end
function IMG.loadOne(_)
	local N=list[_]
	IMG[N]=love.graphics.newImage("/image/"..IMG[N])
end
function IMG.loadAll()
	for i=1,count do
		IMG.loadOne(i)
	end
end
return IMG