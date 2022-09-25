local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
local SettingsLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Suricato006/Scripts-Made-by-me/master/Libraries/SaveSettingsLibrary.lua"))()
local InputLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Suricato006/Scripts-Made-by-me/master/Libraries/InputFunctions%20Library.lua"))()

local Player = game:GetService("Players").LocalPlayer

local FileName = "AHDPerkHub.txt"
local SettingsTable = SettingsLibrary.LoadSettings(FileName)

local PenguinHub = Material.Load({
	Title = "A Hero's Destiny",
	Style = 3,
	SizeX = 350,
	SizeY = 250,
	Theme = "Dark",
})

local AutoFarmTab = PenguinHub.New({
	Title = "AutoFarm"
})

local SpinTab = PenguinHub.New({
	Title = "AutoSpin"
})

local CharacterTab = PenguinHub.New({
	Title = "Character"
})

local MiscTab = PenguinHub.New({
	Title = "Miscellaneous"
})

local function RemoteAttack(Number, AttackPosition)
    if Player.Stats.Class.Value == "Angel" then
        Player.Stats.Class.Value = "Puri Puri"
    end
    if Player.Stats.Class.Value == "Toxin" then
        Player.Stats.Class.Value = "Broly"
    end
    local ClassString = string.gsub(Player.Stats.Class.Value, " ", "")
    local AttackArg = ClassString.."Attack"..tostring(Number)
    game:GetService("ReplicatedStorage").RemoteEvent:FireServer(AttackArg, AttackPosition)
end

Player.CharacterAdded:Connect(function()
    task.wait(2)
    RemoteAttack(6)
end)

local BossTable = {}
AutoFarmTab.Toggle({
	Text = "Auto Farm",
	Callback = function(Value)
		SettingsTable.AutoFarm = Value
        if Player.Character:FindFirstChild("Form") and (Player.Character.Form.Value == "") then
            RemoteAttack(6)
        end
        coroutine.wrap(function()
            while SettingsTable.AutoFarm do task.wait()
                for i, v in pairs(BossTable) do
                    if v and SettingsTable.AutoFarm then
                        local Npc = workspace.Spawns:FindFirstChild(i):FindFirstChild(i)
                        if Npc and Npc:FindFirstChild("Humanoid") and not (Npc.Humanoid.Health == 0) then
                            for i1, v1 in pairs(require(game:GetService("ReplicatedStorage").Modules.Quests)) do
                                if v1.Target == i then
                                    for _, Folder in pairs(Player:GetChildren()) do
                                        if Folder:IsA("Folder") and (Folder.Name == "Quest") then
                                            Folder:Destroy()
                                        end
                                    end
                                    game:GetService("ReplicatedStorage").RemoteEvent:FireServer("GetQuest", i1)
                                    Player:WaitForChild("Quest")
                                    break
                                end
                            end
                            local EHum = Npc:WaitForChild("Humanoid")
                            local EHrp = Npc:WaitForChild("HumanoidRootPart")
                            while SettingsTable.AutoFarm do task.wait()
                                local Char = Player.Character or Player.CharacterAdded:Wait()
                                local Hrp = Char:WaitForChild("HumanoidRootPart")
                                if EHum.Health == 0 then
                                    break
                                end
                                Hrp.CFrame = CFrame.new(EHrp.Position - EHrp.CFrame.LookVector * 3, EHrp.Position)
                                InputLibrary.CenterMouseClick()
                                for Number=1, 5 do
                                    RemoteAttack(Number, EHrp.Position)
                                end
                            end
                        end
                    end
                end
            end
        end)()
	end,
	Enabled = SettingsTable.AutoFarm
})

for i, v in pairs(require(game:GetService("ReplicatedStorage").Modules.Quests)) do
    if v.Amount == 1 then
        BossTable[v.Target] = false
    end
end

if SettingsTable.SavedTable then
    for i, v in pairs(BossTable) do
        if not SettingsTable.SavedTable[i] then
            SettingsTable.SavedTable[i] = false
        end
    end
else
    SettingsTable.SavedTable = BossTable
end

AutoFarmTab.DataTable({
	Text = "Chipping away",
	Callback = function(ChipSet)
        for i, v in pairs(ChipSet) do
            BossTable[i] = v
            SettingsTable.SavedTable[i] = v
        end
	end,
	Options = SettingsTable.SavedTable
})

local SpinTable = {}
local SpinToggle = nil
SpinToggle = SpinTab.Toggle({
	Text = "Auto Spin",
	Callback = function(Value)
		SettingsTable.AutoSpin = Value
        coroutine.wrap(function()
            while SettingsTable.AutoSpin do task.wait()
                game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer()
                for i, v in pairs(SpinTable) do
                    if SpinTable[Player.Stats.Class.Value] then
                        SpinToggle:SetState(false)
                        break
                    end
                end
            end
        end)()
	end,
	Enabled = SettingsTable.AutoSpin
})

