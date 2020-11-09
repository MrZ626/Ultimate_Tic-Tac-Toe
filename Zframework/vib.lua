local level={.015,.02,.03,.04,.05}
local VIB=love.system.vibrate
return function(t)
	VIB(level[t])
end