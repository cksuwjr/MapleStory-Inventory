--@ BeginProperty
--@ SyncDirection=None
string State = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Component tr = ":TransformComponent"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
string ItemName = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
string ItemType = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean isSpinObject = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=All
boolean PINNN = "false"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
self.tr = self.Entity.TransformComponent
self.State = "Spawned"
self:AutoDestroy()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void Jump(number arg1)
{
self.Entity.RigidbodyComponent:AddForce(Vector2(0,arg1))
_SoundService:PlaySound("0467a9d8aca04072bdefd96b24a1eef6", 1)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void Tween()
{
self.Entity.TweenFloatingComponent.Enable = true
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnUpdate(number delta)
{
local State = function(state)
	local Act = 
	{
		-- 스폰직후
		["Spawned"] = function()
			if self.PINNN then -- "Spawned는 여기 if문만 PINNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN"
				self.tr.ZRotation = self.tr.ZRotation + 30
				if self._T.MakePinnn == nil then 
					self._T.MakePinnn = " "
					_TimerService:SetTimerOnce(function() self:CheckPinnn() end, 0.5)
				end
				if self._T.Pinnn ~= nil then
					local y = self._T.Pinnn:GetYByX(self.tr.Position.x) + 0.21 - 0.035
					if self.tr.Position.y <= y then
						self.Entity.RigidbodyComponent.Enable = false
						self.State = "OnGround"
						self._T.Pinnn = y
						self.tr.ZRotation = 0
					end
				end
			else	-- PINNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN끝
				if self.Entity.RigidbodyComponent:IsOnGround() then --기존
					self.State = "OnGround"
					self.Entity.RigidbodyComponent.Gravity = 0
					self.tr.ZRotation = 0
					wait(0.5)
				end
			end
		end,
		-- 땅에 착지했을때 Floating
		["OnGround"] = function()
				local y = self.tr.Position.y
			
				local pointmove = 0.035 -- 전체 y값+
				local moveWidth = 0.045 -- 움직임 폭 0.055
				local moveSpeed = 0.053 -- 움직이는 속도 0.077
				if self._T.Dir == nil then
					self._T.Dir = "Minus"
					local MidY = y
					if self.PINNN then MidY = self._T.Pinnn end -- "OnGround"는 여기만 PINNNNNNNNNNNNNNNNNNNNNNNNNNN
					self._T.MinY = MidY - moveWidth + pointmove -- y 최대값
					self._T.MaxY = MidY + moveWidth + pointmove -- y 최솟값
				elseif self._T.Dir == "Minus" then
					if y > self._T.MinY then self.tr.Position.y = y - moveSpeed * delta else self._T.Dir = "Plus" end
				elseif self._T.Dir == "Plus" then
					if y < self._T.MaxY then self.tr.Position.y = y + moveSpeed * delta else self._T.Dir = "Minus" end
				end
		end,
		-- 플레이어가 인접할 때 Z키를 누를경우(습득명령) 최초위치로 돌진
		["Acquired"] = function()
			local playerTr = _UserService.LocalPlayer.TransformComponent
			local playerCenter = Vector2(playerTr.Position.x - 0.15, playerTr.Position.y + 0.3)
			-- "Acquired"는 여기만 PINNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
			if self.PINNN then playerCenter = Vector2(playerTr.Position.x - 0.15 + 0.13, playerTr.Position.y + 0.3 + 0.15) end
			local mypos = Vector2(self.tr.Position.x, self.tr.Position.y)
	
			-- 첫 습득 명령한 위치 저장
			if self._T.FirstAcquirePos == nil then self._T.FirstAcquirePos = playerCenter end
	
			local dir = Vector2.Normalize(self._T.FirstAcquirePos - mypos)
			local speed = 1 
			local distance = Vector2.Distance(playerCenter, mypos)
	 
	
			if self._T.Fade == nil then
				self:ItemFade(1, 0.7, distance * 0.38)
				self._T.Fade = "First"
				_SoundService:PlaySound("205510b33adf4509b1565ccd4c77d98b", 1)
			end
	
			self.tr.Position.x = self.tr.Position.x + dir.x * delta * speed * 1.2
			self.tr.Position.y = self.tr.Position.y + dir.y * delta * speed * 3
			-- 멈춰있을때 먹을경우
			if Vector2.Distance(self._T.FirstAcquirePos, mypos) < 0.05 then self.State = "Com" end
			-- 움직이면서 먹을경우 (왼쪽에서부터) 플레이어 지나칠경우 끊기
			if dir.x < 0 and self.tr.Position.x < playerCenter.x then self.State = "Com" end
			-- 움직이면서 먹을경우 (오른쪽에서부터) 플레이어 지나칠경우 끊기
			if dir.x > 0 and self.tr.Position.x > playerCenter.x then self.State = "Com" end
		end,
		-- 플레이어 향해 끝까지 돌진
		["Com"] = function()
			local playerTr = _UserService.LocalPlayer.TransformComponent
			local playerCenter = Vector2(playerTr.Position.x - 0.15, playerTr.Position.y + 0.15)
			
			-- "Acquired"는 여기만 PINNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
			if self.PINNN then playerCenter = Vector2(playerTr.Position.x - 0.15 + 0.13, playerTr.Position.y + 0.15 + 0.15) end
			local mypos = Vector2(self.tr.Position.x, self.tr.Position.y)
	
			local dir = Vector2.Normalize(playerCenter - mypos)
			local speed = 3
	

			self.tr.Position.x = self.tr.Position.x + dir.x * delta * speed
			self.tr.Position.y = self.tr.Position.y + dir.y * delta * speed * 0.5
	
			local distance = Vector2.Distance(playerCenter, mypos)
	
			if self._T.Fade == "First" then
				self:ItemFade(0.5, 0, distance / speed)
				self._T.Fade = "Second=Fin"
			end
			
			if Vector2.Distance(playerCenter, mypos) < 0.05 then self.State = "Absorbed" end
		end,
		-- 습득됨 (아이템 파괴)
		["Absorbed"] = function()
			self.State = "Destroyed"
			self:DestroyMe()
		end
	}
	-- nil이 아니라면 실행
	if Act[state] then Act[state]() end
end
-- 위의 함수 실행
State(self.State)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
boolean IsAquirable()
{
if self.State == "OnGround" then
	self.State = "Acquired"
	return true
end
return false
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void DestroyMe()
{
self.Entity:Destroy()	
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnDestroy()
{
if _UserService.LocalPlayer.Player ~= nil then
	_UserService.LocalPlayer.Player:RemoveItemDestroyed(self.Entity)
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void ItemFade(number startA,number endA,number duration)
{
local Fade = function(value)
		self.Entity.SpriteRendererComponent.Color.a = value
end
local FadeOut = _TweenLogic:MakeTween(startA, endA, duration, EaseType.BackEaseIn, Fade)
FadeOut:Play()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void AutoDestroy()
{
local destroyTime = 120
local FadeTime = 2

_TimerService:SetTimerOnce(
function() 
	self.State = "Destroying" 
	self:ItemFade(1,0,FadeTime) 
	
end
, destroyTime - FadeTime) 
self.Entity:Destroy(destroyTime)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void CheckPinnn()
{
-- 메서드는 이 메서드만 PiNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
self._T.Pinnn = self.Entity.CurrentMap.FootholdComponent:Raycast(Vector2(self.tr.Position.x,self.tr.Position.y + 0.15), Vector2.down, 0.6)
if self._T.Pinnn == nil then
	self._T.Pinnn = self.Entity.CurrentMap.FootholdComponent:Raycast(Vector2(self.tr.Position.x,self.tr.Position.y + 0.15), Vector2.down, 999)
end	
--log(self.tr.Position)
--log(self._T.Pinnn:GetCenter())
}
--@ EndMethod

