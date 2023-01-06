-- Include useful files or existing libraries. These are found in the `Scripts`
-- folder.
u_execScript("bc/utils.lua")
u_execScript("bc/common.lua")
u_execScript("bc/commonpatterns.lua")

loopcount = 1
nextLoop = 0.35
-- This function adds a pattern to the level "timeline" based on a numeric key.
function addPattern(mKey)
		if mKey == 0 then pAltBarrage(math.random(2, 4), 2)
	elseif mKey == 1 then pMirrorSpiral(math.random(2, 5), getHalfSides() - 3)
	elseif mKey == 2 then pBarrageSpiral(math.random(0, 3), 1, 1)
	elseif mKey == 3 then pInverseBarrage(0)
	elseif mKey == 4 then pTunnel(math.random(1, 3))
	elseif mKey == 5 then pSpiral(l_getSides() * math.random(1, 2), 0)
	end
end
beatCount = 0
-- Shuffle the keys, and then call them to add all the patterns.
-- Shuffling is better than randomizing - it guarantees all the patterns will
-- be called.
keys = { 0, 0, 1, 1, 2, 2, 3, 3, 4, 5, 5 }
shuffle(keys)
index = 0
achievementUnlocked = false
t3ddir = true
t3dskew = 0
FFrames = 0
blackflash = shdr_getShaderId("bc_perspective.frag")
move1 = false
move2 = false
move3 = false
function pointSpin(theta, x, y, a)
	local r = math.sqrt((x*x) + (y*y))
	local ct = math.atan2(y, x)
	ct = ct + theta
	if a then
		return r * math.cos(ct)
	else
		return r * math.sin(ct)
	end
end

function cwspin(cw, theta)
	--convert to polar
	local x0, y0 = cw_getVertexPos(cw, 0)
	local x1, y1 = cw_getVertexPos(cw, 1)
	local x2, y2 = cw_getVertexPos(cw, 2)
	local x3, y3 = cw_getVertexPos(cw, 3)

	cw_setVertexPos4(cw, pointSpin(theta, x0, y0, true), pointSpin(theta, x0, y0, false), pointSpin(theta, x1, y1, true), pointSpin(theta, x1, y1, false), pointSpin(theta, x2, y2, true), pointSpin(theta, x2, y2, false), pointSpin(theta, x3, y3, true), pointSpin(theta, x3, y3, false))
end

function cwtoggle(cw)
	if cw_getDeadly(cw) then
		cw_setVertexColor4Same(cw, 230, 0, 0, 1)
		cw_setDeadly(cw, false)
		cw_setCollision(cw, false)
	else
		cw_setVertexColor4Same(cw, 255, 0, 0, 255)
		cw_setDeadly(cw, true)
		cw_setCollision(cw, true)
	end
end
function hardPulse()
    --the fast beat pulse
    l_setManualPulseControl(true)
    l_setPulse(120)
    l_setManualPulseControl(false) -- i have no clue whether i actually need to reset the pulse each cycle
    l_setPulseMin(60)
    l_setPulseMax(120)
    l_setPulseSpeed(1200)
    l_setPulseSpeedR(6800/2281)
    l_setPulseDelayMax(1)

end
function slowPulse()
    l_setManualPulseControl(true)
    l_setPulse(120)
    l_setManualPulseControl(false)
    l_setPulseMin(60)
    l_setPulseMax(120)
    l_setPulseSpeed(10)
    l_setPulseSpeedR(170/223)
    l_setPulseDelayMax(0)
end
function stopPulse(rad)
    l_setPulseMin(rad)
    l_setPulseMax(rad)
    l_setRadiusMin(rad)
    l_setPulseSpeed(0)
    l_setPulseSpeedR(0)
    l_setPulseDelayMax(0)
    l_setBeatPulseMax(0)
    l_setBeatPulseDelayMax(0)
    l_setBeatPulseSpeedMult(0)
end
-- `onInit` is an hardcoded function that is called when the level is first
-- loaded. This can be used to setup initial level parameters.
function onInit()
	l_setSpeedMult(2.75)
	l_setSpeedInc(0.125)
	l_setSpeedMax(3.5)
	l_setRotationSpeed(0)
	l_setRotationSpeedMax(9999)
	l_setRotationSpeedInc(0)
	l_setDelayMult(1.0)
	l_setDelayInc(-0.01)
	l_setFastSpin(0.0)
	l_setSides(6)
	l_setSidesMin(5)
	l_setSidesMax(6)
	l_setIncTime(15)

	l_setPulseMin(60)
	l_setPulseMax(100)
	l_setPulseSpeed(4)
	l_setPulseSpeedR(2)
	l_setPulseDelayMax(18)

	l_setDarkenUnevenBackgroundChunk(false)
	l_setBeatPulseMax(17)
	l_setBeatPulseDelayMax(21.818181818181818181818181818182)

	enableSwapIfDMGreaterThan(2.5)
	disableIncIfDMGreaterThan(3)
