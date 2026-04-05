-- Ultimate Fruit Hunter System (Fruit Tab Module)
-- Credit: ChatGPT

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

-- SETTINGS
local fruitTPEnabled = false
local fruitESPEnabled = false
local autoHopEnabled = false

local fruitConnection = nil
local espObjects = {}

--------------------------------------------------
-- UI BUTTON CREATOR FUNCTION
--------------------------------------------------

local function createButton(name, posY)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,240,0,40)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = name.." : OFF"
    btn.Parent = ContentFrame

    return btn

end

--------------------------------------------------
-- BUTTONS
--------------------------------------------------

local tpButton = createButton("Instant Fruit TP + Auto Store", 40)
local espButton = createButton("Fruit ESP", 90)
local hopButton = createButton("Auto Server Hop (No Fruits)", 140)

--------------------------------------------------
-- TELEPORT FUNCTION
--------------------------------------------------

local function teleportToFruit(fruit)

    if player.Character
    and player.Character:FindFirstChild("HumanoidRootPart")
    and fruit:FindFirstChild("Handle") then

        player.Character.HumanoidRootPart.CFrame =
            fruit.Handle.CFrame + Vector3.new(0,3,0)

    end

end

--------------------------------------------------
-- AUTO STORE FUNCTION
--------------------------------------------------

local function storeFruit()

    task.wait(1)

    for _, tool in pairs(player.Backpack:GetChildren()) do

        if tool:IsA("Tool")
        and string.find(tool.Name:lower(),"fruit") then

            pcall(function()

                ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "StoreFruit",
                    tool.Name
                )

            end)

        end

    end

end

--------------------------------------------------
-- FRUIT ESP FUNCTION
--------------------------------------------------

local function createESP(fruit)

    if not fruitESPEnabled then return end

    if fruit:FindFirstChild("Handle") then

        local highlight = Instance.new("Highlight")
        highlight.Parent = fruit
        highlight.FillColor = Color3.fromRGB(255,0,0)

        table.insert(espObjects, highlight)

    end

end

local function clearESP()

    for _, esp in pairs(espObjects) do
        esp:Destroy()
    end

    espObjects = {}

end

--------------------------------------------------
-- RARE FRUIT DETECTOR
--------------------------------------------------

local rareFruits = {

    ["dragon"] = true,
    ["leopard"] = true,
    ["kitsune"] = true,
    ["dough"] = true,
    ["spirit"] = true

}

local function rareAlert(name)

    for fruitName in pairs(rareFruits) do

        if string.find(name:lower(), fruitName) then

            game.StarterGui:SetCore("SendNotification", {

                Title = "RARE FRUIT FOUND ⭐",
                Text = name,
                Duration = 8

            })

        end

    end

end

--------------------------------------------------
-- SERVER HOP FUNCTION
--------------------------------------------------

local function serverHop()

    if autoHopEnabled then

        TeleportService:Teleport(game.PlaceId)

    end

end

--------------------------------------------------
-- FRUIT SPAWN DETECTOR
--------------------------------------------------

local function startFruitDetection()

fruitConnection =
Workspace.DescendantAdded:Connect(function(obj)

if not fruitTPEnabled then return end

if obj:IsA("Tool")
and obj:FindFirstChild("Handle")
and string.find(obj.Name:lower(),"fruit") then

game.StarterGui:SetCore("SendNotification",{

Title = "Fruit Spawned 🍎",
Text = obj.Name,
Duration = 5

})

rareAlert(obj.Name)

createESP(obj)

task.wait(0.4)

teleportToFruit(obj)

task.spawn(storeFruit)

end

end)

end

--------------------------------------------------
-- BUTTON LOGIC
--------------------------------------------------

tpButton.MouseButton1Click:Connect(function()

fruitTPEnabled = not fruitTPEnabled

tpButton.Text =
"Instant Fruit TP + Auto Store : "..
(fruitTPEnabled and "ON" or "OFF")

if fruitTPEnabled then
startFruitDetection()
else
if fruitConnection then
fruitConnection:Disconnect()
end
end

end)

espButton.MouseButton1Click:Connect(function()

fruitESPEnabled = not fruitESPEnabled

espButton.Text =
"Fruit ESP : "..(fruitESPEnabled and "ON" or "OFF")

if not fruitESPEnabled then
clearESP()
end

end)

hopButton.MouseButton1Click:Connect(function()

autoHopEnabled = not autoHopEnabled

hopButton.Text =
"Auto Server Hop (No Fruits) : "..
(autoHopEnabled and "ON" or "OFF")

if autoHopEnabled then

task.spawn(function()

while autoHopEnabled do

task.wait(300)

serverHop()

end

end)

end

end)
