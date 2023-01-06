--patterns from OHL 2's Insight
u_execScript("bc/utils.lua")
u_execScript("bc/common.lua")
u_execScript("bc/commonpatterns.lua")
u_execScript("bc/commonFunctions.lua")

-- pDMTunnel: the pTunnel pattern with mDelayMult
function pDMTunnel(mTimes, mDelayMult)
	oldThickness = THICKNESS
	myThickness = getPerfectThickness(THICKNESS)
	delay = getPerfectDelay(myThickness) * 4
	delay2 = getPerfectDelay(myThickness) * 2.7
	startSide = getRandomSide()
	loopDir = getRandomDir()
	
	THICKNESS = myThickness
	
	for i = 0, mTimes do
		if i < mTimes then
			w_wall(startSide, myThickness + 6 * getSpeed() * delay)
		end
		
		cBarrage(startSide + loopDir)
		t_wait(delay*mDelayMult)
		
		loopDir = loopDir * -1
	end
	
	THICKNESS = oldThickness
	t_wait(delay2)
end

-- "inverse barrage" patterns with different numbers (edited to be triangle-only)
function pInverseBarrage12Sid(mTimes, mDelayMult)
	delay = getPerfectDelay(THICKNESS) * 5 * mDelayMult
	startSide = getRandomSide()
	
	for i = 0, mTimes do
		cWallEx(startSide, 0)
		t_wait(delay*mDelayMult)
		cWallEx(startSide + 1, 1)
		t_wait(delay*mDelayMult)
	end
	
	t_wait(getPerfectDelay(THICKNESS) * 2.5)
end

-- pBarrageSpiralLR: spawns left-right spiral of cBarrage
function pBarrageSpiralLR(mTimes, mDelayMult)
	delay = getPerfectDelay(THICKNESS) * 5.6 * mDelayMult
	startSide = getRandomSide()
	
	for i = 0, mTimes do
		cBarrage(startSide)
		t_wait(delay)
		cBarrage(startSide + 1)
		t_wait(delay)
	end
	
	t_wait(getPerfectDelay(THICKNESS) * 6.1)
end

-- same pattern + mDelayMult especially for Annihilation
function pDMTriSingleSpiralAllDir(mTimes, mExtra, mDelayMult)
	oldThickness = THICKNESS
	THICKNESS = getPerfectThickness(THICKNESS) * 1.67
	delay = getPerfectDelay(THICKNESS) * mDelayMult
	delay2 = getPerfectDelay(THICKNESS) * 2.2
	startSide = getRandomSide()
	loopDir = getRandomDir()
	dir = math.random(0, 1)
	j = 0
	
	for i = 0, mTimes do
		cWallEx(startSide + j, mExtra)
	    if dir == 0 then		
		j = j - 1		
		else
		j = j + loopDir
		end
		t_wait(delay*mDelayMult)		
	end
	
	THICKNESS = oldThickness
	
	t_wait(delay2)
end