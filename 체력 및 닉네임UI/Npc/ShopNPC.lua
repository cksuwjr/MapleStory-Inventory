--@ BeginProperty
--@ SyncDirection=None
table SellItems = "{}"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem1 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem2 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem3 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem4 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem5 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem6 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem7 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem8 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem9 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem10 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem11 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem12 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem13 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem14 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem15 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem16 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem17 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem18 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem19 = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string SellItem20 = """"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnInitialize()
{
self.Entity.UITransformComponent.WorldPosition.x = self.Entity.Parent.TransformComponent.Position.x
self.Entity.UITransformComponent.WorldPosition.y = self.Entity.Parent.TransformComponent.Position.y + 0.4

---------------------- 판매 품목 -----------------------


local SellProducts = {}

	
if self.SellItem1 ~= "" then table.insert(SellProducts, self.SellItem1) end
if self.SellItem2 ~= "" then table.insert(SellProducts, self.SellItem2) end
if self.SellItem3 ~= "" then table.insert(SellProducts, self.SellItem3) end
if self.SellItem4 ~= "" then table.insert(SellProducts, self.SellItem4) end
if self.SellItem5 ~= "" then table.insert(SellProducts, self.SellItem5) end
if self.SellItem6 ~= "" then table.insert(SellProducts, self.SellItem6) end
if self.SellItem7 ~= "" then table.insert(SellProducts, self.SellItem7) end
if self.SellItem8 ~= "" then table.insert(SellProducts, self.SellItem8) end
if self.SellItem9 ~= "" then table.insert(SellProducts, self.SellItem9) end
if self.SellItem10 ~= "" then table.insert(SellProducts, self.SellItem10) end
if self.SellItem11 ~= "" then table.insert(SellProducts, self.SellItem11) end
if self.SellItem12 ~= "" then table.insert(SellProducts, self.SellItem12) end
if self.SellItem13 ~= "" then table.insert(SellProducts, self.SellItem13) end
if self.SellItem14 ~= "" then table.insert(SellProducts, self.SellItem14) end
if self.SellItem15 ~= "" then table.insert(SellProducts, self.SellItem15) end
if self.SellItem16 ~= "" then table.insert(SellProducts, self.SellItem16) end
if self.SellItem17 ~= "" then table.insert(SellProducts, self.SellItem17) end
if self.SellItem18 ~= "" then table.insert(SellProducts, self.SellItem18) end
if self.SellItem19 ~= "" then table.insert(SellProducts, self.SellItem19) end
if self.SellItem20 ~= "" then table.insert(SellProducts, self.SellItem20) end


local dataset = _DataService:GetTable("UserItemDataSet")
for i = 1, dataset:GetRowCount() do
	for j, what in pairs(SellProducts) do
		if dataset:GetCell(i, "Name") == what then
			self:AddItem(dataset:GetCell(i, "IconRUID"), 0, what, tonumber(dataset:GetCell(i, "Price")), dataset:GetCell(i, "Type"))
		end
	end
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
self:AddClickEvent()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void AddItem(string imageRUID,number count,string name,number price,string itemType)
{
local itemtype
-- 아이템 타입이 추가될 경우 여기에 추가!!!
	if itemType == "기타" then itemtype = "Gita"
elseif itemType == "소비" then itemtype = "Use"
elseif itemType == "장비" then itemtype = "Equip"
else log("정의된 타입이 아니네요. 여기에 추가해주세요") return end


local item = {imageRUID, count, name, price, itemtype}
table.insert(self.SellItems, item)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void AddClickEvent()
{
local ShopUI = _EntityService:GetEntityByPath("/ui/DefaultGroup/Shop_Inventory").UIShop
local ClickCount = 0
local OnClicked = function() -- 클릭 Counter
	ClickCount = ClickCount + 1
	--log("클릭"..ClickCount)
	local clickcounter = function() ClickCount = 0 end -- 더블클릭 제한시간 0.6초
	_TimerService:SetTimerOnce(clickcounter, 0.6)
	if ClickCount > 1 then ShopUI:OpenShop(self.SellItems) end -- 더블클릭시 상점 UI 활성화
end
self.Entity:ConnectEvent(ButtonClickEvent, OnClicked)

}
--@ EndMethod

