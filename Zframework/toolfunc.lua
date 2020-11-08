local gc=love.graphics
local int=math.floor
local sub,find,format=string.sub,string.find,string.format

do--setFont
	local newFont=gc.setNewFont
	local setNewFont=gc.setFont
	local fontCache,currentFontSize={}
	if love.filesystem.getInfo("font.ttf")then
		local fontData=love.filesystem.newFile("font.ttf")
		function setFont(s)
			if s~=currentFontSize then
				if not fontCache[s]then
					fontCache[s]=newFont(fontData,s)
				end
				setNewFont(fontCache[s])
				currentFontSize=s
			end
		end
		function getFont(s)
			if not fontCache[s]then
				fontCache[s]=newFont(fontData,s)
			end
			return fontCache[s]
		end
	else
		function setFont(s)
			if s~=currentFontSize then
				if not fontCache[s]then
					fontCache[s]=newFont(s)
				end
				setNewFont(fontCache[s])
				currentFontSize=s
			end
		end
		function getFont(s)
			if not fontCache[s]then
				fontCache[s]=newFont(s)
			end
			return fontCache[s]
		end
	end
end
do--dumpTable
	local tabs={
		[0]="",
		"\t",
		"\t\t",
		"\t\t\t",
		"\t\t\t\t",
		"\t\t\t\t\t",
		"\t\t\t\t\t\t",
		"\t\t\t\t\t\t\t",
	}
	function dumpTable(L,t)
		local s
		if t then
			s="{\n"
		else
			s="return{\n"
			t=1
		end
		if t>7 then return ""end
		local count=1
		for k,v in next,L do
			local T=type(k)
			if T=="number"then
				if k==count then
					k=""
					count=count+1
				else
					k="["..k.."]="
				end
			elseif T=="string"then
				if find(k,"[^0-9a-zA-Z_]")then
					k="[\""..k.."\"]="
				else
					k=k.."="
				end
			elseif T=="boolean"then k="["..k.."]="
			else assert(false,"Error key type!")
			end
			T=type(v)
			if T=="number"then v=tostring(v)
			elseif T=="string"then v="\""..v.."\""
			elseif T=="table"then v=dumpTable(v,t+1)
			else v=tostring(v)
			-- else assert(false,"Error data type!")
			end
			s=s..tabs[t]..k..v..",\n"
		end
		return s..tabs[t-1].."}"
	end
end
function copyList(org)
	local L={}
	for i=1,#org do
		if type(org[i])~="table"then
			L[i]=org[i]
		else
			L[i]=copyList(org[i])
		end
	end
	return L
end
function copyTable(org)
	local L={}
	for k,v in next,org do
		if type(v)~="table"then
			L[k]=v
		else
			L[k]=copyTable(v)
		end
	end
	return L
end
function addToTable(G,base)--For all things in G if same type in base, push to base
	for k,v in next,G do
		if type(v)==type(base[k])then
			if type(v)=="table"then
				addToTable(v,base[k])
			else
				base[k]=v
			end
		end
	end
end
function completeTable(G,base)--For all things in G if no val in base, push to base
	for k,v in next,G do
		if base[k]==nil then
			base[k]=v
		elseif type(v)=="table"and type(base[k])=="table"then
			completeTable(v,base[k])
		end
	end
end
function splitStr(s,sep)
	local L={}
	local p1,p2=1--start,target
	while p1<=#s do
		p2=find(s,sep,p1)or #s+1
		L[#L+1]=sub(s,p1,p2-1)
		p1=p2+#sep
	end
	return L
end
function toTime(s)
	if s<60 then
		return format("%.3fs",s)
	elseif s<3600 then
		return format("%d:%.2f",int(s/60),s%60)
	else
		local h=int(s/3600)
		return format("%d:%d:%.2f",h,int(s/60%60),s%60)
	end
end
function mStr(s,x,y)
	gc.printf(s,x-626,y,1252,"center")
end
function mText(s,x,y)
	gc.draw(s,x-s:getWidth()*.5,y)
end
function mDraw(s,x,y,a,k)
	gc.draw(s,x,y,a,k,nil,s:getWidth()*.5,s:getHeight()*.5)
end