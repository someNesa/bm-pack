-----------------------------------------------------
--//////////////////////INFOS//////////////////////--
-----------------------------------------------------
-- File : commonFunctions
-- Author : eiml, ported by Hunter
-- Version : 2.1 (04/21/19)
-----------------------------------------------------
-- README :
-- Those were written for pure convenience.
-- Nothing over the top really but for the sake of 
-- actual decent programming and not having to deal 
-- with writing stupidly named hardcoded functions.
-----------------------------------------------------
-- HOW TO USE :
-- Put the following line into your .lua scripts :
-- BEGIN# exec_Script("commonfunctions.lua") #END
-- Without the '_' between "exec" and "Script".
-----------------------------------------------------
--/////////////////////////////////////////////////--
-----------------------------------------------------

-----------------------------------------------------
--//////////////////GETTER+SETTER//////////////////--
-----------------------------------------------------

-----------------------------------------------------

-- getSpeed : return level speed
function getSpeed()
	return l_getSpeedMult() 
end

-- getRot : return level rotation
function getRot()
	return l_getRotationSpeed() 
end

-- getRotDir : return rotation direction
function getRotDir()
	if getRot() >= 0 then return 1 end
	return (-1)
end

-- getRotAbs : return rotation value
function getRotAbs()
	return getRot() * getRotDir()
end

-- getPulseMin : return level pulse_min
function getPulseMin()
	return l_getPulseMin()
end

-- getDM : return level's delay multiplier
function getDM()
	return l_getDelayMult()
end

-----------------------------------------------------

-- setSpeed : set "speed" as new level's speed
function setSpeed(speed)
	l_setSpeedMult(speed)
end

-- setRot : set "rot" as new level's rotation
function setRot(rot)
	l_setRotationSpeed(rot)
end

-- setPulseMin : set "low" as new level's pulse_min
function setPulseMin(low)
	l_setPulseMin(low)
end

-- setDM : set "dm" as level's delay multiplier
function setDM(dm)
	l_setDelayMult(dm)
end

-----------------------------------------------------

-- retSpeed : get current level's speed and add "speed" to it
function retSpeed(speed)
	setSpeed(getSpeed() + speed)
end

-- retRot : get current level's rotation and multiply it by "rot"
function retRot(rot)
	setRot(getRot() * rot)
end

-- retPulseMin : get current level's pulse_min and add "low" to it
function retPulseMin(low)
	setPulseMin(getPulseMin() + low)
end

-- retDM : get current level's delay multiplier and add "bdm" to it
function retDM(bdm)
	setDM(getDM() + bdm)
end

-----------------------------------------------------
--/////////////////////////////////////////////////--
-----------------------------------------------------

-----------------------------------------------------
--////////////////////FUNCTIONS////////////////////--
-----------------------------------------------------

-- reverseRot : reverse rotation with optional "rotPerc" bonus
function reverseRot(rotPerc)
	rotPerc = rotPerc or 1
	retRot(-rotPerc)
end

-- reverseAbsRot : reverse rotation to a set value
function reverseAbsRot(rot)
	rot = rot or 1
	setRot(-getRotDir() * rot)
end

-- randReverseRot : "cR"/"right" chance of reversing rotation with optional "rotPerc" bonus
function randReverseRot(cR, right, rotPerc)
	rotPerc = rotPerc or 1
	a = math.random(1, right)
	if a <= cR then reverseRot(rotPerc) end
end

-- addPatterns : add specified patterns and move cursor "index"
function addPatterns()
	addPattern(keys[index])
    index = index + 1
end

-- shufflePatterns : shuffle patterns (; "index" oob)
function shufflePatterns()
    if index - 1 == #keys then
        index = 1
        shuffle(keys)
    end
end

-- accelSR : increase speed/rotation with optional "sa" / "ra" bonus
function accelSR(sa, ra)
	sa = sa or 0
	ra = ra or 1
	retSpeed(sa)
	retRot(ra)
end

-- demiseSRP : accelSR with optional modifications to pulse_min
function demiseSRP(sa, ra, pa)
	pa = pa or 0
	accelSR(sa, ra)
	retPulseMin(pa)
end

-- changeSide : switch side 
function changeSide(l, h, p)
	p = p or 0.5
	a = math.random(0, 100) / 100
	if a < p then l_setSides(l)
	else l_setSides(h)
	end
end

-- sout : system out
function sout(msg, t)
	t = t or 60
	e_messageAddImportant(msg, t)
end