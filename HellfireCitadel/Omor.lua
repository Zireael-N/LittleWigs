﻿------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Omor the Unscarred"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Omor",

	aura = "Treacherous Aura", -- needs to be exactly what it's called in game.
	aura_heroic = "Bane of Treachery",
	aura_desc = "Announce who has the Trecherous Aura",
	aura_trigger = "^(%S+) (%S+) afflicted by (.+)%.$",
	aura_warning = "%s has %s!",
	aura_bar = "%s: %s",

	icon = "Raid Icon",
	icon_desc = "Put a Raid Icon on the person who has the Treacherous Aura. (Requires promoted or higher)",
} end)

L:RegisterTranslations("frFR", function() return {
	aura = "Aura traîtresse",
	aura_heroic = "Plaie de traîtrise",
	aura_desc = "Préviens quand un joueur subit les effets de l'Aura/Plaie traîtresse.",
	aura_trigger = "^(%S+) (%S+) les effets (.+)%.$",
	aura_warning = "%s a %s !",
	aura_bar = "%s : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Aura/Plaie traîtresse (nécessite d'être promu ou mieux).",
} end)

L:RegisterTranslations("koKR", function() return {
	aura = "배반의 오라",
	aura_heroic = "배반의 파멸",
	aura_desc = "배반의 오라에 걸린 사람을 알립니다.",
	aura_trigger = "^([^|;%s]*)(%s+)(.*)에 걸렸습니다%.$",
	aura_warning = "%s : %s!",
	aura_bar = "%s: %s",

	icon = "전술 표시",
	icon_desc = "배반의 오라/파멸에 걸린 사람에게 전술 표시를 지정합니다. (승급자 이상 권한 요구)",
} end)

L:RegisterTranslations("zhCN", function() return {
	aura = "背叛光环",
	aura_heroic = "背叛者之祸",
	aura_desc = "当中了背叛光环发出警报",
	aura_trigger = "^([^%s]+)受([^%s]+)了(.+)效果的影响。$",
	aura_warning = "%s 中了 %s!",
	aura_bar = "%s: %s",

	icon = "团队标记",
	icon_desc = "当中了背叛光环，用团队标记标上 (需要团长或助理权限)",
} end)

L:RegisterTranslations("zhTW", function() return {
	aura = "奸詐光環",
	aura_heroic = "背叛之禍",
	aura_desc = "當有人中了奸詐光環時發出警報",
	aura_trigger = "^(.+)受(到[了]*)(.*)效果的影響。$",
	aura_warning = "%s 中了 %s!",
	aura_bar = "%s: %s",

	icon = "團隊標記",
	icon_desc = "在中了奸詐光環的隊友頭上標記（需要助理或領隊權限）",
} end)

L:RegisterTranslations("deDE", function() return {
   aura = "Verr\195\164terische Aura",
   aura_heroic = "Bann des Verrats",
   aura_desc = "Ank\195\188ndigung wer die Verr\195\164terische Aura hat",
   aura_trigger = "^(%S+) (%S+) von (.+) betroffen%.$",
   aura_warning = "%s hat %s!",
   aura_bar = "%s: %s",

   icon = "Raid Symbol",
   icon_desc = "Setzt ein Raidsymbol auf die betroffene Person der Aura (Ben\195\182tigt h\195\182heren Status)",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.partyContent = true
mod.otherMenu = "Hellfire Citadel"
mod.zonename = BZ["Hellfire Ramparts"]
mod.enabletrigger = boss
mod.toggleoptions = {"aura", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Event(msg)
	if not self.db.profile.aura then return end
	local Aplayer, Atype, Aspell = select(3, msg:find(L["aura_trigger"]))
	if Aspell ~= L["aura"] and Aspell ~= L["aura_heroic"] then return end
	if Aplayer and Atype then
		if Aplayer == L2["you"] and Atype == L2["are"] then
			Aplayer = UnitName("player")
		end
		self:Message(L["aura_warning"]:format(Aplayer, Aspell), "Urgent")
		self:Bar(L["aura_bar"]:format(Aplayer, Aspell), 15, "Spell_Shadow_DeadofNight", "Red")
		if self.db.profile.icon then
			self:Icon(Aplayer)
		end
	end
end

