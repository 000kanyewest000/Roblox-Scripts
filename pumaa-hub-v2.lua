repeat task.wait() until game:IsLoaded()

--------------------------------------------------
-- SERVICES
--------------------------------------------------

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

--------------------------------------------------
-- SETTINGS STORAGE
--------------------------------------------------

local Settings = {
Speed = 16,
Jump = 50,
Theme = "Dark"
}

--------------------------------------------------
-- THEMES
--------------------------------------------------

local Themes = {

Dark = {
Main = Color3.fromRGB(20,20,20),
Side = Color3.fromRGB(30,30,30),
Button = Color3.fromRGB(50,50,50)
},

Purple = {
Main = Color3.fromRGB(40,20,60),
Side = Color3.fromRGB(60,30,90),
Button = Color3.fromRGB(90,50,120)
},

Neon = {
Main = Color3.fromRGB(10,10,10),
Side = Color3.fromRGB(0,255,170),
Button = Color3.fromRGB(0,200,255)
}

}

--------------------------------------------------
-- GUI BASE
--------------------------------------------------

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PumaaHubV3"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,700,0,450)
main.Position = UDim2.new(.2,0,.2,0)
main.Active = true
main.Draggable = true

--------------------------------------------------
-- APPLY THEME FUNCTION
--------------------------------------------------

local sidebar
local content

local function applyTheme(name)

local theme = Themes[name]

main.BackgroundColor3 = theme.Main
sidebar.BackgroundColor3 = theme.Side

for _,v in pairs(sidebar:GetChildren()) do
if v:IsA("TextButton") then
v.BackgroundColor3 = theme.Button
end
end

Settings.Theme = name

end

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "🐆 Pumaa Hub v3 Framework"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)

--------------------------------------------------
-- SIDEBAR
--------------------------------------------------

sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0,160,1,-40)
sidebar.Position = UDim2.new(0,0,0,40)

--------------------------------------------------
-- CONTENT
--------------------------------------------------

content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-160,1,-40)
content.Position = UDim2.new(0,160,0,40)
content.BackgroundTransparency = 1

--------------------------------------------------
-- TAB SYSTEM
--------------------------------------------------

local tabs = {}

local function createTab(name)

local button = Instance.new("TextButton", sidebar)
button.Size = UDim2.new(1,0,0,45)
button.Text = name
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.TextColor3 = Color3.new(1,1,1)

local frame = Instance.new("Frame", content)
frame.Size = UDim2.new(1,0,1,0)
frame.Visible = false
frame.BackgroundTransparency = 1

tabs[name] = frame

button.MouseButton1Click:Connect(function()

for _,tab in pairs(tabs) do
tab.Visible = false
end

frame.Visible = true

TweenService:Create(frame,
TweenInfo.new(.25),
{BackgroundTransparency = 0}
):Play()

end)

return frame

end

--------------------------------------------------
-- CREATE TABS
--------------------------------------------------

local homeTab = createTab("Home")
local playerTab = createTab("Player")
local visualTab = createTab("Visual")
local teleportTab = createTab("Teleport")
local serversTab = createTab("Servers")
local settingsTab = createTab("Settings")
local themesTab = createTab("Themes")
local creditsTab = createTab("Credits")

homeTab.Visible = true

--------------------------------------------------
-- NOTIFICATION API
--------------------------------------------------

local function notify(msg)

game.StarterGui:SetCore("SendNotification",{
Title="Pumaa Hub",
Text=msg,
Duration=3
})

end

--------------------------------------------------
-- TOGGLE BUILDER
--------------------------------------------------

local function createToggle(parent,text,y,callback)

local state=false

local btn=Instance.new("TextButton",parent)
btn.Size=UDim2.new(0,240,0,40)
btn.Position=UDim2.new(0,20,0,y)
btn.Text=text.." OFF"

btn.MouseButton1Click:Connect(function()

state=not state
btn.Text=text.." "..(state and "ON" or "OFF")

callback(state)

end)

end

--------------------------------------------------
-- SLIDER BUILDER
--------------------------------------------------

local function createSlider(parent,label,y,min,max,default,callback)

local slider=Instance.new("TextLabel",parent)
slider.Size=UDim2.new(0,240,0,40)
slider.Position=UDim2.new(0,20,0,y)
slider.Text=label..": "..default

local value=default

slider.InputBegan:Connect(function()

value=value+5
if value>max then value=min end

slider.Text=label..": "..value
callback(value)

end)

end

--------------------------------------------------
-- DROPDOWN BUILDER
--------------------------------------------------

local function createDropdown(parent,label,y,list,callback)

local index=1

local btn=Instance.new("TextButton",parent)
btn.Size=UDim2.new(0,240,0,40)
btn.Position=UDim2.new(0,20,0,y)
btn.Text=label..": "..list[index]

btn.MouseButton1Click:Connect(function()

index=index+1
if index>#list then index=1 end

btn.Text=label..": "..list[index]
callback(list[index])

end)

end

--------------------------------------------------
-- PLAYER TAB MODULES
--------------------------------------------------

createSlider(playerTab,"WalkSpeed",30,16,120,16,function(val)

Settings.Speed=val

if player.Character then
player.Character.Humanoid.WalkSpeed=val
end

end)

createSlider(playerTab,"JumpPower",90,50,200,50,function(val)

Settings.Jump=val

if player.Character then
player.Character.Humanoid.JumpPower=val
end

end)

--------------------------------------------------
-- VISUAL TAB MODULES
--------------------------------------------------

createToggle(visualTab,"UI Blur Effect",30,function(state)

notify("Blur "..(state and "Enabled" or "Disabled"))

end)

--------------------------------------------------
-- TELEPORT TAB MODULES (FRAMEWORK PLACEHOLDER)
--------------------------------------------------

createDropdown(
teleportTab,
"Island",
30,
{"Starter","Jungle","Desert","Snow"},
function(choice)

notify("Selected "..choice)

end)

--------------------------------------------------
-- SERVERS TAB MODULES
--------------------------------------------------

createToggle(serversTab,"Auto Rejoin",30,function(state)

notify("Auto Rejoin "..(state and "Enabled" or "Disabled"))

end)

--------------------------------------------------
-- SETTINGS TAB MODULES
--------------------------------------------------

createToggle(settingsTab,"Notifications",30,function(state)

notify("Notifications toggled")

end)

--------------------------------------------------
-- THEMES TAB MODULES
--------------------------------------------------

createDropdown(
themesTab,
"Theme",
30,
{"Dark","Purple","Neon"},
function(theme)

applyTheme(theme)

end)

--------------------------------------------------
-- CREDITS TAB
--------------------------------------------------

local credits=Instance.new("TextLabel",creditsTab)

credits.Size=UDim2.new(1,0,0,200)
credits.Position=UDim2.new(0,0,0,40)
credits.TextScaled=true
credits.BackgroundTransparency=1
credits.TextColor3=Color3.new(1,1,1)

credits.Text=
"Pumaa Hub v3 Framework\n\nCreated by You\nFramework assistance: ChatGPT\nUI System: Modular Sidebar Engine\nVersion: 3.0"

--------------------------------------------------
-- APPLY DEFAULT THEME
--------------------------------------------------

applyTheme(Settings.Theme)

--------------------------------------------------
-- TOGGLE HUB KEY
--------------------------------------------------

UIS.InputBegan:Connect(function(input)

if input.KeyCode==Enum.KeyCode.RightShift then
main.Visible=not main.Visible
end

end)

notify("Pumaa Hub v3 Loaded")
