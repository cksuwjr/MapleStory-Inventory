--@ BeginProperty
--@ SyncDirection=None
Component uiInfo = ":UIMyInfoMine"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean canPressLevelUp = "true"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number canPressLevelUpWaitTime = "0.2"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean canPressHpAdd = "true"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number canPressHpAddWaitTime = "0.01"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean canPressExpAdd = "true"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number canPressExpAddWaitTime = "0.01"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean canPressMpAdd = "true"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number canPressMpAddWaitTime = "0.01"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
self.uiInfo = _EntityService:GetEntityByPath("/ui/DefaultGroup/UIMyInfo").UIMyInfoMine
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=service:InputService
--@ EventName=KeyHoldEvent
HandleKeyHoldEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------
if key == KeyboardKey.L then  	         -- L키 누르면
	if self.canPressLevelUp then
		self.canPressLevelUp = false
		self.uiInfo:LevelUp()
		_TimerService:SetTimerOnce(function() self.canPressLevelUp = true end, self.canPressLevelUpWaitTime)
	end
end
if key == KeyboardKey.H then			-- H키 누르면
	if self.canPressHpAdd then
		self.canPressHpAdd = false
		self.uiInfo:HPAdd(-1)
		_TimerService:SetTimerOnce(function() self.canPressHpAdd = true end, self.canPressHpAddWaitTime)
	end
end
if key == KeyboardKey.M then			-- M키 누르면
	if self.canPressMpAdd then
		self.canPressMpAdd = false
		self.uiInfo:MPAdd(-1)
		_TimerService:SetTimerOnce(function() self.canPressMpAdd = true end, self.canPressMpAddWaitTime)
	end
end
if key == KeyboardKey.E then			-- E키 누르면
	if self.canPressExpAdd then
		self.canPressExpAdd = false
		self.uiInfo:EXPAdd(self.Entity.MpExp.MaxExp/10)
		_TimerService:SetTimerOnce(function() self.canPressExpAdd = true end, self.canPressExpAddWaitTime)
	end
end
}
--@ EndEntityEventHandler

