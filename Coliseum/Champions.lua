--------------------------------------------------------------------------------
-- Module Declaration
--
local mod, CL = BigWigs:NewBoss("Faction Champions", 543, 1621)
if not mod then return end
mod.toggleOptions = {65960, 65801, 65877, 66010, 65947, {65816, "FLASH"}, 67514, 67777, 65983, 65980}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.enable_trigger = "The next battle will be against the Argent Crusade's most powerful knights! Only by defeating them will you be deemed worthy..."
	L.defeat_trigger = "A shallow and tragic victory."

	L["Shield on %s!"] = "Shield on %s!"
	L["Bladestorming!"] = "Bladestorming!"
	L["Hunter pet up!"] = "Hunter pet up!"
	L["Felhunter up!"] = "Felhunter up!"
	L["Heroism on champions!"] = "Heroism on champions!"
	L["Bloodlust on champions!"] = "Bloodlust on champions!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:RegisterEnableMob(
		-- Alliance NPCs
		34460, 34461, 34463, 34465, 34466, 34467, 34468, 34469, 34470, 34471, 34472, 34473, 34474, 34475,
		-- Horde NPCs
		34441, 34444, 34445, 34447, 34448, 34449, 34450, 34451, 34453, 34454, 34455, 34456, 34458, 34459
	)
	self:RegisterEnableYell(L["enable_trigger"])
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Blind", 65960)
	self:Log("SPELL_AURA_APPLIED", "Polymorph", 65801)
	self:Log("SPELL_AURA_APPLIED", "Wyvern", 65877)
	self:Log("SPELL_AURA_APPLIED", "DivineShield", 66010)
	self:Log("SPELL_CAST_SUCCESS", "Bladestorm", 65947)
	self:Log("SPELL_SUMMON", "Felhunter", 67514)
	self:Log("SPELL_SUMMON", "Cat", 67777)
	self:Log("SPELL_CAST_SUCCESS", "Heroism", 65983)
	self:Log("SPELL_CAST_SUCCESS", "Bloodlust", 65980)
	self:Log("SPELL_AURA_APPLIED", "Hellfire", 65816)
	self:Log("SPELL_AURA_REMOVED", "HellfireStopped", 65816)
	self:Log("SPELL_DAMAGE", "HellfireOnYou", 65817)
	self:Log("SPELL_MISSED", "HellfireOnYou", 65817)

	self:Yell("Win", L["defeat_trigger"])
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Hellfire(args)
	self:Message(args.spellId, "Urgent")
	self:Bar(args.spellId, 15)
end

function mod:HellfireStopped(args)
	self:StopBar(args.spellId)
end

do
	local last = 0
	function mod:HellfireOnYou(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-4 > last then
				self:Message(65816, "Personal", "Alarm", CL["you"]:format(self:SpellName(65816))) -- Hellfire
				self:Flash(65816)
				last = t
			end
		end
	end
end

function mod:Wyvern(args)
	self:TargetMessage(args.spellId, args.destName, "Attention")
end

function mod:Blind(args)
	self:TargetMessage(args.spellId, args.destName, "Attention")
end

function mod:Polymorph(args)
	self:TargetMessage(args.spellId, args.destName, "Attention")
end

function mod:DivineShield(args)
	self:Message(args.spellId, "Urgent", nil, L["Shield on %s!"]:format(args.destName))
end

function mod:Bladestorm(args)
	self:Message(args.spellId, "Important", nil, L["Bladestorming!"])
end

function mod:Cat(args)
	self:Message(args.spellId, "Urgent", nil, L["Hunter pet up!"])
end

function mod:Felhunter(args)
	self:Message(args.spellId, "Urgent", nil, L["Felhunter up!"])
end

function mod:Heroism(args)
	self:Message(args.spellId, "Important", nil, L["Heroism on champions!"])
end

function mod:Bloodlust(args)
	self:Message(args.spellId, "Important", nil, L["Bloodlust on champions!"])
end

