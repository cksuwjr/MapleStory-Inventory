--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{
self:LoadAllData()

local setUIInfo = function()
	_EntityService:GetEntityByPath("/ui/DefaultGroup/UIMyInfo").UIMyInfoMine:StatInit()
	
	local StatusTab = _EntityService:GetEntityByPath("/ui/DefaultGroup/StatusTab")
	StatusTab.FirstStatus:FixedValueInit()
	StatusTab.FirstStatus:Update_StatusTab()
	StatusTab.FirstStatus:Update_HPMPEXP_Tab()
	StatusTab.DetailStatus:DetailFixedValue()
	StatusTab.DetailStatus:MagicAttack()
	
end

_TimerService:SetTimerOnce(setUIInfo, 0.85)
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void SetData(string What,number num)
{
local SetComplete = function(key) log(key.."의 설정이 저장되었습니다: "..num) end

local MyData = _DataStorageService:GetUserDataStorage(self.Entity.Name)
--MyData:SetAsync(What, tostring(num), SetComplete(What))       -- 데이터 설정 ex   "Level", tostring(3), 완료시콜백할함수
MyData:SetAsync(What, tostring(num), nil)--SetComplete(What))       -- 데이터 설정 ex   "Level", tostring(3), 완료시콜백할함수
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Server
void GetData(string What)
{
local MyData = _DataStorageService:GetUserDataStorage(self.Entity.Name)

local callback = function(errorcode, key, value)
	if key == "Level" then 
		self.Entity.MpExp.Level = tonumber(value)
		if value == nil then self.Entity.MpExp.Level = 1 end 
	elseif key == "MaxHp" then
		self.Entity.PlayerComponent.MaxHp = tonumber(value)
		if value == nil then self.Entity.PlayerComponent.MaxHp = 500 end 
	elseif key == "Hp" then
		self.Entity.PlayerComponent.Hp = tonumber(value)
		if value == nil then self.Entity.PlayerComponent.Hp = 500 end 
	elseif key == "MaxMp" then
		self.Entity.MpExp.MaxMp = tonumber(value)
		if value == nil then self.Entity.MpExp.MaxMp = 500 end 
	elseif key == "Mp" then
		self.Entity.MpExp.Mp = tonumber(value)
		if value == nil then self.Entity.MpExp.Mp = 500 end 
	elseif key == "MaxExp" then
		self.Entity.MpExp.MaxExp = tonumber(value)
		if value == nil then self.Entity.MpExp.MaxExp = 500 end 
	elseif key == "Exp" then
		self.Entity.MpExp.Exp = tonumber(value)
		if value == nil then self.Entity.MpExp.Exp = 0 end 
	elseif key == "Money" then
		self.Entity.MpExp.Money = tonumber(value)
		if value == nil then self.Entity.MpExp.Money = 0 end 		
	elseif key == "STR" then
		self.Entity.MpExp.STR = tonumber(value)
		if value == nil then self.Entity.MpExp.STR = 4 end
	elseif key == "DEX" then
		self.Entity.MpExp.DEX = tonumber(value)
		if value == nil then self.Entity.MpExp.DEX = 4 end
	elseif key == "INT" then
		self.Entity.MpExp.INT = tonumber(value)
		if value == nil then self.Entity.MpExp.INT = 4 end
	elseif key == "LUK" then
		self.Entity.MpExp.LUK = tonumber(value)
		if value == nil then self.Entity.MpExp.LUK = 4 end
	elseif key == "AP" then
		self.Entity.MpExp.Ap = tonumber(value)
		if value == nil then self.Entity.MpExp.Ap = 0 end
	elseif key == "PA" then
		self.Entity.MpExp.PA = tonumber(value)
		if value == nil then self.Entity.MpExp.PA = 0 end
	elseif key == "MaxPA" then
		self.Entity.MpExp.MaxPA = tonumber(value)
		if value == nil then self.Entity.MpExp.MaxPA = 100 end
	elseif key == "PhysicsDefence" then
		self.Entity.MpExp.PhysicsDefence = tonumber(value)
		if value == nil then self.Entity.MpExp.PhysicsDefence = 50 end
	elseif key == "MagicDefence" then
		self.Entity.MpExp.MagicDefence = tonumber(value)
		if value == nil then self.Entity.MpExp.MagicDefence = 50 end
	elseif key == "MA" then
		self.Entity.MpExp.MA = tonumber(value)
		if value == nil then self.Entity.MpExp.MA = 0 end
	elseif key == "MaxMA" then
		self.Entity.MpExp.MaxMA = tonumber(value)
		if value == nil then self.Entity.MpExp.MaxMA = 0 end		
	end
end
MyData:GetAsync(What, callback) 
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void LoadAllData()
{

self:GetData("Level")
self:GetData("MaxHp")
self:GetData("Hp")
self:GetData("MaxMp")
self:GetData("Mp")
self:GetData("MaxExp")
self:GetData("Exp")

self:GetData("Money")

self:GetData("STR")
self:GetData("DEX")
self:GetData("INT")
self:GetData("LUK")

self:GetData("AP")

self:GetData("PA")
self:GetData("MaxPA")
self:GetData("MA")
self:GetData("MaxMA")
self:GetData("PhysicsDefence")
self:GetData("MagicDefence")

log("데이터를 불러옵니다.")

log("!!! 데이터 저장은 Space바, 스탯창 오픈은 F를 이용해주세요.")

}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=Client
void SaveAllData()
{
self:SetData("Level", self.Entity.MpExp.Level)
self:SetData("MaxHp", self.Entity.PlayerComponent. MaxHp)
self:SetData("Hp", self.Entity.PlayerComponent.Hp)
self:SetData("MaxMp", self.Entity.MpExp.MaxMp)
self:SetData("Mp", self.Entity.MpExp.Mp)
self:SetData("MaxExp", self.Entity.MpExp.MaxExp)
self:SetData("Exp", self.Entity.MpExp.Exp)

self:SetData("Money", self.Entity.MpExp.Money)

self:SetData("STR", self.Entity.MpExp.STR)
self:SetData("DEX", self.Entity.MpExp.DEX)
self:SetData("INT", self.Entity.MpExp.INT)
self:SetData("LUK", self.Entity.MpExp.LUK)

self:SetData("AP", self.Entity.MpExp.Ap)

self:SetData("PA", self.Entity.MpExp.PA)
self:SetData("MaxPA", self.Entity.MpExp.MaxPA)
self:SetData("MA", self.Entity.MpExp.MA)
self:SetData("MaxMA", self.Entity.MpExp.MaxMA)

self:SetData("PhysicsDefence", self.Entity.MpExp.PhysicsDefence)
self:SetData("MagicDefence", self.Entity.MpExp.MagicDefence)



log("데이터가 저장되었습니다")

log("!!! 저장되는값: Hp, Mp, Exp, 및 Status의 모든 값..")
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
if key == KeyboardKey.Space then
	self:SaveAllData()
end
}
--@ EndEntityEventHandler

