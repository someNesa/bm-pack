-- include useful files
u_execScript("bc/utils.lua")
u_execScript("bc/common.lua")
u_execScript("bc/commonpatterns.lua")
--hexadorsip patterns
u_execScript("bc/commonpatternsv2.lua")
u_execScript("bc/expatterns.lua")
u_execScript("bc/hxdshexpatterns.lua")
--insight patterns
u_execScript("bc/sSquP.lua")

-- things
cPool = "sHex"
beatCount = 0
BPM = 140 -- in case song needs to be switched

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

function cwtoggle(cw)
	if cw_getDeadly(cw) then
		cw_setVertexColor4Same(cw, 30, 30, 30, 200)
		cw_setDeadly(cw, false)
		cw_setCollision(cw, false)
	else
		cw_setVertexColor4Same(cw, 255, 0, 0, 255)
		cw_setDeadly(cw, true)
		cw_setCollision(cw, true)
	end
end

--wall init
divwid = 10
cwdiv1 = cw_createNoCollision()
cwdiv2 = cw_createNoCollision()
cwdiv3 = cw_createNoCollision()

function cwspawnd2() 
    cw_setVertexPos(cwdiv1, 0, divwid, 1000)
    cw_setVertexPos(cwdiv1, 1, divwid, -1000)
    cw_setVertexPos(cwdiv1, 2, -divwid, -1000)
    cw_setVertexPos(cwdiv1, 3, -divwid, 1000)
    cw_setVertexColor4Same(cwdiv1, 30, 30, 30, 200)
    cw_setVertexPos(cwdiv2, 0, divwid, 1000)
    cw_setVertexPos(cwdiv2, 1, divwid, -1000)
    cw_setVertexPos(cwdiv2, 2, -divwid, -1000)
    cw_setVertexPos(cwdiv2, 3, -divwid, 1000)
    cw_setVertexColor4Same(cwdiv2, 30, 30, 30, 200)
    cw_setVertexPos(cwdiv3, 0, divwid, 1000)
    cw_setVertexPos(cwdiv3, 1, divwid, -1000)
    cw_setVertexPos(cwdiv3, 2, -divwid, -1000)
    cw_setVertexPos(cwdiv3, 3, -divwid, 1000)
    cw_setVertexColor4Same(cwdiv3, 30, 30, 30, 200)
end

respulse = false
function hardPulse()
    --the fast beat pulse
    l_setManualPulseControl(true)
    l_setPulse(120)
    l_setManualPulseControl(false) -- i have no clue whether i actually need to reset the pulse each cycle
    l_setPulseMin(60)
    l_setPulseMax(120)
    l_setPulseSpeed(1200)
    l_setPulseSpeedR((400*BPM)/(24000-(7*BPM)))
    l_setPulseDelayMax(1)

end
function slowPulse()
    l_setManualPulseControl(true)
    l_setPulse(120)
    l_setManualPulseControl(false)
    l_setPulseMin(60)
    l_setPulseMax(120)
    l_setPulseSpeed(10)
    l_setPulseSpeedR((10*BPM)/(600-BPM))
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

    --oct patterns from fruitblues
        elseif mKey == 90 then pAltBarrage(math.random(2, 4), 2) 
        elseif mKey == 91 then pMirrorSpiral(math.random(2, 5), getHalfSides() - 3)
        elseif mKey == 92 then pBarrageSpiral(math.random(0, 3), 1, 1)
        elseif mKey == 93 then pInverseBarrage(0)
        elseif mKey == 910 then pRandomBarrage(math.random(2, 4), 2.25)
        elseif mKey == 912 then pMirrorWallStrip(2, 0)
        elseif mKey == 913 then pWallExVortex(0, 2, 1)

    --square patterns from insight
        elseif mKey == 80 then pDMTunnel(u_rndInt(3, 6), 0.75)
        elseif mKey == 82 then pBarrageSpiral(u_rndInt(2, 4), 0.95, 1)
        elseif mKey == 83 then pBarrageSpiralLR(u_rndInt(1, 2), 1.50)
        elseif mKey == 85 then pRandomBarrage(u_rndInt(4, 10), 3.3)
        elseif mKey == 86 then pDMTriSingleSpiralAllDir(u_rndInt(8, 8), 1, 0.9)	
        elseif mKey == 87 then pBarrageSpiral(u_rndInt(4, 8), 0.55, 1)
        elseif mKey == 88 then pBarrageSpiralLR(u_rndInt(3, 4), 0.95)	
        elseif mKey == 89 then pDMTriSingleSpiralAllDir(u_rndInt(8, 8), 0, 0.9)
    end
