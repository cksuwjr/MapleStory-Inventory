--@ BeginProperty
--@ SyncDirection=None
Vector2 RectSize = "Vector2(0, 0)"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Vector2 anchoredPosition = "Vector2(0, 0)"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnInitialize()
{
-- Author : Finn (finn@storyg.net)
-- Copyright ⓒ 2022. STORYG. All rights reserved.
-- Redistribution or public display is not permitted without written permission from STORYG.

-- 기존 포지션, 사이즈 백업
self.RectSize = self.Entity.UITransformComponent.RectSize
self.anchoredPosition = self.Entity.UITransformComponent.anchoredPosition
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
-- Author : Finn (finn@storyg.net)
-- Copyright ⓒ 2022. STORYG. All rights reserved.
-- Redistribution or public display is not permitted without written permission from STORYG.

-- SpriteGUIRendererComponent 확인 후 실행
if self.Entity.SpriteGUIRendererComponent == nil then return end
-- ImageRUID가 없다면 실행 종료.
if self.Entity.SpriteGUIRendererComponent.ImageRUID == "" or nil then return end

-- 리소스 로드
local element = _ResourceService:LoadSpriteAndWait(self.Entity.SpriteGUIRendererComponent.ImageRUID.DataId)
-- 이미지 리소스가 아닐 경우 예외 처리
if element == nil then return end

-- 실제 이미지 사이즈 적용
self.RectSize = Vector2(element.Width, element.Height)

if self.Entity.ScrollLayoutGroupComponent then
	
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnResize()
{
-- Author : Finn (finn@storyg.net)
-- Copyright ⓒ 2022. STORYG. All rights reserved.
-- Redistribution or public display is not permitted without written permission from STORYG.

-- 비활성화 상태라면 실행하지 않음.
if not self.Entity.UISpriteComponent.Enable then return end
-- UITransformComponent가 없다면 실행하지 않음.
if self.Entity.UITransformComponent == nil then return end
-- 리사이즈 
self.Entity.UITransformComponent.RectSize = Vector2(self.RectSize.x * _SceneManager.ratio, self.RectSize.y * _SceneManager.ratio)
self.Entity.UITransformComponent.anchoredPosition = Vector2(self.anchoredPosition.x * _SceneManager.ratio, self.anchoredPosition.y * _SceneManager.ratio)
}
--@ EndMethod

