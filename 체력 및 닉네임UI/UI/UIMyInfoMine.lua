--@ BeginProperty
--@ SyncDirection=None
Component hpBar = ":SpriteGUIRendererComponent"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Component mpBar = ":SpriteGUIRendererComponent"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
Component expBar = ":SpriteGUIRendererComponent"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{

local currentPath = self.Entity.Path
local nameText = _EntityService:GetEntityByPath(currentPath .. "/Info_Bott/HPMP/AllCover/CoverText/PlayerNameText")
nameText.TextComponent.Text = _UserService.LocalPlayer.PlayerComponent.Nickname
self.hpBar = _EntityService:GetEntityByPath(currentPath .. "/Info_Bott/HPMP/HP/HPbar").SpriteGUIRendererComponent
self.mpBar = _EntityService:GetEntityByPath(currentPath .. "/Info_Bott/HPMP/MP/MPbar").SpriteGUIRendererComponent
self.expBar = _EntityService:GetEntityByPath(currentPath .. "/Info_Bott/EXP/EXPbar").SpriteGUIRendererComponent

local UiAbilityP = _EntityService:GetEntityByPath("/ui/DefaultGroup/StatusTab/Model_FirstStatus/Ap_T").TextComponent
UiAbilityP.Text = math.floor(_UserService.LocalPlayer.MpExp.Ap)

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnUpdate(number delta)
{
if self.hpBar ~= nil then			-- HP바 실시간 조정
	local hp = _UserService.LocalPlayer.PlayerComponent.Hp
	local maxhp = _UserService.LocalPlayer.PlayerComponent.MaxHp	
	self.hpBar.FillAmount = hp / maxhp
end
if self.mpBar ~= nil then			-- MP바 실시간 조정
	local mp = _UserService.LocalPlayer.MpExp.Mp
	local maxmp = _UserService.LocalPlayer.MpExp.MaxMp
	self.mpBar.FillAmount = mp / maxmp
end
if self.expBar ~= nil then			-- EXP바 실시간 조정
	local exp = _UserService.LocalPlayer.MpExp.Exp
	local maxexp = _UserService.LocalPlayer.MpExp.MaxExp
	self.expBar.FillAmount = exp / maxexp
end
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void LevelUp()
{
_UserService.LocalPlayer.MpExp.Level = _UserService.LocalPlayer.MpExp.Level + 1
_UserService.LocalPlayer.Player:LevelUp()

-- 레벨업 할 때마다 Ap 5 증가
_UserService.LocalPlayer.MpExp.Ap = _UserService.LocalPlayer.MpExp.Ap + 5

local currentPath = self.Entity.Path
local LevelText = _EntityService:GetEntityByPath(currentPath .. "/Info_Bott/HPMP/AllCover/CoverText/LevelText")

-- Ap_T에 MpExp.Ap 출력
local UiAbilityP = _EntityService:GetEntityByPath("/ui/DefaultGroup/StatusTab/Model_FirstStatus/Ap_T").TextComponent
UiAbilityP.Text = math.floor(_UserService.LocalPlayer.MpExp.Ap)

LevelText.TextComponent.Text = string.format("%d", _UserService.LocalPlayer.MpExp.Level)

-- 물리 방어력, 마법 방어력 증가
_UserService.LocalPlayer.MpExp.PhysicsDefence = _UserService.LocalPlayer.MpExp.PhysicsDefence + 100
_UserService.LocalPlayer.MpExp.MagicDefence = _UserService.LocalPlayer.MpExp.MagicDefence + 100

-- 최대 경험치 증가
_UserService.LocalPlayer.MpExp.Exp = 0
_UserService.LocalPlayer.MpExp.MaxExp = _UserService.LocalPlayer.MpExp.Level * 500

-- 최대 체력 증가
_UserService.LocalPlayer.PlayerComponent.MaxHp = 1000 + 350 * _UserService.LocalPlayer.MpExp.Level
_UserService.LocalPlayer.PlayerComponent.Hp = _UserService.LocalPlayer.PlayerComponent.MaxHp

-- 최대 마나 증가
_UserService.LocalPlayer.MpExp.MaxMp = 500 + 180 * _UserService.LocalPlayer.MpExp.Level
_UserService.LocalPlayer.MpExp.Mp = _UserService.LocalPlayer.MpExp.MaxMp


_EntityService:GetEntityByPath("/ui/DefaultGroup/StatusTab").ButtonOnClick:ImageInit()

_EntityService:GetEntityByPath("/ui/DefaultGroup/StatusTab").FirstStatus:UISetAbilityPoint()

self:StatInit()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void HPAdd(number data)
{
_UserService.LocalPlayer.PlayerComponent.Hp = _UserService.LocalPlayer.PlayerComponent.Hp + data
local HP = _UserService.LocalPlayer.PlayerComponent.Hp
local MaxHP = _UserService.LocalPlayer.PlayerComponent.MaxHp
local text = string.format("%d / %d", HP, MaxHP)
_EntityService:GetEntityByPath(self.Entity.Path .. "/Info_Bott/HPMP/HP/HPtext").TextComponent.Text = text

_EntityService:GetEntityByPath("/ui/DefaultGroup/StatusTab").FirstStatus:Update_HPMPEXP_Tab()
--_EntityService:GetEntityByPath("/ui/StatusTab").FirstStatus:UpdateStatusTab()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void MPAdd(number data)
{
_UserService.LocalPlayer.MpExp.Mp = _UserService.LocalPlayer.MpExp.Mp + data
local MP = _UserService.LocalPlayer.MpExp.Mp
local MaxMP = _UserService.LocalPlayer.MpExp.MaxMp
local text = string.format("%d / %d", MP, MaxMP)
_EntityService:GetEntityByPath(self.Entity.Path .. "/Info_Bott/HPMP/MP/MPtext").TextComponent.Text = text

_EntityService:GetEntityByPath("/ui/DefaultGroup/StatusTab").FirstStatus:Update_HPMPEXP_Tab()
--_EntityService:GetEntityByPath("/ui/StatusTab").FirstStatus:UpdateStatusTab()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void EXPAdd(number data)
{
_UserService.LocalPlayer.MpExp.Exp = _UserService.LocalPlayer.MpExp.Exp + data
if _UserService.LocalPlayer.MpExp.Exp >= _UserService.LocalPlayer.MpExp.MaxExp then self:LevelUp() end
local EXP = _UserService.LocalPlayer.MpExp.Exp
local MaxEXP = _UserService.LocalPlayer.MpExp.MaxExp
local text = string.format("%d / %d   [%.2f", EXP, MaxEXP, (EXP/MaxEXP) * 100).."%]"
_EntityService:GetEntityByPath(self.Entity.Path .. "/Info_Bott/EXP/EXPtext").TextComponent.Text = text

_EntityService:GetEntityByPath("/ui/DefaultGroup/StatusTab").FirstStatus:Update_HPMPEXP_Tab()
--_EntityService:GetEntityByPath("/ui/StatusTab").FirstStatus:UpdateStatusTab()
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void StatInit()
{
local currentPath = self.Entity.Path
local LevelText = _EntityService:GetEntityByPath(currentPath .. "/Info_Bott/HPMP/AllCover/CoverText/LevelText")
LevelText.TextComponent.Text = string.format("%d", _UserService.LocalPlayer.MpExp.Level)

self:HPAdd(0)  -- 체력 텍스트 초기화
self:MPAdd(0)  -- 마나 텍스트 초기화
self:EXPAdd(0)  -- 경험치 텍스트 초기화

self:MoneyAdd(0) -- 돈 텍스트 초기화
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void MoneyAdd(number data)
{
_UserService.LocalPlayer.MpExp.Money = _UserService.LocalPlayer.MpExp.Money + data
_EntityService:GetEntityByPath("/ui/DefaultGroup/Inventory/InventoryPanel/CoinPanel/coin_count").TextComponent.Text
= string.format("%d", _UserService.LocalPlayer.MpExp.Money) -- 인벤토리 돈ui변경
_EntityService:GetEntityByPath("/ui/DefaultGroup/Shop_Inventory/ShopPanel/CoinPanel/coin_count").TextComponent.Text
= string.format("%d", _UserService.LocalPlayer.MpExp.Money) -- 상점 돈ui변경

}
--@ EndMethod