end

-- shuffle the keys, and then call them to add all the patterns
-- shuffling is better than randomizing - it guarantees all the patterns will be called

sHexKeys = { 0, 0, 1, 2, 3, 3, 4, 5, 5, 6, 7, 8, 8, 11, 12, 12, 13 }
sOctKeys = { 90, 91, 92, 93, 910, 910, 910, 912, 912, 913, 913, 914 }
sSquKeys = { 80, 82, 82, 83, 83, 85, 85, 85, 86, 87, 88, 89 }

bOnlyHexKeys = { 8, 8, 8 } -- idk maybe use somewhere

index = 1

shuffle(sOctKeys)
shuffle(sHexKeys)
shuffle(sSquKeys)

frameCounter = 0
interBeatCounter = 0
ticker = false

kiai1 = false

cwmoved2 = false
kiai2 = false

nspin1 = false

loopcount = 1
nextLoop = 0.35
noWallSpawn = false

skewDirection = true
skewPeriod = 0.0
skewMax = 2.0
skewMin = 0.0
skewInput = 0.0

--shader files
gridshade = shdr_getShaderId("bc_grid.frag")
gridgraid = shdr_getShaderId("bc_gridgrai.frag")
gridshadetran = shdr_getShaderId("bc_gridtran1.frag")
blackshade = shdr_getShaderId("bc_black.frag")
blackflash = shdr_getShaderId("bc_blackflash.frag")
whiteflash = shdr_getShaderId("bc_whiteflash.frag")
perspective = shdr_getShaderId("bc_perspective.frag")
firstflashes = shdr_getShaderId("bc_firstflashes.frag")
redglow = shdr_getShaderId("bc_redglow.frag")
screenpulse = shdr_getShaderId("bc_screenpulse.frag")
trilattice = shdr_getShaderId("bc_trilattice.frag")
trilatticecolors = shdr_getShaderId("bc_trilatticecolors.frag")

shaderCols = 0

-- onInit is an hardcoded function that is called when the level is first loaded
function onInit()
    if u_getDifficultyMult() == 1.0 then
        l_setSpeedMult(3.4)
    elseif u_getDifficultyMult() > 1.0 then
        l_setSpeedMult(3.7)
    elseif u_getDifficultyMult() < 1.0 then
        l_setSpeedMult(3.1)
    end

    l_setSpeedInc(0)
    l_setSpeedMax(99999)
    l_setRotationSpeed(0)
    l_setRotationSpeedMax(9999)
    l_setRotationSpeedInc(0)

    l_setDelayMult(1.10)
    
    if u_getDifficultyMult() == 1.0 then
        l_setDelayMult(1.20)
    elseif u_getDifficultyMult() > 1.0 then
        l_setDelayMult(1.00)
        divwid = 18
    elseif u_getDifficultyMult() < 1.0 then
        l_setDelayMult(1.60)
        divwid = 5
    end
    l_setDelayInc(0)
    l_setFastSpin(1.6)
    l_setSides(6)
    l_setSidesMin(3)
    l_setSidesMax(99)

    l_setIncTime(99999999999)

    l_setPulseInitialDelay(0.99999)
    l_setPulseMin(60)
    l_setPulseMax(100)
    l_setPulseSpeed(240)
    l_setPulseSpeedR(2)
    l_setPulseDelayMax(1.0098039215)

    l_setBeatPulseMax(10)
    l_setBeatPulseDelayMax(21.176470588235294117647058823529)
    l_setBeatPulseSpeedMult(1) -- Slows down the center going back to normal

