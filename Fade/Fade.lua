--@ BeginProperty
--@ SyncDirection=None
Component FadeSprite = ":SpriteGUIRendererComponent"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnInitialize()
{
if self.FadeSprite == nil then
	--Add this
	self.FadeSprite = _EntityService:GetEntityByPath("/ui/DefaultGroup/FadeSprite").SpriteGUIRendererComponent
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void FadeIn(number second)
{
self.Entity.PlayerControllerComponent.Enable = false

self.Enable = true
self.FadeSprite.Color.a = 0

local Alpha = function(value)
	self.FadeSprite.Color.a = value
end

local tween = _TweenLogic:MakeTween(0, 1, second, EaseType.BackEaseIn, Alpha)
self.Entity.PlayerControllerComponent.Enable = false
tween.AutoDestroy = false
tween.LoopCount = 0
tween:Play()

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void FadeOut(number second)
{
self.FadeSprite.Color.a = 1

local Alpha = function(value)
	self.FadeSprite.Color.a = value
end
local tween = _TweenLogic:MakeTween(1, 0, second, EaseType.BackEaseOut, Alpha)

tween.AutoDestroy = false
tween.LoopCount = 0
tween:Play()

self.Entity.PlayerControllerComponent.Enable = true
wait(second)
self.Enable = false
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=localPlayer
--@ EventName=EntityMapChangedEvent
HandleEntityMapChangedEvent
{
-- Parameters
local NewMap = event.NewMap
local OldMap = event.OldMap
local Entity = event.Entity
--------------------------------------------------------
wait(0.7)
self:FadeOut(0.7)
--log("MapEnter")
}
--@ EndEntityEventHandler

