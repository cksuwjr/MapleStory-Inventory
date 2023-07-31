--@ BeginProperty
--@ SyncDirection=None
any item = "nil"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string itemGUID = """"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=All
void SetData(any item)
{
self.item = item

local imageEntity = self.Entity:GetChildByName("img_slot")
imageEntity.SpriteGUIRendererComponent.ImageRUID = item.IconRUID

imageEntity:GetChildByName("item_count").TextComponent.Text = tostring(item.ItemCount)
self.itemGUID = item.GUID

--[[
if self.Entity.Parent.Name == "Sell_Inventory" then -- 허 추가. 나머진 시스템이 만듦
	local item_info = self.Entity:GetChildByName("item_info")
	item_info:GetChildByName("item_name").TextComponent.Text = tostring(item.ItemDataTableName)
	item_info:GetChildByName("item_price").TextComponent.Text = tostring(item.ItemTableData:GetItem("SellPrice").." 메소")
end
--]]
}
--@ EndMethod

--@ BeginEntityEventHandler
--@ Scope=All
--@ Target=self
--@ EventName=ButtonClickEvent
HandleButtonClickEvent
{
-- Parameters
local Entity = event.Entity
--------------------------------------------------------

if self.item == nil then
	return
end

-- TODO: item logic
}
--@ EndEntityEventHandler

