--@ BeginProperty
--@ SyncDirection=None
table Slots = "{}"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table Items = "{}"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number ISee = "1"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity Scroll = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Component ScrollBar = ":UITransformComponent"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Component UpButton = ":UITransformComponent"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Component DownButton = ":UITransformComponent"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table Selected_Item = "{}"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number Selected = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SortType = ""All""
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table Gita_Items = "{}"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table Use_Items = "{}"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
table Equip_Items = "{}"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
local Parent = self.Entity.Parent

self.Scroll = Parent:GetChildByName("Scroll")

self.ScrollBar = self.Scroll:GetChildByName("Scrollbar").UITransformComponent
self.UpButton = self.Scroll:GetChildByName("UpButton").UITransformComponent
self.DownButton = self.Scroll:GetChildByName("DownButton").UITransformComponent

self.Slots = self.Entity.Children:ToTable()

self:Update_SlotUI()

self._T.Height = 0
self._T.StartPos = 0
self._T.EndPos = 0
-- 스크롤 버튼, 이벤트 등록

self.UpButton.Entity:ConnectEvent(ButtonClickEvent, function() self:Scrolled(-1) end)
self.DownButton.Entity:ConnectEvent(ButtonClickEvent, function() self:Scrolled(1) end)

self:ShopButtonEventInit()

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void SetSlot(number n,table item)
{
local img_slot = self.Slots[n]:GetChildByName("img_slot")
local item_count = img_slot:GetChildByName("item_count")
local item_sprite = img_slot:GetChildByName("item_sprite")

local item_info = self.Slots[n]:GetChildByName("item_info")

local item_name = item_info:GetChildByName("item_name")
local item_price = item_info:GetChildByName("item_price")

if item == nil then 
	item_sprite.SpriteGUIRendererComponent.ImageRUID = ""
	item_count.TextComponent.Text = ""
	item_name.TextComponent.Text = "" 			-- 이름 설정
	item_price.TextComponent.Text = "" -- 가격 설정
return end

item_sprite.SpriteGUIRendererComponent.ImageRUID = item[1] -- 아이템 이미지 설정
 item_count.TextComponent.Text = item[2] 		-- 아이템 개수 설정
if item[2] <= 1 then item_count.Visible = false else item_count.Visible = true end


 item_name.TextComponent.Text = item[3] 			-- 이름 설정
 item_price.TextComponent.Text = item[4] -- 가격 설정



}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void Scrolled(number Value)
{
self._T.FirstScrolled = "Done"
-- #self.Items - 4
if self.ISee + Value > #self.Items - 4 or self.ISee + Value < 1 then return end
self.ISee = self.ISee + Value


local ScrollPos
if #self.Items - 5 == 0 then
	ScrollPos = self._T.StartPos
else
	ScrollPos = self._T.StartPos - (self._T.Height * ((self.ISee - 1) / (#self.Items - 5)))
end
self.ScrollBar.WorldPosition.y = ScrollPos
self:Update_SlotUI()

--log(((self.ISee - 1) / (#self.Items - 5)))
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void AddItem(string imageRUID,number count,string name,number price,string itemType)
{
local item = {imageRUID, count, name, price, itemType}

table.insert(self.Items, item)

if itemType == "Gita" then table.insert(self.Gita_Items, item)
elseif itemType == "Use" then table.insert(self.Use_Items, item)
elseif itemType == "Equip" then table.insert(self.Equip_Items, item)
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void RemoveItem(string name)
{
local Removeitem
local itemType
for i, item in pairs(self.Items) do
	if item[3] == name then
		Removeitem = i
		itemType = item[5]
	end 
end
table.remove(self.Items, Removeitem)


if itemType == "Gita" then 
	for i, item in pairs(self.Gita_Items) do
		if item[3] == name then
			Removeitem = i
		end
	end
	table.remove(self.Gita_Items, Removeitem)
elseif itemType == "Use" then 
	for i, item in pairs(self.Use_Items) do
		if item[3] == name then
			Removeitem = i
		end
	end
	table.remove(self.Use_Items, Removeitem)
elseif itemType == "Equip" then 
	for i, item in pairs(self.Equip_Items) do
		if item[3] == name then
			Removeitem = i
		end
	end
	table.remove(self.Equip_Items, Removeitem)
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnUpdate(number delta)
{
-- 굳이 업데이트 이용한 이유는 UISpriteConponent가 늦게 적용되기 때문에 이 부분에 오류가 자주 발생되었기 때문이다.
if self.Entity.Parent.Enable then
	if self._T.FirstScrolled == nil then		

		self._T.StartPos = 
		self.UpButton.WorldPosition.y - (self.UpButton.RectSize.y / 2) - 5

		self._T.EndPos = 
		self.DownButton.WorldPosition.y + (self.DownButton.RectSize.y / 2) + 5

		self._T.Height = math.abs(self._T.StartPos - self._T.EndPos)
		
		-- 리사이즈 (UISpriteComponent의 (움직이는 대상에 대한 버그 로 인한 삭제 후) 대체)
		self.ScrollBar.RectSize.x = self.UpButton.RectSize.x
		self.ScrollBar.RectSize.y = self.UpButton.RectSize.x * 1.65
		
		
	end
	if self.ISee == 1 and (self.ScrollBar.WorldPosition.y ~= self._T.StartPos) then self.ScrollBar.WorldPosition.y =  self._T.StartPos end
end

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void Update_SlotUI()
{
if self.SortType == "All" then for i = 1, 5 do self:SetSlot(i, self.Items[i + self.ISee - 1]) end
elseif self.SortType == "Gita" then for i = 1, 5 do self:SetSlot(i, self.Gita_Items[i + self.ISee - 1]) end
elseif self.SortType == "Use" then for i = 1, 5 do self:SetSlot(i, self.Use_Items[i + self.ISee - 1]) end
elseif self.SortType == "Equip" then for i = 1, 5 do self:SetSlot(i, self.Equip_Items[i + self.ISee - 1]) end
end
-- 슬롯 아이템 목록 변경
--for i = 1, 5 do self:SetSlot(i, self.Items[i + self.ISee - 1]) end

-- 슬롯 색상 변경
for i, slot in pairs(self.Slots) do 
	local item_info = slot:GetChildByName("item_info")
	local RUID
	if i + self.ISee - 1 == self.Selected then RUID = "46b6d2e0d5a044a8ac436f4680a258e8"
	else RUID = "2f472441db404a7c8b37bfc0d5a7c9d2" end
	item_info.SpriteGUIRendererComponent.ImageRUID = RUID
end

-- 스크롤바 필요유무 체크
if self.SortType == "All" then if #self.Items > 5 then self.ScrollBar.Entity.Visible = true else self.ScrollBar.Entity.Visible = false end
elseif self.SortType == "Gita" then if #self.Gita_Items > 5 then self.ScrollBar.Entity.Visible = true else self.ScrollBar.Entity.Visible = false end
elseif self.SortType == "Use" then if #self.Use_Items > 5 then self.ScrollBar.Entity.Visible = true else self.ScrollBar.Entity.Visible = false end
elseif self.SortType == "Equip" then if #self.Equip_Items > 5 then self.ScrollBar.Entity.Visible = true else self.ScrollBar.Entity.Visible = false end
end



}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void ShopButtonEventInit()
{
local Popup = _EntityService:GetEntity("e1fe0b7d-cbcf-4637-8fc4-09e518e7077c").ShopPopup
-- 선택 버튼, 이벤트

local ShopItemSlots = _EntityService:GetEntity("013aa3bf-42a4-4a86-950a-066d92997da5")
local SellItemSlots = _EntityService:GetEntity("4f466ca9-62be-4b79-86e9-9d7fc1a3a79a")

-- 구매 판매 버튼(이벤트는 맨아래정도에 등록)
local buyButton = _EntityService:GetEntityByPath("/ui/DefaultGroup/Shop_Inventory/ShopPanel/BuyButton")
local sellButton = _EntityService:GetEntityByPath("/ui/DefaultGroup/Shop_Inventory/ShopPanel/SellButton")

if self.Entity == SellItemSlots then

	self.SortType = "Gita"
	self:Update_SlotUI()
	
	
	
--  탭 선택 버튼, 이벤트
local SellGita = _EntityService:GetEntity("0a5d8433-3022-489a-95ac-b7563a13b6db")
local SellUse = _EntityService:GetEntity("369a7091-2170-454d-8794-b6aac4928e7e")
local SellEquip = _EntityService:GetEntity("7ad274cf-7b20-417e-85c7-87883052304f")

local ClickedTap = SellGita

local TapClicked = function(event)
	_SoundService:PlaySound("41e8fd9385274442976a852eb7422f08", 1)
	if event.Entity == ClickedTap then return 
	else
		sellButton.ButtonComponent.Enable = false
		--buyButton.ButtonComponent.Enable = false
		local RUID
		if ClickedTap == SellGita then RUID = "e17f4250aeed42ec88d849b84400555b"
		elseif ClickedTap == SellUse then RUID = "3970a8b02c1e49d58088f73af67b2d49"
		elseif ClickedTap == SellEquip then RUID = "e26f870cde694c06ba1ab46c886276ad"
		end
		ClickedTap.SpriteGUIRendererComponent.ImageRUID = RUID
		ClickedTap = event.Entity
		if ClickedTap == SellGita then
			RUID = "12d15c581d0d4d5d81cc875ae0656156"
			self.SortType = "Gita"
			self.Selected = nil
		elseif ClickedTap == SellUse then
			RUID = "1d1aa486addf42a886db51d136bf7578"
			self.SortType = "Use"
			self.Selected = nil
		elseif ClickedTap == SellEquip then
			RUID = "0b570dd4d11542c19b4e76c1d0601d23"
			self.SortType = "Equip"
			self.Selected = nil
		end
		ClickedTap.SpriteGUIRendererComponent.ImageRUID = RUID
		self:Update_SlotUI()
	end
end

SellGita:ConnectEvent(ButtonClickEvent, TapClicked)
SellUse:ConnectEvent(ButtonClickEvent, TapClicked)
SellEquip:ConnectEvent(ButtonClickEvent, TapClicked)
end





local buyselectbuttons = ShopItemSlots.Children:ToTable()
local sellselectbuttons = SellItemSlots.Children:ToTable()
local selectButtons = {}
for i, button in pairs(buyselectbuttons) do table.insert(selectButtons, button) end
for i, button in pairs(sellselectbuttons) do table.insert(selectButtons, button) end

local selectFunc = function(event)
	for i, slot in pairs(selectButtons)do
		local item_info = slot:GetChildByName("item_info")
		if slot == event.Entity then 
			
			if slot.Parent == ShopItemSlots then
				buyButton.ButtonComponent.Enable = true
				sellButton.ButtonComponent.Enable = false
				
				local itemtype = slot.Parent.UIScroll.SortType
				if itemtype == "All" then
					if ShopItemSlots.UIScroll.Items[i + slot.Parent.UIScroll.ISee - 1] == nil then return end
				elseif itemtype == "Gita" then
					if ShopItemSlots.UIScroll.Gita_Items[i + slot.Parent.UIScroll.ISee - 1] == nil then return end
				elseif itemtype == "Use" then
					if ShopItemSlots.UIScroll.Use_Items[i + slot.Parent.UIScroll.ISee - 1] == nil then return end
				elseif itemtype == "Equip" then
					if ShopItemSlots.UIScroll.Equip_Items[i + slot.Parent.UIScroll.ISee - 1] == nil then return end
				end
					--if ShopItemSlots.UIScroll.Items[i + slot.Parent.UIScroll.ISee - 1] == nil then return end
			
				ShopItemSlots.UIScroll.Selected = i + slot.Parent.UIScroll.ISee - 1
				SellItemSlots.UIScroll.Selected = nil
				SellItemSlots.UIScroll.Selected_Item = nil
			elseif slot.Parent == SellItemSlots then
				buyButton.ButtonComponent.Enable = false
				sellButton.ButtonComponent.Enable = true
				
				local itemtype = slot.Parent.UIScroll.SortType
				if itemtype == "All" then
					if SellItemSlots.UIScroll.Items[i + slot.Parent.UIScroll.ISee - 1 - 5] == nil then return end
				elseif itemtype == "Gita" then
					if SellItemSlots.UIScroll.Gita_Items[i + slot.Parent.UIScroll.ISee - 1 - 5] == nil then return end
				elseif itemtype == "Use" then
					if SellItemSlots.UIScroll.Use_Items[i + slot.Parent.UIScroll.ISee - 1 - 5] == nil then return end
				elseif itemtype == "Equip" then
					if SellItemSlots.UIScroll.Equip_Items[i + slot.Parent.UIScroll.ISee - 1 - 5] == nil then return end
				end
					--if SellItemSlots.UIScroll.Items[i + slot.Parent.UIScroll.ISee - 1 - 5] == nil then return end
		
				SellItemSlots.UIScroll.Selected = i + slot.Parent.UIScroll.ISee - 1 - 5
				ShopItemSlots.UIScroll.Selected = nil
				ShopItemSlots.UIScroll.Selected_Item = nil
			else
				log("아무 슬롯에도 등록되어있지 않음! 오류!")				
			end
		
			local itemtype = slot.Parent.UIScroll.SortType	
			if itemtype == "All" then
				if slot.Parent.UIScroll.Items[slot.Parent.UIScroll.Selected] == nil then slot.Parent.UIScroll.Selected = nil return end
			elseif itemtype == "Gita" then
				if slot.Parent.UIScroll.Gita_Items[slot.Parent.UIScroll.Selected] == nil then slot.Parent.UIScroll.Selected = nil return end
			elseif itemtype == "Use" then
				if slot.Parent.UIScroll.Use_Items[slot.Parent.UIScroll.Selected] == nil then slot.Parent.UIScroll.Selected = nil return end
			elseif itemtype == "Equip" then
				if slot.Parent.UIScroll.Equip_Items[slot.Parent.UIScroll.Selected] == nil then slot.Parent.UIScroll.Selected = nil return end
			end
			
			
			
			--if slot.Parent.UIScroll.Items[slot.Parent.UIScroll.Selected] == nil then slot.Parent.UIScroll.Selected = nil return end
			
			if itemtype == "All" then
				slot.Parent.UIScroll.Selected_Item = slot.Parent.UIScroll.Items[slot.Parent.UIScroll.Selected]
			elseif itemtype == "Gita" then
				slot.Parent.UIScroll.Selected_Item = slot.Parent.UIScroll.Gita_Items[slot.Parent.UIScroll.Selected]
			elseif itemtype == "Use" then
				slot.Parent.UIScroll.Selected_Item = slot.Parent.UIScroll.Use_Items[slot.Parent.UIScroll.Selected]
			elseif itemtype == "Equip" then
				slot.Parent.UIScroll.Selected_Item = slot.Parent.UIScroll.Equip_Items[slot.Parent.UIScroll.Selected]
			end
			--slot.Parent.UIScroll.Selected_Item = slot.Parent.UIScroll.Items[slot.Parent.UIScroll.Selected]
			ShopItemSlots.UIScroll:Update_SlotUI()
			SellItemSlots.UIScroll:Update_SlotUI()
			log(slot.Parent.UIScroll.Selected_Item[5].."아이템 - "..slot.Parent.UIScroll.Selected_Item[3]..": "..slot.Parent.UIScroll.Selected_Item[4].."원")
		end
	end
end

if self.Entity == ShopItemSlots then -- Shop 에서 딱 한번만 등록하기
	for key, value in pairs(selectButtons) do value:ConnectEvent(ButtonClickEvent, selectFunc) end
end


-- 사기 버튼, 이벤트

local buyFunc = function()
	if self.Selected == nil then log("선택된아이템이 없습니다")  
	SellItemSlots.UIScroll.Selected = nil
	ShopItemSlots.UIScroll.Selected = nil
	ShopItemSlots.UIScroll:Update_SlotUI()
	SellItemSlots.UIScroll:Update_SlotUI()
	return end
		
	local AcquiredItem = self.Selected_Item[3]
	local BuyPrice = self.Selected_Item[4]
	
	Popup:Popup("몇 개를 사시겠습니까?", AcquiredItem, BuyPrice, "Shop")
end
if self.Entity == ShopItemSlots then -- Shop
	buyButton:ConnectEvent(ButtonClickEvent, buyFunc)
end



-- 팔기 버튼, 이벤트

local sellFunc = function()
	if self.Selected == nil then log("선택된아이템이 없습니다") 
	SellItemSlots.UIScroll.Selected = nil
	ShopItemSlots.UIScroll.Selected = nil
	ShopItemSlots.UIScroll:Update_SlotUI()
	SellItemSlots.UIScroll:Update_SlotUI()
	return end
		
	local SelledItem = self.Selected_Item[3]
	local SellPrice = self.Selected_Item[4]
	
	Popup:Popup("몇 개를 파시겠습니까?", SelledItem, SellPrice, "Sell")
end
if self.Entity == SellItemSlots then	 -- Sell
	sellButton:ConnectEvent(ButtonClickEvent, sellFunc)
end
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=service:InputService
--@ EventName=MouseScrollEvent
HandleMouseScrollEvent
{
-- Parameters
local ScrollDelta = event.ScrollDelta
--------------------------------------------------------
if self.Entity.Parent.Enable and self.Entity.Enable and self._T.Hover then
	local dir
	if ScrollDelta > 0 then dir = -1 else dir = 1 end
	self:Scrolled(dir)
end

}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=localPlayer
--@ EventName=InventoryItemInitEvent
HandleInventoryItemInitEvent
{
if self.Entity.Parent.Name == "Shop_Inventory" then return end -- "Sell_Inventory"만 해당하므로
-- Parameters
local Entity = event.Entity
local Items = event.Items
--------------------------------------------------------
for i, item in pairs(Items) do
	if item.ItemCount <= 0 then
		_ItemService:RemoveItem(item)
	else
		
		self:AddItem(item.IconRUID, tonumber(item.ItemCount), item.ItemDataTableName, tonumber(item.ItemTableData:GetItem("SellPrice")), item.ItemTypeName)
		
		self:Update_SlotUI()
	end
	
	
end

}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=localPlayer
--@ EventName=InventoryItemAddedEvent
HandleInventoryItemAddedEvent
{
if self.Entity.Parent.Name == "Shop_Inventory" then return end
-- Parameters
local Entity = event.Entity
local Items = event.Items

for i, item in pairs(Items) do
	for j, tem in pairs(self.Items) do
		if tem[3] == item.ItemDataTableName and tem[5] ~= "Equip" then
			log("이미 존재하니까 안추가할래") return end
	end
	self:AddItem(item.IconRUID, tonumber(item.ItemCount), item.ItemDataTableName, tonumber(item.ItemTableData:GetItem("SellPrice")), item.ItemTypeName)
	self:Update_SlotUI()
end



--]]
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=localPlayer
--@ EventName=InventoryItemModifiedEvent
HandleInventoryItemModifiedEvent
{

if self.Entity.Parent.Name == "Shop_Inventory" then return end
-- Parameters
local Entity = event.Entity
local Items = event.Items
--------------------------------------------------------
for i, item in pairs(Items) do	
	if item.ItemCount <= 0 then
		
		self:RemoveItem(item.ItemDataTableName)
		_ItemService:RemoveItem(item)
		self.Selected = nil
		self.Selected_Item = nil
		if self.ISee == #self.Items + 1 - 4 then self:Scrolled(-1) end
		self:Update_SlotUI()
		log(item.ItemDataTableName.."의 수량이 "..item.ItemCount.."이 되어 아이템에서 제거합니다.")	
	else	
		local isIn = false
		local ItemType
		for j, tem in pairs(self.Items) do
			if tem[3] == item.ItemDataTableName then
				isIn = true
				tem[2] = item.ItemCount --리스트 아이템과 인벤토리 아이템의 존재 개수 동기화
				ItemType = tem[5]
			end
		end
		if not isIn then self:AddItem(item.IconRUID, tonumber(item.ItemCount), item.ItemDataTableName, tonumber(item.ItemTableData:GetItem("SellPrice")), item.ItemTypeName)  end
		
		if ItemType == "Gita" then
			for j, tem in pairs(self.Gita_Items) do
			if tem[3] == item.ItemDataTableName then
				tem[2] = item.ItemCount --리스트 아이템과 인벤토리 아이템의 존재 개수 동기화
			end
		end
		elseif ItemType == "Use" then
			for j, tem in pairs(self.Use_Items) do
			if tem[3] == item.ItemDataTableName then
				tem[2] = item.ItemCount --리스트 아이템과 인벤토리 아이템의 존재 개수 동기화
			end
		end
		elseif ItemType == "Equip" then
			for j, tem in pairs(self.Equip_Items) do
			if tem[3] == item.ItemDataTableName then
				tem[2] = item.ItemCount --리스트 아이템과 인벤토리 아이템의 존재 개수 동기화
			end
		end
		end

		self:Update_SlotUI()
			
	end
	
end

}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=localPlayer
--@ EventName=InventoryItemRemovedEvent
HandleInventoryItemRemovedEvent
{
if self.Entity.Parent.Name == "Shop_Inventory" then return end
-- Parameters
local Entity = event.Entity
local Items = event.Items
--------------------------------------------------------
self:Update_SlotUI()
}
--@ EndEntityEventHandler

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=ButtonStateChangeEvent
HandleButtonStateChangeEvent
{
-- Parameters
local state = event.state
--------------------------------------------------------
if state == ButtonState.Hover then self._T.Hover = true else self._T.Hover = false end
}
--@ EndEntityEventHandler

