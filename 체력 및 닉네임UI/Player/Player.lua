--@ BeginProperty
--@ SyncDirection=None
Component tr = ":TransformComponent"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity map = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
SyncTable<Entity> Eatable = "Entity"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number EatCooltime = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number EatInitialTime = "0.24"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void ItemAcquire()
{
if self.EatCooltime > 0 then return end -- 쿨타임 미충족시 return
if (#self.Eatable ~= 0) then
	local AcquiredItem = self.Eatable[1]

	if AcquiredItem == nil then table.remove(self.Eatable, 1) log("없애!")return
	else 
		if AcquiredItem.Item then
			if AcquiredItem.Item:IsAquirable() then
				table.remove(self.Eatable, 1)
				-- Inventory
				if AcquiredItem.Item.ItemType == "" or AcquiredItem.Item.ItemType == nil then return end
				if AcquiredItem.Item.ItemType == "Meso" then -- 메소일경우
					_EntityService:GetEntityByPath("/ui/DefaultGroup/UIMyInfo").UIMyInfoMine:MoneyAdd(tonumber(AcquiredItem.Name))
				elseif AcquiredItem.Item.ItemType == "Gita" then --외의 경우 아이템화
					self:InventoryInput(AcquiredItem.Item.ItemName, 1)
				end
				
				-- 쿨타임 적용
				self.EatCooltime = self.EatInitialTime
				if self.EatInitialTime > 0.1 then self.EatInitialTime = self.EatInitialTime - 0.02 end
				local returning = function() self.EatCooltime = 0 end
				_TimerService:SetTimerOnce(returning, self.EatCooltime)
			end
		else
			table.remove(self.Eatable, 1)
		end
	end
else
	self.EatInitialTime = 0.18 -- 먹을게 떨어지면 다시 0.5
end

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void SpawnItem(string ItemName,string ItemType,string ItemRUID,boolean spinObject)
{
local tr = self.Entity.TransformComponent
local map = self.Entity.CurrentMap
local spawnLocationSet

local pc = self.Entity.PlayerControllerComponent

if self._T.beforePos == nil then self._T.beforePos = tr.Position.x end
local nowMove = tr.Position.x - self._T.beforePos
self._T.beforePos = self.Entity.TransformComponent.Position.x



if pc.LookDirectionX == 1 then spawnLocationSet = Vector3(-0.13,0,0) else spawnLocationSet = Vector3(-0.2,0,0) end
if spinObject then if pc.LookDirectionX == 1 then spawnLocationSet = Vector3(-0.13 + 0.13,0 + 0.15,0) else spawnLocationSet = Vector3(-0.2 + 0.13,0 + 0.15,0) end end

local name = "아이템"
if ItemType == "Meso" then
	name = tostring(math.floor(math.random(50,2000)))
end
local SpawnedItem = _SpawnService:SpawnByModelId("59999fef-1056-4430-9c7e-1476d8f85cd8", name, tr.Position + spawnLocationSet, map)
SpawnedItem.Item.ItemName = ItemName
SpawnedItem.Item.ItemType = ItemType
SpawnedItem.Item.PINNN = spinObject
SpawnedItem.SpriteRendererComponent.SpriteRUID = ItemRUID
SpawnedItem.Item:Jump(4.5)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void LevelUp()
{
local levelup = _SpawnService:SpawnByModelId("7aa9b362-4dc2-4c8a-a00d-cb09a98fa19a", "LevelUp", Vector3.zero + Vector3(0,1.75,0), self.Entity)

levelup:Destroy(2.5)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void InventoryInput(string what,number howmany)
{

--아이템 전체 삭제
--for index, item in pairs(self.Entity.InventoryComponent:GetItemList()) do _ItemService:RemoveItem(item) end

local itemtype

local dataset = _DataService:GetTable("UserItemDataSet")
local item
local itemRow
for i = 1, dataset:GetRowCount() do
	if dataset:GetCell(i, "Name") == what then
		item = dataset:GetAllRow()
		--log("아이템 테이블에 존재")
		itemRow = i
		break
	end
end

itemtype = dataset:GetCell(itemRow, "Type")

-- 아이템 타입이 추가될 경우 여기에 추가!!!
	if itemtype == "기타" then itemtype = Gita
elseif itemtype == "소비" then itemtype = Use
elseif itemtype == "장비" then itemtype = Equip
else log("정의된 타입이 아니네요. 여기에 추가해주세요") return end

-- 이미 인벤토리에 동일 품목이 존재하는지 확인
for index, item in pairs(self.Entity.InventoryComponent:GetItemList()) do 
	-- 같은거면 수량증가 후 return
	if item.ItemDataTableName == what then 
		if item.ItemCount + howmany >= 0 then
 			item.ItemCount = item.ItemCount + howmany return
		else
			log("아이템 수량은 음수가 될 수 없습니다") return
		end
	end	
end

_ItemService:CreateItem(itemtype, what, self.Entity.InventoryComponent) -- 동일 종류 없으면 아이템 새로만듦
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void RemoveItemDestroyed(Entity DestroyedItem)
{

if #self.Entity.Player.Eatable ~= 0 then
	if self.Entity.Player.Eatable[1] ~= nil then
		if self.Entity.Player.Eatable[1] == DestroyedItem then
			table.remove(self.Entity.Player.Eatable, 1)
		end
	end
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=service:InputService
--@ EventName=KeyDownEvent
HandleKeyDownEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------
if self.Entity == _UserService.LocalPlayer then
	if key == KeyboardKey.X then
		self:SpawnItem("메소", "Meso", "5c78b56b91964dcaa83c1d30b8cd3cce", false)
	end
	if key == KeyboardKey.C then
		self:SpawnItem("달팽이의 껍질", "Gita", "bbf8ffb9e2184a2e84423671db4d847e", true)
	end
end
if key == KeyboardKey.Q then
	--_EntityService:GetEntityByPath("/maps/map01/Background").BackgroundComponent:ChangeBackgroundByTemplateRUID("80c9d9b9166b42abb3a77b83bfa7ea59")
	for key, value in pairs(self.Eatable) do
		log(string.format("%d %s", key, value.Name))
	end
end

}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=localPlayer
--@ EventName=TriggerEnterEvent
HandleTriggerEnterEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
if TriggerBodyEntity.Item then	
	table.insert(self.Eatable, #self.Eatable + 1, TriggerBodyEntity)
	--log(string.format("현재 테이블 포함수: %d", #self.Eatable))
	--log("먹을수있따")
end
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=Client
--@ Target=localPlayer
--@ EventName=TriggerLeaveEvent
HandleTriggerLeaveEvent
{
-- Parameters
local TriggerBodyEntity = event.TriggerBodyEntity
--------------------------------------------------------
--if TriggerBodyEntity.Name == "메소" and self.Eatable == TriggerBodyEntity then
for key, value in pairs(self.Eatable) do
	if value == TriggerBodyEntity then
			table.remove(self.Eatable, key)
			--log(string.format("현재 테이블 포함수: %d", #self.Eatable))
			return
	end
end

}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=service:InputService
--@ EventName=KeyHoldEvent
HandleKeyHoldEvent
{
-- Parameters
local key = event.key
--------------------------------------------------------
if key == KeyboardKey.Z then
	self:ItemAcquire()
end
}
--@ EndEntityEventHandler

