--@ BeginProperty
--@ SyncDirection=None
Component message = "3606e39d-32de-427e-8d23-b38af810a3b4:52"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Component btnOk = "94a274e4-4111-40f1-924d-c95a3a1f14d5:9"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Component btnCancel = "0f5de49b-2adc-409a-816d-15aa43df8e0d:9"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity popupGroup = "fb7a3b06-7026-4590-8efe-bb33416dd8f9"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity popup = "aa954759-0e39-430f-85fa-80bf2e5fe31d"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
any onOk = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
any onCancel = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number duration = "0.15"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number from = "0.5"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number to = "1"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean isOpen = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean isTweenPlaying = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number tweenEventId = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
any okHandler = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
any cancelHandler = "nil"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void Open(string message,any onOk,any onCancel)
{
if self.isOpen == true then
	return
end
self.isOpen = true
self.popupGroup.Enable = true
self.message.Text = message
self.onOk = onOk
self.onCancel = onCancel


self.okHandler = self.btnOk.Entity:ConnectEvent(ButtonClickEvent,self.OnClickOk)
self.cancelHandler = self.btnCancel.Entity:ConnectEvent(ButtonClickEvent,self.OnClickCancel)
self:StartTween(true)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void OnClickOk()
{
if self.isTweenPlaying == true then
	return
end
if self.onOk ~= nil then
	self.onOk()
	self.onOk = nil
end
self:Close()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void OnClickCancel()
{
if self.isTweenPlaying == true then
	return
end
if self.onCancel ~= nil then
	self.onCancel()
	self.onCancel = nil
end
self:Close()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void Close()
{
self.btnOk.Entity:DisconnectEvent(ButtonClickEvent,self.okHandler)
self.btnCancel.Entity:DisconnectEvent(ButtonClickEvent,self.cancelHandler)
self:StartTween(false)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void StartTween(boolean open)
{

local transform = self.popup.UITransformComponent
local canvasGroup = self.popupGroup.CanvasGroupComponent 
if open == true then
	canvasGroup.GroupAlpha = 0
	transform.UIScale = Vector3(self.from,self.from,1)
else
	transform.UIScale = Vector3(self.to,self.to,1)
end
self.isTweenPlaying = true
local time = 0


local preTime = _UtilLogic.ElapsedSeconds

local tween = function()
	local delta = _UtilLogic.ElapsedSeconds - preTime
	time = time + delta
	local timeValue = time	
	preTime = _UtilLogic.ElapsedSeconds

	if time >= self.duration then
		timeValue = self.duration
		if open == false then
			self.popupGroup.Enable = false
			self.isOpen = false
		end
		self.isTweenPlaying = false
		_TimerService:ClearTimer(self.tweenEventId)

	end
	if open == false then
		timeValue = self.duration - timeValue
	end
	local tweenValue = _MODTweenLogic.Ease(EaseType.SineEaseIn,self.from,
		self.to - self.from,timeValue,self.duration)
	transform.UIScale = Vector3(tweenValue,tweenValue,1)
	canvasGroup.GroupAlpha = timeValue / self.duration
end
self.tweenEventId = _TimerService:SetTimerRepeat(tween,1/60)

}
--@ EndMethod

