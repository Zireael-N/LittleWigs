------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Ahune"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local standing = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Ahune",
	
	stand = "Emerge",
	stand_desc = "Announce and show a bar when Ahune emerges",
	stand_message = "Ahune Emerged",
	stand_soon = "Emerge Soon",

	submerge = "Submerge",
	submerge_desc = "Announce and show a bar when Ahune submerges",
	submerge_message = "Ahune Submerged",
	sumberge_soon = "Submerge Soon",
} end )

L:RegisterTranslations("zhTW", function() return {
	
	emerge = "浮現",
	emerge_desc = "當艾胡恩浮現時顯示計時條並通報",
	emerge_message = "艾胡恩 已浮現!",
	emerge_soon = "即將浮現!",

	submerge = "隱沒",
	submerge_desc = "當艾胡恩隱沒時顯示計時條並通報",
	submerge_message = "艾胡恩 已隱沒!",
	sumberge_soon = "即將隱沒!",
} end )

L:RegisterTranslations("koKR", function() return {
	stand = "",
	stand_desc = "ȭ ƿ  ٿ ˸Դϴ.",
	stand_message = " ",
	stand_soon = "   ",

	submerge = "ȭ",
	submerge_desc = " ȭ  ٿ ˸Դϴ.",
	submerge_message = " ȭ -  ",
	sumberge_soon = "  ȭ!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.partyContent = true
mod.otherMenu = "Coilfang Reservoir"
mod.zonename = BZ["The Slave Pens"]
mod.enabletrigger = boss
mod.guid = 25740
mod.toggleoptions = {"stand", "submerge", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	standing = false
	
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Submerge", 37751)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Stand", 37752)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Submerge()
	if self.db.profile.submerge then
		self:IfMessage(L["submerge_message"], "Attention")
		self:Bar(L["submerge_message"], 39)
		self:DelayedMessage(31, L["emerge_soon"], "Attention")
		standing = false
	end
end

function mod:Stand()
	if self.db.profile.stand and not standing then
		self:IfMessage(L["stand_message"], "Attention")
		self:Bar(L["stand_message"], 94) 
		self:DelayedMessage(86, L["submerge_soon"], "Attention")
		standing = true
	end
end