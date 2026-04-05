repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--------------------------------------------------
-- UI BASE (QUANTUM STYLE)
--------------------------------------------------

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PumaaHubV3.3"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 820, 0, 460)
main.Position = UDim2.new(0.2, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(12,12,18)

--------------------------------------------------
-- TOP BAR
--------------------------------------------------

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(18,18,28)

local title = Instance.new("TextLabel", top)
title.Text = "🐆 Pumaa Hub v3.3 (Quantum)"
title.Size = UDim2.new(0,300,1,0)
title.TextColor3 = Color3.fromRGB(170,120,255)
title.BackgroundTransparency = 1

--------------------------------------------------
-- TAB SYSTEM
--------------------------------------------------

local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1,0,0,35)
tabBar.Position = UDim2.new(0,0,0,40)
tabBar.BackgroundColor3 = Color3.fromRGB(22,22,34)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,0,1,-75)
content.Position = UDim2.new(0,0,0,75)
content.BackgroundTransparency = 1

local tabs = {}

local function createTab(name, pos)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0,120,1,0)
    btn.Position = UDim2.new(0,pos,0,0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30,30,45)
    btn.TextColor3 = Color3.fromRGB(200,200,255)

    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1,0,1,0)
    frame.Visible = false
    frame.BackgroundTransparency = 1

    btn.MouseButton1Click:Connect(function()
        for _,v in pairs(tabs) do v.Visible = false end
        frame.Visible = true
    end)

    tabs[name] = frame
    return frame
end

--------------------------------------------------
-- CREATE TABS
--------------------------------------------------

local homeTab = createTab("Home",0)
local playerTab = createTab("Player",120)
local espTab = createTab("ESP",240)
local scriptsTab = createTab("Scripts",360)

homeTab.Visible = true

--------------------------------------------------
-- BUTTON CREATOR
--------------------------------------------------

local function createButton(parent,text,y,callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0,240,0,40)
    btn.Position = UDim2.new(0,20,0,y)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,40,60)
    btn.TextColor3 = Color3.new(1,1,1)

    btn.MouseButton1Click:Connect(callback)
end

--------------------------------------------------
-- PLAYER TAB (FROM RANDOM HUB STYLE)
--------------------------------------------------

createButton(playerTab,"Infinite Yield",30,function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

createButton(playerTab,"Fly",80,function()
    loadstring(game:HttpGet("https://pastebin.com/raw/7nKk9b7E"))()
end)

--------------------------------------------------
-- ESP SYSTEM (FIXED)
--------------------------------------------------

local ESP = {}
local espEnabled = false

local function addESP(plr)
    if plr == player then return end

    local line = Drawing.new("Line")
    line.Color = Color3.fromRGB(170,120,255)
    line.Thickness = 2
    line.Visible = false

    ESP[plr] = line
end

local function removeESP(plr)
    if ESP[plr] then
        ESP[plr]:Remove()
        ESP[plr] = nil
    end
end

for _,p in pairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for plr,line in pairs(ESP) do
        if not espEnabled then line.Visible = false continue end

        if not plr.Parent then
            removeESP(plr)
            continue
        end

        local char = plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if root then
            local pos,vis = camera:WorldToViewportPoint(root.Position)
            if vis then
                line.Visible = true
                line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                line.To = Vector2.new(pos.X,pos.Y)
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end)

createButton(espTab,"Toggle Player ESP",30,function()
    espEnabled = not espEnabled
end)

--------------------------------------------------
-- SCRIPT HUB TAB (MAIN PART YOU WANTED)
--------------------------------------------------

createButton(scriptsTab,"Load Random Hub v1",30,function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/000kanyewest000/Roblox-Scripts/main/random-hub-v1.lua"))()
end)

createButton(scriptsTab,"Dex Explorer",80,function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua"))()
end)

--------------------------------------------------
-- TOGGLE UI
--------------------------------------------------

UIS.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)
