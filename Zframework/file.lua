local fs=love.filesystem

local files={
	data=	fs.newFile("data.dat"),
	setting=fs.newFile("settings.dat"),
}

local FILE={}
function FILE.loadSetting()
	local F=files.setting
	if F:open("r")then
		local s=F:read()
		if s:sub(1,6)~="return"then
			s="return{"..s:gsub("\n",",").."}"
		end
		s=loadstring(s)
		F:close()
		if s then
			setfenv(s,{})
			addToTable(s(),SETTING)
		end
	end
end
function FILE.saveSetting()
	local F=files.setting
	F:open("w")
	local _,mes=F:write(dumpTable(SETTING))
	F:flush()F:close()
	if _ then LOG.print("Setting Saved",COLOR.green)
	else LOG.print("Setting Saving Error"..(mes or"unknown error"),COLOR.red)
	end
end

return FILE