end

-- onLoad is an hardcoded function that is called when the level is started/restarted
function onLoad()
    --offset: 253 ms
    --1 beat: (60/140)
    e_eval([[t_waitS(0.428)]])
    e_eval([[u_setFlashEffect(255)]])
    e_waitUntilS((60/140)*0.25)
    e_eval([[u_setFlashEffect(255)]])
    e_waitUntilS((60/140)*0.5)
    e_eval([[u_setFlashEffect(255)]])
    e_waitUntilS((60/140)*0.75)
    e_eval([[u_setFlashEffect(255)]])
    e_waitUntilS((60/140))
    e_eval([[u_setFlashEffect(255)]])
    e_eval([[s_setStyle("bc_ppd1")]])
	e_eval([[shdr_setActiveFragmentShader(RenderStage.BACKGROUNDTRIS, firstflashes)]])
	e_eval([[shdr_setActiveFragmentShader(RenderStage.WALLQUADS, screenpulse)]])
	e_eval([[shdr_setActiveFragmentShader(RenderStage.CAPTRIS, screenpulse)]])
    e_eval([[l_setRotationSpeed(0.05)]])
    e_eval([[stopPulse(l_getRadiusMin())]])

    e_waitUntilS(12.432) --stop
	e_eval([[shdr_setActiveFragmentShader(RenderStage.BACKGROUNDTRIS, blackshade)]])
    e_eval([[l_setRotationSpeed(0)]])
    e_eval([[t_clear()]])
    e_eval([[noWallSpawn = true]])
	e_eval([[shdr_resetActiveFragmentShader(RenderStage.WALLQUADS)]])
	e_eval([[shdr_resetActiveFragmentShader(RenderStage.CAPTRIS)]])
    e_eval([[t_waitUntilS(14.136)]])
    e_eval([[u_clearWalls()]])
    
    e_waitUntilS(13.289) --redglow
	e_eval([[shdr_setActiveFragmentShader(RenderStage.BACKGROUNDTRIS, redglow)]])

    --4 beat build
    e_waitUntilS(14.136-(60/140))
    e_eval([[u_setFlashEffect(255)]])
    e_waitUntilS(14.136-(60/140)*0.75)
    e_eval([[u_setFlashEffect(255)]])
    e_waitUntilS(14.136-(60/140)*0.5)
    e_eval([[u_setFlashEffect(255)]])
    e_waitUntilS(14.136-(60/140)*0.25)
    e_eval([[u_setFlashEffect(255)]])
    --everything below here needs to be redone
    e_waitUntilS(14.136) --main melody intro
    --e_eval([[shapeChange(4, "sSqu")]])
    e_eval([[noWallSpawn = false]])
    e_eval([[u_setFlashEffect(255)]])
    e_eval([[l_setRotationSpeed(-0.4)]])
    e_eval([[u_setFlashEffect(70)]])
    e_eval([[l_setSpeedMult(l_getSpeedMult()+0.6)]])
    e_eval([[t_clear()]])
    e_eval([[u_clearWalls()]])
    e_eval([[slowPulse()]])
	e_eval([[shdr_setActiveFragmentShader(RenderStage.BACKGROUNDTRIS, trilattice)]])


    e_waitUntilS(21.004) --slightly faster

    e_waitUntilS(26.083) --stop
    e_eval([[respulse = true]])
    e_eval([[l_setRotationSpeed(0)]])
    e_waitUntilS(27.868) --kiai but not really (low melodic)
    e_eval([[u_setFlashEffect(255)]])
    e_eval([[l_setSpeedMult(l_getSpeedMult()+0.3)]])
    e_eval([[l_setRotationSpeed(-0.5)]])
    e_eval([[skewPeriod = 1]])
    e_eval([[slowPulse()]])
	e_eval([[shdr_setActiveFragmentShader(RenderStage.BACKGROUNDTRIS, trilatticecolors)]])
	e_eval([[shdr_setActiveFragmentShader(RenderStage.WALLQUADS, screenpulse)]])


    e_waitUntilS(41.151) --stop
    e_eval([[l_setRotationSpeed(0.5)]])
    e_eval([[t_clear()]])
    e_eval([[u_clearWalls()]])


    e_waitUntilS(41.578-(60/140))
    e_eval([[u_setFlashEffect(255)]])
    e_waitUntilS(41.578-(60/140)*0.75)
    e_eval([[u_setFlashEffect(255)]])
    e_waitUntilS(41.578-(60/140)*0.5)
    e_eval([[repulse = true]])
    e_eval([[u_setFlashEffect(255)]])
    e_waitUntilS(41.578-(60/140)*0.25)
    e_waitUntilS(41.578) --kiai 1 
	e_eval([[shdr_resetActiveFragmentShader(RenderStage.WALLQUADS)]])
    e_eval([[
        if u_getDifficultyMult() == 1.0 then
            l_setSpeedMult(4.0)
        elseif u_getDifficultyMult() > 1.0 then
            l_setSpeedMult(4.3)
        elseif u_getDifficultyMult() < 1.0 then
            l_setSpeedMult(3.1)
        end]])
    e_eval([[s_setStyle("bc_ppd1")]])
    e_eval([[u_setFlashEffect(255)]])
    e_eval([[kiai2 = true]])
    e_eval([[hardPulse()]])
    e_eval([[l_setRadiusMin(60)]])
    e_eval([[l_setBeatPulseMax(10)]])
    e_eval([[l_setBeatPulseDelayMax(21.176470588235294117647058823529)]])
    e_eval([[l_setBeatPulseSpeedMult(1)]])
    e_eval([[
        if u_getDifficultyMult() == 1.0 then
            l_setRotationSpeed(-0.8)
        elseif u_getDifficultyMult() > 1.0 then
            l_setRotationSpeed(-1.0)
        elseif u_getDifficultyMult() < 1.0 then
            l_setRotationSpeed(-0.5)
        end]])
    e_eval([[shdr_setActiveFragmentShader(RenderStage.BACKGROUNDTRIS, perspective)]])
    e_eval([[t_clear()]])
    e_eval([[u_clearWalls()]])
    e_eval([[skewPeriod = 0]])
    e_eval([[skewInput = 0]])

    --some kind of wind down at 54-55.6s
    e_waitUntilS(55.1)

    --break section

    --4 beat build
    e_waitUntilS(69.003) --build begin to second kiai

    e_waitUntilS(75.863) --kick starts again

    e_waitUntilS(80.992) --kick stops


    e_waitUntilS(82.718) --kiai 2 (psytrance)
    
    e_waitUntilS(89.576) -- kick starts again


    --8 beat build
    e_waitUntilS(96.435)--kiai 3
    -- theres a melody shift somewhere in here idk
    

    --[===================================================[everything below here goes in the trash
    --cringe	
    e_waitUntilS(89.261)
	e_eval([[cwmoved2 = true]])
	e_waitUntilS(89.261 + 0.11)
	e_eval([[cwmoved2 = false]])
	
	e_waitUntilS(89.62)
	e_eval([[cw_setVertexColor4Same(cwdiv1, 130, 0, 0, 255)]])
	e_eval([[cw_setVertexColor4Same(cwdiv2, 130, 0, 0, 255)]])
	e_eval([[cw_setVertexColor4Same(cwdiv3, 130, 0, 0, 255)]])

	e_waitUntilS(89.98)
	e_eval([[cwtoggle(cwdiv1)]])
	e_eval([[cwtoggle(cwdiv2)]])
	e_eval([[cwtoggle(cwdiv3)]])

    --drop 2 - custom wall divider killers
    e_waitUntilS(90.351)
    e_eval([[
        if u_getDifficultyMult() == 1.0 then
            l_setSpeedMult(4.0)
        elseif u_getDifficultyMult() > 1.0 then
            l_setSpeedMult(4.3)
        elseif u_getDifficultyMult() < 1.0 then
            l_setSpeedMult(3.1)
        end]])
    e_eval([[s_setStyle("bc_ppd1")]])
    e_eval([[u_setFlashEffect(255)]])
    e_eval([[kiai2 = true]])
    e_eval([[hardPulse()]])
    e_eval([[l_setRadiusMin(60)]])
    e_eval([[l_setBeatPulseMax(10)]])
    e_eval([[l_setBeatPulseDelayMax(21.176470588235294117647058823529)]])
    e_eval([[l_setBeatPulseSpeedMult(1)]])
    e_eval([[
        if u_getDifficultyMult() == 1.0 then
            l_setRotationSpeed(-0.8)
        elseif u_getDifficultyMult() > 1.0 then
            l_setRotationSpeed(-1.0)
        elseif u_getDifficultyMult() < 1.0 then
            l_setRotationSpeed(-0.5)
        end]])
    e_eval([[shdr_setActiveFragmentShader(RenderStage.BACKGROUNDTRIS, perspective)]])
    e_eval([[t_clear()]])

    --switch again
    e_waitUntilS(112.936)
    e_eval([[shaderCols = 5]])
    e_eval([[u_setFlashEffect(200)]])
    e_eval([[t_clear()]])
    e_eval([[u_clearWalls()]])
    e_eval([[l_setSpeedMult(l_getSpeedMult()+0.2)]])
    e_eval([[l_setRotationSpeed(((0.0-1.0)*l_getRotationSpeed())+0.1)]])

    e_waitUntilS(134.119) --transition to break
    e_eval([[l_setRotationSpeed(0)]])
    e_eval([[l_setRadiusMin(0)]])
    e_eval([[shdr_resetActiveFragmentShader(RenderStage.BACKGROUNDTRIS)]])
    --]===================================================]

    e_waitUntilS(140)
    e_messageAdd("Level complete!", 300)
    e_eval([[t_kill()]])
