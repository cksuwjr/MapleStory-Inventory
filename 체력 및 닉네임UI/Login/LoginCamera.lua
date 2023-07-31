--@ BeginProperty
--@ SyncDirection=None
SyncTable<CameraComponent> CAMPoint = "CameraComponent"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number Point = "1"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void ChangeCam()
{
local targetCam = self.CAMPoint[self.Point]
if self.Point < #self.CAMPoint then
	self.Point = self.Point + 1
else
	self.Point = 1
end
_CameraService.TransitionBlendTime = 0.8
_CameraService.TransitionBlendType = CameraBlendType.HardOut
_CameraService:SwitchCameraTo(targetCam)

_SoundService:PlaySound("68755857123b40158a189f70466e7250", 1)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void OnInitialize()
{
wait(0.1)
table.insert(self.CAMPoint, _EntityService:GetEntityByPath(self.Entity.CurrentMap.Path.."/Point1").CameraComponent)
table.insert(self.CAMPoint, _EntityService:GetEntityByPath(self.Entity.CurrentMap.Path.."/Point2").CameraComponent)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
_CameraService.TransitionBlendTime = 0.01
_CameraService.TransitionBlendType = CameraBlendType.Cut
_CameraService:SwitchCameraTo(self.CAMPoint[1])

local changecam = function() self:ChangeCam() end
_TimerService:SetTimerOnce(changecam, 1)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnMapLeave(any leftMap)
{

_EntityService:GetEntityByPath("/ui/Login").Enable = false
_UserService.LocalPlayer.RigidbodyComponent.Enable = true
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=service:InputService
--@ EventName=KeyDownEvent
HandleKeyDownEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------
if key == KeyboardKey.UpArrow then
	self:ChangeCam()
end
}
--@ EndEntityEventHandler

