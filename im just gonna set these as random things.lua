-- Blox Fruits Auto Fruit Grab + Store + Server Hop
-- Works best with Solara / Delta executors

repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- SETTINGS
local hopDelay = 20 -- seconds before server hop if no fruits
local checkInterval = 2 -- how often to check for fruits

-- FUNCTION: TELEPORT TO FRUIT
function teleportToFruit(fruit)
    if fruit and fruit:IsA("Tool") then
        player.Character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
        wait(.4)
    end
end

-- FUNCTION: STORE FRUIT
function storeFruit()
    local args = {
        [1] = "StoreFruit"
    }

    game:GetService("ReplicatedStorage")
        :WaitForChild("Remotes")
        :WaitForChild("CommF_")
        :InvokeServer(unpack(args))
end

-- FUNCTION: FIND FRUITS
function findFruit()
    for _, v in pairs(Workspace:GetChildren()) do
        if string.find(v.Name, "Fruit") then
            teleportToFruit(v)
            wait(.5)
            storeFruit()
            return true
        end
    end
    return false
end

-- FUNCTION: SERVER HOP
function serverHop()
    print("No fruits found... hopping server 🚀")

    local placeId = game.PlaceId

    local servers = game.HttpService:JSONDecode(
        game:HttpGet(
            "https://games.roblox.com/v1/games/"..
            placeId..
            "/servers/Public?sortOrder=Asc&limit=100"
        )
    )

    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(placeId, server.id)
            wait(5)
        end
    end
end

-- MAIN LOOP
while true do
    local found = false

    for i = 1, hopDelay/checkInterval do
        if findFruit() then
            found = true
        end
        wait(checkInterval)
    end

    if not found then
        serverHop()
    end
end
