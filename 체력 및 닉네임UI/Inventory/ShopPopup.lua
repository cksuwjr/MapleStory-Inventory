--@ BeginProperty
--@ SyncDirection=None
string What = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number Price = "0"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string Type = """"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string TEXTT = """"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
self.Entity.Enable = false

self:ButtonEventInit()

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void Popup(string text,string What,number Price,string Sell_Or_Shop)
{
local spriteGUI = self.Entity.SpriteGUIRendererComponent
local btnNo = _EntityService:GetEntity("6da40c38-ed7f-4221-8230-ba15427efe12")
local btnYes1 = _EntityService:GetEntity("85bc9714-f4eb-42e4-a284-8bbbf2b192af")
local btnYes2 = _EntityService:GetEntity("d16f1bb4-e8bd-4430-b19e-e0e362d22783")
local TextInput = _EntityService:GetEntity("1841aef5-1fe2-4066-8032-f74432db10b5")
self.What = What
self.Price = Price
self.Type = Sell_Or_Shop
self.TEXTT = text
if text == "몇 개를 사시겠습니까?" then
	spriteGUI.ImageRUID = "115e48a5d35b46ee9ae47eb3256ab983"
	btnNo.Enable = true
	btnYes1.Enable = true
	btnYes2.Enable = false
	TextInput.Enable = true
	TextInput.TextComponent.Text = 0
elseif text == "몇 개를 파시겠습니까?" then
	spriteGUI.ImageRUID = "ca131dc8237a4f2a849a88438f26f9d1"
	btnNo.Enable = true
	btnYes1.Enable = true
	btnYes2.Enable = false
	TextInput.Enable = true
	
	local itemcount
	for index, item in pairs(_UserService.LocalPlayer.InventoryComponent:GetItemList()) do 
		if item.ItemDataTableName == self.What then 
			itemcount = item.ItemCount
			break
		end
	end
	TextInput.TextComponent.Text = itemcount
elseif text == "102이하의 숫자만 가능합니다." then
	spriteGUI.ImageRUID = "1c8c00ea00bd4403b7ff6787eb1ad69c"
	btnNo.Enable = false
	btnYes1.Enable = false
	btnYes2.Enable = true
	TextInput.Enable = false
elseif text == "메소가 부족합니다." then
	spriteGUI.ImageRUID = "f5c8166ba08c4d629b4e51c3b204a92f"
	btnNo.Enable = false
	btnYes1.Enable = false
	btnYes2.Enable = true
	TextInput.Enable = false
elseif text == "인벤토리 공간이 부족합니다." then
	spriteGUI.ImageRUID = "6a6947c5316e48ea811215881f7be71f"
	btnNo.Enable = false
	btnYes1.Enable = false
	btnYes2.Enable = true
	TextInput.Enable = false
elseif text == "정말로 파시겠습니까?" then
	spriteGUI.ImageRUID = "8d1ba334d123420fab324e21ef4b002c"
	btnNo.Enable = true
	btnYes1.Enable = true
	btnYes2.Enable = false
	TextInput.Enable = false
elseif text == "판매 가능한 수량을 초과하였습니다." then
	spriteGUI.ImageRUID = "ddfcb9c7aacc41df97db531d2872be7d"
	btnNo.Enable = false
	btnYes1.Enable = false
	btnYes2.Enable = true
	TextInput.Enable = false
end

self.Entity.Enable = true
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void ButtonEventInit()
{
local btnNo = _EntityService:GetEntity("6da40c38-ed7f-4221-8230-ba15427efe12")
local btnYes1 = _EntityService:GetEntity("85bc9714-f4eb-42e4-a284-8bbbf2b192af")
local btnYes2 = _EntityService:GetEntity("d16f1bb4-e8bd-4430-b19e-e0e362d22783")

local Exit = function()
	self.Entity.Enable = false
end
local Cal = function()
	
	
	local count = tonumber(_EntityService:GetEntity("1841aef5-1fe2-4066-8032-f74432db10b5").TextComponent.Text)
	if count > 102 then 
		self._T.Before = {self.TEXTT, self.What, self.Price, self.Type} 
		self:Popup("102이하의 숫자만 가능합니다.") 
		return 
	end
	if self.Type == "Shop" then
		
		if _UserService.LocalPlayer.MpExp.Money - (self.Price * count) < 0 then 
			log("돈이 부족합니다") 
			self._T.Before = {self.TEXTT, self.What, self.Price, self.Type}
			self:Popup("메소가 부족합니다.") 
			return 
		end
		_UserService.LocalPlayer.Player:InventoryInput(self.What, count)
		_EntityService:GetEntityByPath("/ui/DefaultGroup/UIMyInfo").UIMyInfoMine:MoneyAdd(-self.Price * count)
	
		log(self.What.."을 "..count.."개를 "..self.Price * count.."원에 ".."구매완료")
		--_EntityService:GetEntity("4f466ca9-62be-4b79-86e9-9d7fc1a3a79a").UIScroll:Update_SlotUI()
		self.Entity.Enable = false
	elseif self.Type == "Sell" then
		for index, item in pairs(_UserService.LocalPlayer.InventoryComponent:GetItemList()) do 
			if item.ItemDataTableName == self.What then 
				if item.ItemCount - count >= 0 then
					_UserService.LocalPlayer.Player:InventoryInput(self.What, -count)
 					_EntityService:GetEntityByPath("/ui/DefaultGroup/UIMyInfo").UIMyInfoMine:MoneyAdd(self.Price * count)
			
					log(self.What.."을 "..count.."개를 "..self.Price * count.."원에 ".."판매완료")
					--_EntityService:GetEntity("4f466ca9-62be-4b79-86e9-9d7fc1a3a79a").UIScroll:Update_SlotUI()
					self.Entity.Enable = false
				else
					self._T.Before = {self.TEXTT, self.What, self.Price, self.Type}
					
					self:Popup("판매 가능한 수량을 초과하였습니다.")
				end
			end
		end
	end
end
btnNo:ConnectEvent(ButtonClickEvent, Exit)
btnYes1:ConnectEvent(ButtonClickEvent, Cal)
--btnYes1:ConnectEvent(ButtonClickEvent, Exit)
btnYes2:ConnectEvent(ButtonClickEvent, function() if self._T.Before ~= nil then self:Popup(self._T.Before[1], self._T.Before[2], self._T.Before[3], self._T.Before[4]) end end)
}
--@ EndMethod

