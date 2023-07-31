--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnBeginPlay()
{

--local startbtn = _EntityService:GetEntityByPath("/maps/Login2/Point2_Objects/Menu/Start")
	_EntityService:GetEntityByPath("/ui/DefaultGroup/UIMyInfo").Enable = false
_UserService.LocalPlayer.RigidbodyComponent.Enable = false
}
--@ EndMethod

