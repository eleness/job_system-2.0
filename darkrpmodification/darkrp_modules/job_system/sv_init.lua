util.AddNetworkString("Job.UnlocksUpdate")
util.AddNetworkString("Job.OpenMenu")

local playerMeta = FindMetaTable("Player")
function playerMeta:MultiversionCanAfford(amount)
	if self.CanAfford then
		return self:CanAfford(amount)
	else
		return self:canAfford(amount)
	end
end

function playerMeta:MultiversionAddMoney(amount)
	if self.AddMoney then
		return self:AddMoney(amount)
	else
		return self:addMoney(amount)
	end
end

function playerMeta:MultiversionNotify(type, text)
	if DarkRP && DarkRP.notify then
		DarkRP.notify(self, type, 4, text)
	else
		GAMEMODE:Notify(self, type, 4, text)
	end
end

local function MultivesrionQuery(q, f)
	if MySQLite then
		MySQLite.query(q, f)
	else
		DB.Query(q, f)
	end
end

hook.Add("DarkRPDBInitialized", "Job.CreateTable", function()
	MultivesrionQuery("CREATE TABLE IF NOT EXISTS darkrp_unlocks(steamid VARCHAR(25) NOT NULL PRIMARY KEY, unlocks TEXT)")
end)

concommand.Add("JonbNPCInit", function(ply, cmd, args)
	if !(ply:IsAdmin()) then LocalPlayer():PrintMessage(HUD_PRINTCONSOLE, "Only admin allowed to do this.") return end
	MultivesrionQuery("CREATE TABLE IF NOT EXISTS darkrp_unlocks(steamid VARCHAR(25) NOT NULL PRIMARY KEY, unlocks TEXT)")

	ply:PrintMessage(HUD_PRINTCONSOLE, "Congratulations! You've done everything right.")
end)

hook.Add("PlayerInitialSpawn", "Job.UnlocksLoad", function(ply)
	MultivesrionQuery("SELECT unlocks FROM darkrp_unlocks WHERE steamid = "..sql.SQLStr(ply:SteamID()).." LIMIT 1;", function(data)
		if data then
			data = data[1]

			ply.unlocks = {}
			for v in string.gmatch(data.unlocks, "%S+") do
				table.insert(ply.unlocks, v)
			end

		else
			MultivesrionQuery("INSERT INTO darkrp_unlocks VALUES("..sql.SQLStr(ply:SteamID())..", \"\")")
			ply.unlocks = {}
		end
		ply:UpdateUnlocksInfo()
	end)
end)

concommand.Add("Job.Unlock", function(ply, cmd, args)
	if !(args && args[1]) then return end

	for k, v in pairs(RPExtraTeams) do
		if v.command == args[1] then

			if table.HasValue(ply.unlocks, v.command) then return end

			if !ply:MultiversionCanAfford(v.unlockCost) then ply:MultiversionNotify(NOTIFY_ERROR, "Not enough money!") return end

			if v.requireUnlock && !table.HasValue(ply.unlocks, RPExtraTeams[v.requireUnlock].command) then return end
			ply:MultiversionAddMoney(-v.unlockCost)
			ply:UnlockJob(args[1])

			ply:MultiversionNotify(NOTIFY_GENERIC, v.name.." unlocked!")
			break
		end
	end
end)

local playerMeta = FindMetaTable("Player")

function playerMeta:UpdateUnlocksInfo()
	net.Start("Job.UnlocksUpdate")
		net.WriteTable(self.unlocks)
	net.Send(self)
end

function playerMeta:UnlockJob(name)
	table.insert(self.unlocks, name)
	MultivesrionQuery("UPDATE darkrp_unlocks SET unlocks = "..sql.SQLStr(table.concat(self.unlocks, " ")).." WHERE steamid = "..sql.SQLStr(self:SteamID())..";")

	self:UpdateUnlocksInfo()
end

function playerMeta:NearJobNPC(type)
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 128)) do
		if v.JobNPC && v:GetJobName() == type then
			return true
		end
	end
	return false
end

hook.Add("InitPostEntity", "Job.SpawnNPC", function()
	timer.Simple(1, function()
		for type, val in pairs(Job.NPC) do
			for _, v in pairs(val.pos) do
				local npc = ents.Create("job_npc")
				npc:Spawn()
				npc:SetPos(v.pos)
				npc:SetAngles(v.angle)
				npc:SetJobName(type)
				npc:SetModel(table.Random(val.model))
			end
		end
	end)
end)