end

-- onStep is an hardcoded function that is called when the level timeline is empty
-- onStep should contain your pattern spawning logic
function onStep()
    if(cPool == "sHex") then
        if index > #sHexKeys then
            index = 1
            shuffle(sHexKeys)
        end
    addPattern(sHexKeys[index])
    index = index + 1

end
    if(cPool == "sOct") then
        if index > #sOctKeys then
            index = 1
            shuffle(sOctKeys)
        end
    addPattern(sOctKeys[index])
    index = index + 1

end
if(cPool == "sSqu") then
    if index > #sSquKeys then
        index = 1
        shuffle(sSquKeys)
    end

    addPattern(sSquKeys[index])
    index = index + 1

end
if(cPool == "bOnlyHex") then
    if index > #bOnlyHexKeys then
        index = 1
        shuffle(bOnlyHexKeys)
    end

    addPattern(bOnlyHexKeys[index])
    index = index + 1

end
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

        --on beat events
        ticker = true

        --pulse starter on beat
        if respulse then
            hardPulse()
            respulse = false
        end

        --event specific on beat
		if kiai2 then --light pulse flash
            u_setFlashEffect(50)
		end

        interBeatCounter = 0
        beatCount = beatCount + 1
    else
        ticker = false
    end

    if noWallSpawn then --pauses wall spawning
        u_clearWalls()
    end
    
    if skewPeriod == 0 then
        skewRate = 0
    else
        skewRate = ((skewMax-skewMin)/(60.0/140))/240
        skewRate = skewRate * skewPeriod
    end

    --manual skew control
    if skewInput<skewMin or skewInput>skewMax then
		skewDirection = not skewDirection
	end
	if skewDirection then
		skewInput = skewInput + skewRate
	else
		skewInput = skewInput - skewRate
	end
    s_set3dSkew(skewInput)

    frameCounter = frameCounter + 1
    interBeatCounter = interBeatCounter + 1
