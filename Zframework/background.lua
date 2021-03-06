local BGlist={
	none={
		draw=function()
			love.graphics.clear(.15,.15,.15)
		end
	}
}
local BG={
	cur="none",
	defaultBG="none",
	init=false,
	resize=false,
	update=NULL,
	draw=BGlist.none.draw,
	event=false,
	discard=NULL,
}

function BG.add(name,bg)
	BGlist[name]=bg
end
function BG.send(...)
	if BG.event then
		BG.event(...)
	end
end
function BG.setDefaultBG(bg)
	defaultBG=bg
end
function BG.set(background)
	if not background then
		background=defaultBG
	end
	if background==BG.cur then return end
	BG.discard()
	BG.cur=background
	background=BGlist[background]
	if not background then
		LOG.print("No BG called"..background,"warn")
		return
	end

	BG.init=	background.init or NULL
	BG.resize=	background.resize or NULL
	BG.update=	background.update or NULL
	BG.draw=	background.draw or NULL
	BG.event=	background.event or NULL
	BG.discard=	background.discard or NULL
	BG.init()
end
return BG