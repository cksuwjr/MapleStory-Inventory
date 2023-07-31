--@ BeginProperty
--@ SyncDirection=None
Component portalRange = ":PortalTrigger"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
boolean Fade = "false"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
number restTime = "0.5"
--@ EndProperty

--@ BeginProperty
--@ SyncDirection=None
string NextMapPortal = """"
--@ EndProperty

--@ BeginMethod
--@ MethodExecSpace=ClientOnly
void OnInitialize()
{
self.portalRange = self.Entity.PortalTrigger
}
--@ EndMethod

--@ BeginMethod
--@ MethodExecSpace=All
void Teleport()
{
_UserService.LocalPlayer.Fade:FadeIn(self.restTime)
wait(self.restTime)
_TeleportService:TeleportToEntityPath(_UserService.LocalPlayer, self.NextMapPortal)	
}
--@ EndMethod

