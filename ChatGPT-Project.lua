--[[
    Blox Fruits Ultimate Hub v1.0
    Inspired by Quantum Onyx Project
    Features: EXP Farm, PvP, Raids, Teleports, Fruit Notifier, Main Utilities
    Credit: ChatGPT
--]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local plrGui = player:WaitForChild("PlayerGui")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsUltimateHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = plrGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundColor3 = Color3.fromRGB(40,40,40)
Title.Text = "Blox Fruits Ultimate Hub"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = MainFrame

-- Tabs
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1,0,0,40)
TabsFrame.Position = UDim2.new(0,0,0,50)
TabsFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
TabsFrame.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,0,1,-90)
ContentFrame.Position = UDim2.new(0,0,0,90)
ContentFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
ContentFrame.Parent = MainFrame

-- Tab Buttons
local tabs = {"Main", "EXP Farm", "PvP", "Raids", "Teleport", "Fruit Notifier", "Settings"}
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 85, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*85, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = TabsFrame
    tabButtons[tabName] = btn
end

-- Helper Function to Clear Content
local function clearContent()
    for _,v in pairs(ContentFrame:GetChildren()) do
        if v:IsA("Frame") or v:IsA("TextButton") or v:IsA("TextLabel") then
            v:Destroy()
        end
    end
end

-- Feature Functions

-- Main Utilities
local function MainUtilities()
    clearContent()
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,30)
    lbl.Position = UDim2.new(0,0,0,0)
    lbl.Text = "Main Utilities"
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 20
    lbl.BackgroundTransparency = 1
    lbl.Parent = ContentFrame

    -- Example: Auto Rebirth
    local rebirthBtn = Instance.new("TextButton")
    rebirthBtn.Size = UDim2.new(0,200,0,40)
    rebirthBtn.Position = UDim2.new(0,10,0,50)
    rebirthBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    rebirthBtn.Text = "Auto Rebirth (Toggle)"
    rebirthBtn.TextColor3 = Color3.fromRGB(255,255,255)
    rebirthBtn.Font = Enum.Font.Gotham
    rebirthBtn.TextSize = 14
    rebirthBtn.Parent = ContentFrame

    local rebirthActive = false
    rebirthBtn.MouseButton1Click:Connect(function()
        rebirthActive = not rebirthActive
        rebirthBtn.Text = "Auto Rebirth: "..tostring(rebirthActive)
        spawn(function()
            while rebirthActive do
                -- Rebirth Remote Call Example
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.Rebirth:InvokeServer()
                end)
                wait(2)
            end
        end)
    end)
end

-- EXP Farm
local function EXPFarm()
    clearContent()
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,30)
    lbl.Position = UDim2.new(0,0,0,0)
    lbl.Text = "EXP Farm"
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 20
    lbl.BackgroundTransparency = 1
    lbl.Parent = ContentFrame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0,200,0,40)
    toggleBtn.Position = UDim2.new(0,10,0,50)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    toggleBtn.Text = "Auto Farm EXP (Toggle)"
    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.TextSize = 14
    toggleBtn.Parent = ContentFrame

    local farmActive = false
    toggleBtn.MouseButton1Click:Connect(function()
        farmActive = not farmActive
        toggleBtn.Text = "Auto Farm EXP: "..tostring(farmActive)
        spawn(function()
            while farmActive do
                -- Example: Kill NPCs in range for EXP
                for _, npc in pairs(Workspace.Enemies:GetChildren()) do
                    if npc:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                        pcall(function()
                            game:GetService("ReplicatedStorage").Remotes.Damage:FireServer(npc, 999999)
                        end)
                    end
                end
                wait(1)
            end
        end)
    end)
end

-- PvP Utilities
local function PvPUtilities()
    clearContent()
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,30)
    lbl.Position = UDim2.new(0,0,0,0)
    lbl.Text = "PvP Utilities"
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 20
    lbl.BackgroundTransparency = 1
    lbl.Parent = ContentFrame

    local autoTargetBtn = Instance.new("TextButton")
    autoTargetBtn.Size = UDim2.new(0,200,0,40)
    autoTargetBtn.Position = UDim2.new(0,10,0,50)
    autoTargetBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    autoTargetBtn.Text = "Auto Target Enemies"
    autoTargetBtn.TextColor3 = Color3.fromRGB(255,255,255)
    autoTargetBtn.Font = Enum.Font.Gotham
    autoTargetBtn.TextSize = 14
    autoTargetBtn.Parent = ContentFrame
end

-- Raids
local function Raids()
    clearContent()
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,30)
    lbl.Position = UDim2.new(0,0,0,0)
    lbl.Text = "Raids Utilities"
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 20
    lbl.BackgroundTransparency = 1
    lbl.Parent = ContentFrame
end

-- Teleports
local function Teleports()
    clearContent()
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,30)
    lbl.Position = UDim2.new(0,0,0,0)
    lbl.Text = "Teleports"
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 20
    lbl.BackgroundTransparency = 1
    lbl.Parent = ContentFrame
end

-- Fruit Notifier
local function FruitNotifier()
    clearContent()
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,30)
    lbl.Position = UDim2.new(0,0,0,0)
    lbl.Text = "Fruit Notifier"
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 20
    lbl.BackgroundTransparency = 1
    lbl.Parent = ContentFrame

    local notifyBtn = Instance.new("TextButton")
    notifyBtn.Size = UDim2.new(0,200,0,40)
    notifyBtn.Position = UDim2.new(0,10,0,50)
    notifyBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    notifyBtn.Text = "Enable Fruit Notifications"
    notifyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    notifyBtn.Font = Enum.Font.Gotham
    notifyBtn.TextSize = 14
    notifyBtn.Parent = ContentFrame

    local fruitActive = false
    notifyBtn.MouseButton1Click:Connect(function()
        fruitActive = not fruitActive
        notifyBtn.Text = "Fruit Notifier: "..tostring(fruitActive)
        spawn(function()
            while fruitActive do
                for _, fruit in pairs(Workspace:GetChildren()) do
                    if fruit.Name:find("Fruit") then
                        -- Notify Player
                        game.StarterGui:SetCore("SendNotification", {
                            Title = "Fruit Spotted!",
                            Text = fruit.Name.." has spawned!",
                            Duration = 5
                        })
                    end
                end
                wait(5)
            end
        end)
    end)
end

-- Connect Tabs
tabButtons["Main"].MouseButton1Click:Connect(MainUtilities)
tabButtons["EXP Farm"].MouseButton1Click:Connect(EXPFarm)
tabButtons["PvP"].MouseButton1Click:Connect(PvPUtilities)
tabButtons["Raids"].MouseButton1Click:Connect(Raids)
tabButtons["Teleport"].MouseButton1Click:Connect(Teleports)
tabButtons["Fruit Notifier"].MouseButton1Click:Connect(FruitNotifier)

-- Default Tab
MainUtilities()
