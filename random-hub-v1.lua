repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--------------------------------------------------
-- UI BASE (QUANTUM STYLE)
--------------------------------------------------

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PumaaQuantum"

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
title.Text = "Quantum Pumaa Hub"
title.TextColor3 = Color3.fromRGB(170,120,255)
title.Size = UDim2.new(0,250,1,0)
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
    btn.Size = UDim2.new(0,110,1,0)
    btn.Position = UDim2.new(0,pos,0,0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(28,28,40)
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

local homeTab = createTab("Home",0)
local playerTab = createTab("Player",110)
local espTab = createTab("ESP",220)
local fruitTab = createTab("Fruit",330)

homeTab.Visible = true

--------------------------------------------------
-- TOGGLE (CHECKBOX STYLE)
--------------------------------------------------

local function createToggle(parent,text,y,callback)
    local state = false

    local box = Instance.new("TextButton", parent)
    box.Size = UDim2.new(0,220,0,40)
    box.Position = UDim2.new(0,20,0,y)
    box.Text = "☐ "..text
    box.BackgroundColor3 = Color3.fromRGB(30,30,45)
    box.TextColor3 = Color3.new(1,1,1)

    box.MouseButton1Click:Connect(function()
        state = not state
        box.Text = (state and "☑ " or "☐ ")..text
        callback(state)
    end)
end

--------------------------------------------------
-- ESP SYSTEM
--------------------------------------------------

local ESP = {}
local espEnabled = false
local boxESP = false
local nameESP = false

local function createESP(plr)
    if plr == player then return end

    ESP[plr] = {
        line = Drawing.new("Line"),
        box = Drawing.new("Square"),
        text = Drawing.new("Text")
    }

    local e = ESP[plr]

    e.line.Thickness = 2
    e.line.Color = Color3.fromRGB(170,120,255)

    e.box.Thickness = 2
    e.box.Color = Color3.fromRGB(170,120,255)
    e.box.Filled = false

    e.text.Size = 13
    e.text.Color = Color3.new(1,1,1)
    e.text.Center = true

    plr.CharacterRemoving:Connect(function()
        for _,v in pairs(e) do v.Visible = false end
    end)
end

local function removeESP(plr)
    if ESP[plr] then
        for _,v in pairs(ESP[plr]) do
            v:Remove()
        end
        ESP[plr] = nil
    end
end

for _,p in pairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for plr,esp in pairs(ESP) do

        if not espEnabled then
            for _,v in pairs(esp) do v.Visible = false end
            continue
        end

        local char = plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if not root then
            for _,v in pairs(esp) do v.Visible = false end
            continue
        end

        local pos, vis = camera:WorldToViewportPoint(root.Position)

        if vis then
            -- TRACER
            esp.line.Visible = true
            esp.line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
            esp.line.To = Vector2.new(pos.X, pos.Y)

            -- BOX
            if boxESP then
                esp.box.Visible = true
                esp.box.Size = Vector2.new(40,60)
                esp.box.Position = Vector2.new(pos.X-20, pos.Y-30)
            else
                esp.box.Visible = false
            end

            -- NAME
            if nameESP then
                esp.text.Visible = true
                esp.text.Position = Vector2.new(pos.X, pos.Y-40)
                esp.text.Text = plr.Name
            else
                esp.text.Visible = false
            end

        else
            for _,v in pairs(esp) do v.Visible = false end
        end
    end
end)

--------------------------------------------------
-- ESP TOGGLES
--------------------------------------------------

createToggle(espTab,"Player Tracers",30,function(v) espEnabled = v end)
createToggle(espTab,"Box ESP",80,function(v) boxESP = v end)
createToggle(espTab,"Name ESP",130,function(v) nameESP = v end)

--------------------------------------------------
-- FRUIT ESP (BASIC)
--------------------------------------------------

local fruitESP = {}

local function scanFruits()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            if not fruitESP[v] then
                local txt = Drawing.new("Text")
                txt.Size = 13
                txt.Color = Color3.fromRGB(255,200,0)
                txt.Center = true
                fruitESP[v] = txt
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    scanFruits()

    for obj,txt in pairs(fruitESP) do
        if obj and obj:FindFirstChild("Handle") then
            local pos,vis = camera:WorldToViewportPoint(obj.Handle.Position)
            if vis then
                txt.Visible = true
                txt.Position = Vector2.new(pos.X,pos.Y)
                txt.Text = "Fruit"
            else
                txt.Visible = false
            end
        else
            txt:Remove()
            fruitESP[obj] = nil
        end
    end
end)

--------------------------------------------------
-- TOGGLE UI
--------------------------------------------------

UIS.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)