end

function onRenderStage(rs) --cringe
	shdr_setUniformF(screenpulse, "u_time", l_getLevelTime())
	shdr_setUniformFVec2(redglow, "u_resolution", u_getWidth(), u_getHeight())

	shdr_setUniformFVec2(firstflashes, "u_resolution", u_getWidth(), u_getHeight())
	shdr_setUniformF(firstflashes, "u_time", l_getLevelTime())
	shdr_setUniformF(firstflashes, "u_rotation", math.rad(l_getRotation()))
	shdr_setUniformF(firstflashes, "u_skew", s_get3dSkew())
	shdr_setUniformI(firstflashes, "u_beat", beatCount)

	shdr_setUniformFVec2(gridshade, "u_resolution", u_getWidth(), u_getHeight())
	shdr_setUniformF(gridshade, "u_rotation", math.rad(l_getRotation()))
	shdr_setUniformF(gridshade, "u_skew", s_get3dSkew())

	shdr_setUniformFVec2(trilattice, "u_resolution", u_getWidth(), u_getHeight())
	shdr_setUniformF(trilattice, "u_time", l_getLevelTime())
	shdr_setUniformF(trilattice, "u_rotation", math.rad(l_getRotation()))
	shdr_setUniformF(trilattice, "u_skew", s_get3dSkew())

	shdr_setUniformFVec2(trilatticecolors, "u_resolution", u_getWidth(), u_getHeight())
	shdr_setUniformF(trilatticecolors, "u_time", l_getLevelTime())
	shdr_setUniformF(trilatticecolors, "u_rotation", math.rad(l_getRotation()))
	shdr_setUniformF(trilatticecolors, "u_skew", s_get3dSkew())
	shdr_setUniformI(trilatticecolors, "u_beat", beatCount)

	shdr_setUniformFVec2(gridgraid, "u_resolution", u_getWidth(), u_getHeight())
	shdr_setUniformF(gridgraid, "u_time", l_getLevelTime())
	shdr_setUniformF(gridgraid, "u_rotation", math.rad(l_getRotation()))
	shdr_setUniformF(gridgraid, "u_skew", s_get3dSkew())

	shdr_setUniformFVec2(gridshadetran, "u_resolution", u_getWidth(), u_getHeight())
	shdr_setUniformF(gridshadetran, "u_time", l_getLevelTime())
	shdr_setUniformF(gridshadetran, "u_rotation", math.rad(l_getRotation()))
	shdr_setUniformF(gridshadetran, "u_skew", s_get3dSkew())

	shdr_setUniformFVec2(blackflash, "u_resolution", u_getWidth(), u_getHeight())
	shdr_setUniformF(blackflash, "u_rotation", math.rad(l_getRotation()))
	shdr_setUniformF(blackflash, "u_skew", s_get3dSkew())
	shdr_setUniformI(blackflash, "u_hue", shaderCols)

    shdr_setUniformFVec2(whiteflash, "u_resolution", u_getWidth(), u_getHeight())
	shdr_setUniformF(whiteflash, "u_rotation", math.rad(l_getRotation()))
	shdr_setUniformF(whiteflash, "u_skew", s_get3dSkew())
	shdr_setUniformI(whiteflash, "u_hue", shaderCols)

	shdr_setUniformFVec2(perspective, "u_resolution", u_getWidth(), u_getHeight())
	shdr_setUniformF(perspective, "u_time", l_getLevelTime())
	shdr_setUniformF(perspective, "u_rotation", math.rad(l_getRotation()))
	shdr_setUniformF(perspective, "u_skew", s_get3dSkew())
	shdr_setUniformI(perspective, "u_hue", shaderCols)
end