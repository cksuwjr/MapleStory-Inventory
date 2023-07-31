--@ BeginProperty
--@ SyncDirection=None
number Speed = "15"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number startX = "-9"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
number endX = "9"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number RegenerationDelay = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean Continuosly = "false --Mundo 10.31 23:45 추가"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{

--Mundo 10.31 23:45 추가
if self.Continuosly then
	local spriteComponent = self.Entity.SpriteRendererComponent
	local sprite = _ResourceService:LoadSpriteAndWait(spriteComponent.SpriteRUID)
	self.startX = - sprite.Width / 100
	self.endX =  sprite.Width / 100
end


if self.Speed < 0 then self.Speed = 0 end

local FirstPlay = self:CloudMoving(self.Entity.TransformComponent.Position.x, self.endX, self.Speed, 0, true)
local SecondPlay = function() self:CloudMoving(self.startX, self.endX, self.Speed, self.RegenerationDelay, false) end

_TimerService:SetTimerOnce(SecondPlay, FirstPlay)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
number CloudMoving(number StartX,number EndX,number Speed,number Delay,boolean AutoDestroy)
{
local CloudMove = function(posx)
	local tr = self.Entity.TransformComponent
	tr.Position.x = posx
end

local PlayTime = math.abs(EndX - StartX) / Speed
local cloudMoving = _TweenLogic:MakeTween(StartX, EndX, PlayTime, EaseType.Linear, CloudMove)

cloudMoving.AutoDestroy = AutoDestroy
cloudMoving.LoopCount = -1
if AutoDestroy then cloudMoving.LoopCount = 0 end

local play = function() cloudMoving:Play() end
_TimerService:SetTimerOnce(play, Delay)

return PlayTime + Delay
}
--@ EndMethod