end
testw1 = cw_createNoCollision()
-- `onLoad` is an hardcoded function that is called when the level is started
-- or restarted.
cwdiv1 = cw_createNoCollision()
cw_setVertexPos(cwdiv1, 0, 18, 500)
cw_setVertexPos(cwdiv1, 1, 18, -500)
cw_setVertexPos(cwdiv1, 2, -18, -500)
cw_setVertexPos(cwdiv1, 3, -18, 500)
cw_setVertexColor4Same(cwdiv1, 230, 0, 0, 1)
cwdiv2 = cw_createNoCollision()
cw_setVertexPos(cwdiv2, 0, 18, 500)
cw_setVertexPos(cwdiv2, 1, 18, -500)
cw_setVertexPos(cwdiv2, 2, -18, -500)
cw_setVertexPos(cwdiv2, 3, -18, 500)
cw_setVertexColor4Same(cwdiv2, 230, 230, 0, 1)
cwdiv3 = cw_createNoCollision()
cw_setVertexPos(cwdiv3, 0, 18, 500)
cw_setVertexPos(cwdiv3, 1, 18, -500)
cw_setVertexPos(cwdiv3, 2, -18, -500)
cw_setVertexPos(cwdiv3, 3, -18, 500)
cw_setVertexColor4Same(cwdiv3, 230, 0, 230, 1)

function onLoad()
    e_eval([[s_setStyle("bc_kespre1")]])
    e_eval([[stopPulse(120)]])
    e_eval([[t_waitS(400)]])
    e_eval([[u_clearWalls()]])

    e_eval([[l_setRotationSpeed(0)]])
    e_eval([[l_setRotation(0)]])
	
	e_waitUntilS(0.261)
	e_eval([[move2 = true]])
	e_waitUntilS(0.261 + 0.11)
	e_eval([[move2 = false]])
	
	e_waitUntilS(0.62)
	e_eval([[move3 = true]])

	e_waitUntilS(0.62 + 0.11)
	e_eval([[move3 = false]])

	e_waitUntilS(0.98)
	e_eval([[cwtoggle(cwdiv1)]])
	e_eval([[cwtoggle(cwdiv2)]])
	e_eval([[cwtoggle(cwdiv3)]])

	e_waitUntilS(1.35)
	e_eval([[cwtoggle(cwdiv1)]])

	e_waitUntilS(1.351)
    e_eval([[shdr_setActiveFragmentShader(RenderStage.BACKGROUNDTRIS, blackflash)]])
    e_eval([[u_setFlashEffect(255)]])
    e_eval([[kiai21 = true]])
    e_eval([[hardPulse()]])
	e_eval([[move2 = false]])
    e_eval([[l_setRadiusMin(60)]])
    e_eval([[l_setBeatPulseMax(10)]])
    e_eval([[l_setBeatPulseDelayMax(21.176470588235294117647058823529)]])
    e_eval([[l_setBeatPulseSpeedMult(1)]])
    e_eval([[l_setRotationSpeed(-0.8)]])
    e_eval([[t_clear()]])
	--m_messageAdd("pretty", 130)
end

-- `onStep` is an hardcoded function that is called when the level "timeline"
-- is empty. The level timeline is a queue of pending actions.
-- `onStep` should generally contain your pattern spawning logic.
function onStep()
	addPattern(keys[index])
	index = index + 1

	if index - 1 == #keys then
		index = 1
		shuffle(keys)
	end
end

-- `onIncrement` is an hardcoded function that is called when the level
-- difficulty is incremented.
function onIncrement()
	-- ...
end


-- `onUnload` is an hardcoded function that is called when the level is
-- closed/restarted.
function onUnload()
	-- ...
end
ibeatCount = 0
-- `onUpdate` is an hardcoded function that is called every frame. `mFrameTime`
-- represents the time delta between the current and previous frame.
function onUpdate(mFrameTime)
	if l_getLevelTime() > nextLoop then -- clock

        loopcount = loopcount + 1
        nextLoop = loopcount * (60/170) -- bpm = 170

        --on beat events
        beatCount = beatCount + 1
		if kiai21 then
			if beatCount % 3 == 0 then
				cwtoggle(cwdiv1)
			elseif beatCount % 3 == 1 then
				cwtoggle(cwdiv2)
			else
				cwtoggle(cwdiv3)
			end
		end
		ibeatCount = 0
    end

	if kiai21 then
		if ibeatCount == 10 then
			if cw_getDeadly(cwdiv1) then
				cwtoggle(cwdiv1)
			elseif cw_getDeadly(cwdiv2) then
				cwtoggle(cwdiv2)
			elseif cw_getDeadly(cwdiv3) then
				cwtoggle(cwdiv3)
			end
		end
	end

	if move2 then
		cwspin(cwdiv2, (((3.141592653589793642/3.0)*2)/27))
	elseif move3 then
		cwspin(cwdiv3, -(((3.141592653589793642/3.0)*2)/27))
	end
	FFrames = FFrames + 1
	if FFrames % 240 == 0 then
		if t3ddir then
			t3ddir = false
		else
			t3ddir = true
		end
	end
	if t3ddir then
		t3dskew = t3dskew + 0.00
	else
		t3dskew = t3dskew - 0.00
	end
	--s_set3dSkew(t3dskew)
	s_set3dSkew(0.1)
	ibeatCount = ibeatCount + 1
end
function onRenderStage(rs) --cringe

	shdr_setUniformFVec2(blackflash, "u_resolution", u_getWidth(), u_getHeight())
	shdr_setUniformF(blackflash, "u_rotation", math.rad(l_getRotation()))
	shdr_setUniformF(blackflash, "u_skew", s_get3dSkew())
	shdr_setUniformF(blackflash, "u_time", l_getLevelTime())
end