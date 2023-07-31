--@ BeginProperty
--@ SyncDirection=None
Entity Shop_Inventory = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Entity Sell_Inventory = "nil"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
self:AddAllButtonEvent()

self.Shop_Inventory = _EntityService:GetEntity("366714fa-f984-4636-af77-9cfdefe9b95f") --
self.Sell_Inventory = _EntityService:GetEntity("d41bb1cb-10b9-468a-a304-9dd331647b5d")

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void OpenShop(table inventory)
{
local Shop_ItemSlots = self.Shop_Inventory:GetChildByName("ItemSlots").UIScroll
Shop_ItemSlots.ISee = 1
table.clear(Shop_ItemSlots.Items) -- 기존의 것, 초기화
for i, item in pairs(inventory) do Shop_ItemSlots:AddItem(item[1], item[2], item[3], item[4], item[5]) end
Shop_ItemSlots:Update_SlotUI()
self.Entity.Enable = true
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void AddAllButtonEvent()
{

-- 닫기 버튼, 이벤트
local closeButton = _EntityService:GetEntityByPath(self.Entity.Path .. "/ShopPanel/CloseButton")
local closeFunc = function()
	self.Entity.Enable = false
end
closeButton:ConnectEvent(ButtonClickEvent, closeFunc)
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
if key == KeyboardKey.Escape and self.Entity.Enable then
	self.Entity.Enable = not self.Entity.Enable
end
}
--@ EndEntityEventHandler

