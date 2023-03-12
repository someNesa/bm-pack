-- include useful files
u_execScript("pagoda/utils.lua")
u_execScript("pagoda/common.lua")
u_execScript("pagoda/commonpatterns.lua")
--hexadorsip patterns
u_execScript("pagoda/commonpatternsv2.lua")
u_execScript("pagoda/expatterns.lua")
u_execScript("pagoda/hxdshexpatterns.lua")

beatCount = 0
BPM = 120

function c_spinupcos(startRot, endRot, duration, start, curFrame)
    --follow inverted cosine curve
    l_setRotationSpeed(((-(math.cos(((curFrame-(start*240))/(duration*240)))) + 1)*(endRot-startRot))+startRot)
end

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

respulse = false
function hardPulse()
    local min = 90
    local max = 120
    local speed = 1200
    local delayMax = 1
    --the fast beat pulse
    l_setManualPulseControl(true)
    l_setPulse(max)
    l_setManualPulseControl(false) -- i have no clue whether i actually need to reset the pulse each cycle
    l_setPulseMin(min)
    l_setPulseMax(max)
    l_setPulseSpeed(speed)

    --calculated to finish at end of each beat
    l_setPulseSpeedR(((BPM*speed)*(max-min))/((3600*speed)-((max-min)*BPM)-(BPM*speed*delayMax)))

    l_setPulseDelayMax(delayMax)

end
function slowPulse()
    local min = 90
    local max = 120
    local speed = 3
    local delayMax = 1
    --the fast beat pulse
    l_setManualPulseControl(true)
    l_setPulse(min+10)
    l_setManualPulseControl(false) -- i have no clue whether i actually need to reset the pulse each cycle
    l_setPulseMin(min)
    l_setPulseMax(max)
    l_setPulseSpeed(speed)

    --calculated to finish at end of each beat
    l_setPulseSpeedR(((BPM*speed)*(max-min))/((3600*speed)-((max-min)*BPM)-(BPM*speed*delayMax)))

    l_setPulseDelayMax(delayMax)
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

cPool = "sHex"
function shapeChange(nSides, patSet)
    l_setSides(nSides)
    cPool = patSet
end

--hex patterns from hexadorsip

-- this function adds a pattern to the timeline based on a key

function addPattern(mKey)
    --hex patterns from Hexadorsip
		if mKey == 0 then pAltBarrage(math.random(3, 5), 2)
        elseif mKey == 1 then pAltBarrageThick(0, 2)
        elseif mKey == 2 then pBarrageSpiralLeft(math.random(2, 3), 0.85, 1)
        elseif mKey == 3 then pBackAndForth(math.random(3, 4), 0.83)
        elseif mKey == 4 then pBarrageSpiralDouble(math.random(1, 2), 0.96, 1)
        elseif mKey == 5 then pDMInverseBarrage(math.random(1, 2), 1.36)
        elseif mKey == 6 then pMirrorWallStrip(1, 0)
        elseif mKey == 7 then pMirrorWallStripThick(0, 1)
        elseif mKey == 8 then pRandomBarrage(math.random(2, 5), 3.2)
        elseif mKey == 9 then pTunnel(math.random(1, 2))
        elseif mKey == 10 then pTunnelQuadruple(math.random(3, 4), 0.84)
        elseif mKey == 11 then pWallExVortexLL(0, 3, 1)
        elseif mKey == 12 then pBarrageSpiralLR(math.random(2, 3), 1)
        elseif mKey == 13 then pAltBarrageStrip(1, 0)
    end
end

-- shuffle the keys, and then call them to add all the patterns
-- shuffling is better than randomizing - it guarantees all the patterns will be called

sHexKeys = { 0, 0, 1, 2, 3, 3, 4, 5, 5, 6, 7, 8, 8, 11, 12, 12, 13 }

bOnlyHexKeys = { 8, 8, 8 } -- idk maybe use somewhere

index = 1

shuffle(sHexKeys)

--frame keeping
frameCounter = 0
interBeatCounter = 0

--clock control
loopcount = 1
nextLoop = 0.35

--skew control
skewDirection = true
skewFrequency = 0.0
skewMax = 2.0
skewMin = 0.0
skewInput = 0.0

-- onInit is an hardcoded function that is called when the level is first loaded
function onInit()
    l_setSpeedMult(2.5)

	l_setSpeedInc(0.125)
    l_setSpeedMax(99999)
    l_setRotationSpeed(-0.5)
    l_setRotationSpeedMax(9999)
    l_setRotationSpeedInc(0.1)

    l_setDelayMult(1.10)
    
    l_setDelayMult(1.60)
    l_setDelayInc(0)
    l_setFastSpin(1.6)
    l_setSides(6)
    l_setSidesMin(6)
    l_setSidesMax(6)

    l_setIncTime(30)

    l_setPulseInitialDelay(0.99999)
    l_setPulseMin(60)
    l_setPulseMax(100)
    l_setPulseSpeed(240)
    l_setPulseSpeedR(2)
    l_setPulseDelayMax(30)

    l_setBeatPulseMax(10)
    l_setBeatPulseDelayMax(30)
    l_setBeatPulseSpeedMult(1) -- Slows down the center going back to normal

end

edges = shdr_getShaderId("pagoda_edges.frag")
edgesWall = shdr_getShaderId("pagoda_edges_wall.frag")
desync = true
screenPulse = true

-- onLoad is an hardcoded function that is called when the level is started/restarted
function onLoad()
    e_eval([[s_setStyle("pagoda_lower")]])
    e_eval([[slowPulse()]])
    e_eval([[shdr_setActiveFragmentShader(RenderStage.BACKGROUNDTRIS, edges)]])
	e_eval([[shdr_setActiveFragmentShader(RenderStage.WALLQUADS, edgesWall)]])
end

-- onStep is an hardcoded function that is called when the level timeline is empty
-- onStep should contain your pattern spawning logic
function onStep()
    if index > #sHexKeys then
        index = 1
        shuffle(sHexKeys)
    end
    addPattern(sHexKeys[index])
    index = index + 1
end

-- onIncrement is an hardcoded function that is called when the level difficulty is incremented
function onIncrement()
end

-- onUnload is an hardcoded function that is called when the level is closed/restarted
function onUnload()
end

-- continuous direction change (even if not on level increment)
-- onUpdate is an hardcoded function that is called every frame
function onUpdate(mFrameTime)
    if l_getLevelTime() > nextLoop then -- clock

        loopcount = loopcount + 1
        nextLoop = loopcount * (60/BPM) -- bpm = BPM


        interBeatCounter = 0
        beatCount = beatCount + 1
    end
    
    if frameCounter % 2 == 0 then
        s_set3dSkew(-2.4)
    else
        s_set3dSkew(0.4)
    end

    frameCounter = frameCounter + 1
    interBeatCounter = interBeatCounter + 1
end

function onRenderStage(rs) --cringe
	shdr_setUniformFVec2(edges, "u_resolution", u_getWidth(), u_getHeight())
	shdr_setUniformF(edges, "u_rotation", math.rad(l_getRotation()))
	shdr_setUniformF(edges, "u_skew", s_get3dSkew())
	shdr_setUniformF(edges, "u_time", l_getLevelTime())

	shdr_setUniformFVec2(edgesWall, "u_resolution", u_getWidth(), u_getHeight())
	shdr_setUniformF(edgesWall, "u_rotation", math.rad(l_getRotation()))
	shdr_setUniformF(edgesWall, "u_skew", s_get3dSkew())
	shdr_setUniformF(edgesWall, "u_time", l_getLevelTime())
end