SpinTab.Toggle({
	Text = "Auto Buy Spins",
	Callback = function(Value)
		SettingsTable.AutoBuySpins = Value
        coroutine.wrap(function()
            while SettingsTable.AutoBuySpins do task.wait()
                game:GetService("ReplicatedStorage").RemoteEvent:FireServer("PurchaseSpinAll")
            end
        end)()
	end,
	Enabled = SettingsTable.AutoBuySpins
})

for i, v in pairs(require(game:GetService("ReplicatedStorage").Modules.Classes).Lucky) do
    SpinTable[v.Item] = false
end

SpinTab.DataTable({
	Text = "Chipping away",
	Callback = function(ChipSet)
        for i, v in pairs(ChipSet) do
            SpinTable[i] = v
        end
	end,
	Options = SpinTable
})

local CharacterTable = {}

CharacterTab.Slider({
	Text = "Agility",
	Callback = function(Value)
		Player.Stats.Agility.Value = Value
	end,
	Min = 0,
	Max = 1000000,
	Def = 1000000
})

CharacterTab.Toggle({
    Text = "Auto Stamina",
    Callback = function(Value)
        SettingsTable.AutoStamina = Value
        coroutine.wrap(function()
            while SettingsTable.AutoStamina do
                task.wait()
		        local StaminaPoints = "UpgradeStamina"
                local Attributes = Player.Stats.Attributes.Value
                game:GetService("ReplicatedStorage").RemoteEvent:FireServer(StaminaPointsPoints, Attributes)
            end
        end)()
    end,
    Enabled = SettingsTable.AutoStamina
})

CharacterTab.Toggle({
    Text = "Auto Health",
    Callback = function(Value)
        SettingsTable.AutoHealth = Value
        coroutine.wrap(function()
            while SettingsTable.AutoHealth do
                task.wait()
                local HealthPoints = "UpgradeHealth"
                local Attributes = Player.Stats.Attributes.Value
                game:GetService("ReplicatedStorage").RemoteEvent:FireServer(HealthPoints, Attributes)
            end
        end)()
    end,
    Enabled = SettingsTable.AutoHealth
})

CharacterTab.Toggle({
    Text = "Auto Punch",
    Callback = function(Value)
        SettingsTable.AutoPunch = Value
        coroutine.wrap(function()
            while SettingsTable.AutoPunch do
                task.wait()
                game:GetService("ReplicatedStorage").RemoteEvent:FireServer("Punch", "Right")
                game:GetService("ReplicatedStorage").RemoteEvent:FireServer("Punch", "Left")
            end
        end)()
    end,
    Enabled = SettingsTable.AutoPunch
})

CharacterTab.Toggle({
    Text = "Auto Train",
    Callback = function(Value)
        SettingsTable.AutoTrain = Value
        coroutine.wrap(function()
            while SettingsTable.AutoTrain do
                task.wait()
                game:GetService("ReplicatedStorage").RemoteEvent:FireServer("Train")
            end
        end)()
    end,
    Enabled = SettingsTable.AutoTrain
})

CharacterTab.DataTable({
	Text = "Chipping away",
	Callback = function(ChipSet)
        for i, v in pairs(ChipSet) do
            CharacterTable[i] = v
        end
	end,
	Options = CharacterTable
})

CharacterTab.DataTable({
	Text = "Chipping away",
	Callback = function(ChipSet)
        for i, v in pairs(ChipSet) do
            CharacterTable[i] = v
        end
	end,
	Options = CharacterTable
})

MiscTab.Button({
	Text = "Infinite Zoom",
	Callback = function()
		Player.CameraMinZoomDistance = 0
        Player.CameraMaxZoomDistance = math.huge
	end,
})

MiscTab.Button({
	Text = "Remove Fog",
	Callback = function()
		for i,v in pairs(game:GetService("Lighting"):GetDescendants()) do
		    if v:IsA("Atmosphere") then
			    v:Destroy()
		    end
	    end
	end,
})

MiscTab.Button({
	Text = "Rejoin",
	Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
	end,
})

MiscTab.Button({
	Text = "Reload UI",
	Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
	end,
})

MiscTab.TextField({
	Text = "Enter Class",
	Callback = function(Value)
		Player.Stats.Class.Value = Value
	end,
})

game:GetService("Players").PlayerRemoving:Connect(function(PlayerRemoving)
    if PlayerRemoving == Player then
        SettingsLibrary.SaveSettings(FileName, SettingsTable)
    end
end)
