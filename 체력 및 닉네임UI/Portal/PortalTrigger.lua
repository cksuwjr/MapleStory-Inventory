--@ BeginProperty
--@ SyncDirection=None
boolean isPlayerIn = "false"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
override void OnEnterTriggerBody(TriggerEnterEvent enterEvent)
{
__base:OnEnterTriggerBody(enterEvent)
self.isPlayerIn = true
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
override void OnLeaveTriggerBody(TriggerLeaveEvent leaveEvent)
{
__base:OnLeaveTriggerBody(leaveEvent)
self.isPlayerIn = false
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
	if self.isPlayerIn then
		self.Entity.Portal:Teleport()
	end
end
}
--@ EndEntityEventHandler

