-- Xeno Compatible | 1st Sea Fruit Grabber + Auto Store + Server Hop

repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- SETTINGS
local CHECK_DELAY = 2
local SERVER_HOP_TIME = 25

-- SAFE CHARACTER LOAD
local function getRoot()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- TELEPORT TO FRUIT
local function tpToFruit(fruit)
    local root = getRoot()
    if root and fruit:FindFirstChild("Handle") then
        root.CFrame = fruit.Handle.CFrame
        wait(0.5)
    end
end

-- STORE FRUIT
local function storeFruit()
    pcall(function()
        game:GetService("ReplicatedStorage")
        :WaitForChild("Remotes")
        :WaitForChild("CommF_")
        :InvokeServer("StoreFruit")
    end)
end

-- FIND FRUITS (1st Sea compatible)
local function findFruit()
    for _,v in pairs(Workspace:GetChildren()) do
        if v:IsA("Tool") and string.find(v.Name,"Fruit") then
            tpToFruit(v)
            wait(0.4)
            storeFruit()
            return true
        end
    end
    return false
end

-- SERVER HOP FUNCTION (Xeno safe)
local function serverHop()
    print("No fruits found... hopping server 🔄")

    local placeId = game.PlaceId
    local servers = HttpService:JSONDecode(game:HttpGet(
        "https://games.roblox.com/v1/games/" ..
        placeId ..
        "/servers/Public?sortOrder=Asc&limit=100"
    ))

    for _,server in pairs(servers.data) do
        if server.playing < server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(placeId, server.id)
            wait(4)
        end
    end
end

-- MAIN LOOP
while true do
    local foundFruit = false

    for i = 1, SERVER_HOP_TIME / CHECK_DELAY do
        if findFruit() then
            foundFruit = true
        end
        wait(CHECK_DELAY)
    end

    if not foundFruit then
        serverHop()
    end
end
