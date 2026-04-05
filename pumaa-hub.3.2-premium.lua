-- pumaa-hub.3.2 premium
-- ChatGPT Edition | Xeno Optimized | First Sea Support

repeat wait() until game:IsLoaded()

local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TeleportService=game:GetService("TeleportService")
local HttpService=game:GetService("HttpService")
local StarterGui=game:GetService("StarterGui")

local player=Players.LocalPlayer

--------------------------------------------------
-- GLOBAL SETTINGS
--------------------------------------------------

getgenv().AutoFruit=false
getgenv().FruitESP=false
getgenv().ChestESP=false
getgenv().PlayerESP=false
getgenv().BossESP=false
getgenv().AutoChestFarm=false

--------------------------------------------------
-- NOTIFIER
--------------------------------------------------

local function notify(txt)
pcall(function()
StarterGui:SetCore("SendNotification",{
Title="pumaa-hub.3.2 premium",
Text=txt,
Duration=3
})
end)
end

--------------------------------------------------
-- CHARACTER ROOT
--------------------------------------------------

local function root()
return player.Character
and player.Character:FindFirstChild("HumanoidRootPart")
end

--------------------------------------------------
-- GUI BASE
--------------------------------------------------

local gui=Instance.new("ScreenGui",game.CoreGui)
gui.Name="pumaa-hub.3.2 premium"

local main=Instance.new("Frame",gui)
main.Size=UDim2.new(0,540,0,360)
main.Position=UDim2.new(.3,0,.25,0)
main.BackgroundColor3=Color3.fromRGB(28,28,28)
main.Active=true
main.Draggable=true

--------------------------------------------------
-- SIDEBAR
--------------------------------------------------

local sidebar=Instance.new("Frame",main)
sidebar.Size=UDim2.new(0,150,1,0)
sidebar.BackgroundColor3=Color3.fromRGB(40,40,40)

local tabs={
"Fruit",
"Chest",
"ESP",
"Teleport",
"Boss",
"Server",
"Misc"
}

local pages={}

for _,t in pairs(tabs) do
local p=Instance.new("Frame",main)
p.Size=UDim2.new(1,-150,1,0)
p.Position=UDim2.new(0,150,0,0)
p.Visible=false
pages[t]=p
end

pages.Fruit.Visible=true

local y=0
for _,t in pairs(tabs) do
local b=Instance.new("TextButton",sidebar)
b.Size=UDim2.new(1,0,0,40)
b.Position=UDim2.new(0,0,0,y)
b.Text=t
b.MouseButton1Click:Connect(function()
for _,v in pairs(pages) do
v.Visible=false
end
pages[t].Visible=true
end)
y=y+40
end

--------------------------------------------------
-- MINIMIZE BUTTON
--------------------------------------------------

local minimize=Instance.new("TextButton",main)
minimize.Size=UDim2.new(0,30,0,30)
minimize.Position=UDim2.new(1,-35,0,5)
minimize.Text="-"

minimize.MouseButton1Click:Connect(function()

main.Visible=false

local open=Instance.new("TextButton",gui)
open.Size=UDim2.new(0,120,0,40)
open.Position=UDim2.new(0,20,0,200)
open.Text="Open Hub"

open.MouseButton1Click:Connect(function()
main.Visible=true
open:Destroy()
end)

end)

--------------------------------------------------
-- DISTANCE ESP FUNCTION
--------------------------------------------------

local function makeESP(obj,color)

if obj:FindFirstChild("ESP") then return end

local bill=Instance.new("BillboardGui",obj)
bill.Name="ESP"
bill.Size=UDim2.new(0,120,0,40)
bill.AlwaysOnTop=true

local label=Instance.new("TextLabel",bill)
label.Size=UDim2.new(1,0,1,0)
label.BackgroundTransparency=1
label.TextColor3=color
label.TextScaled=true

spawn(function()
while wait(.5) do
if obj and obj.Parent and root() then
local dist=(obj.Position-root().Position).Magnitude
label.Text=obj.Name.." ["..math.floor(dist).."]"
end
end
end)

end

--------------------------------------------------
-- AUTO FRUIT SYSTEM
--------------------------------------------------

local lastFruit=os.time()

local function storeFruit()
pcall(function()
ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit")
end)
end

spawn(function()
while wait(2) do

for _,v in pairs(Workspace:GetChildren()) do

if v:IsA("Tool") and string.find(v.Name,"Fruit") then

lastFruit=os.time()

if FruitESP then
makeESP(v.Handle,Color3.fromRGB(255,0,0))
end

if AutoFruit and root() then
root().CFrame=v.Handle.CFrame
wait(.4)
storeFruit()
notify("Stored "..v.Name)
end

end

end

end
end)

--------------------------------------------------
-- FRUIT TIMER PREDICTION
--------------------------------------------------

spawn(function()
while wait(10) do
local remain=(3600)-(os.time()-lastFruit)
if remain<0 then remain=0 end
notify("Next fruit ≈ "..math.floor(remain/60).." mins")
end
end)

--------------------------------------------------
-- CHEST FARM SYSTEM
--------------------------------------------------

local function nearestChest()

local best=nil
local dist=math.huge

for _,v in pairs(Workspace:GetDescendants()) do
if string.find(v.Name,"Chest") and v:IsA("BasePart") then
local d=(v.Position-root().Position).Magnitude
if d<dist then
dist=d
best=v
end
end
end

return best
end

spawn(function()
while wait(1) do
if AutoChestFarm and root() then
local chest=nearestChest()
if chest then
root().CFrame=CFrame.new(chest.Position)
end
end
end
end)

--------------------------------------------------
-- PLAYER ESP
--------------------------------------------------

spawn(function()
while wait(2) do
if PlayerESP then
for _,v in pairs(Players:GetPlayers()) do
if v~=player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
makeESP(v.Character.HumanoidRootPart,Color3.fromRGB(0,255,255))
end
end
end
end
end)

--------------------------------------------------
-- BOSS PANEL
--------------------------------------------------

local bossPanel=Instance.new("TextLabel",pages.Boss)
bossPanel.Size=UDim2.new(0,260,0,60)
bossPanel.Position=UDim2.new(0,20,0,20)
bossPanel.Text="Boss Status: scanning..."
bossPanel.TextScaled=true

spawn(function()
while wait(3) do
for _,v in pairs(Workspace:GetChildren()) do
if string.find(v.Name,"Boss") then
bossPanel.Text="Boss Spawned: "..v.Name
notify("Boss detected!")
end
end
end
end)

--------------------------------------------------
-- TELEPORTS
--------------------------------------------------

local islands={
["Starter"]=Vector3.new(1071,16,1426),
["Jungle"]=Vector3.new(-1612,36,149),
["Pirate"]=Vector3.new(-1160,5,3820),
["Desert"]=Vector3.new(1094,7,4193),
["Snow"]=Vector3.new(1111,7,-1163)
}

local yPos=20

for name,pos in pairs(islands) do

local btn=Instance.new("TextButton",pages.Teleport)
btn.Size=UDim2.new(0,200,0,40)
btn.Position=UDim2.new(0,20,0,yPos)
btn.Text=name

btn.MouseButton1Click:Connect(function()
if root() then
root().CFrame=CFrame.new(pos)
end
end)

yPos=yPos+45
end

--------------------------------------------------
-- WAYPOINT SYSTEM
--------------------------------------------------

local waypoint=nil

local save=Instance.new("TextButton",pages.Teleport)
save.Size=UDim2.new(0,200,0,40)
save.Position=UDim2.new(0,20,0,260)
save.Text="Save Waypoint"

save.MouseButton1Click:Connect(function()
if root() then
waypoint=root().Position
notify("Waypoint saved")
end
end)

local load=Instance.new("TextButton",pages.Teleport)
load.Size=UDim2.new(0,200,0,40)
load.Position=UDim2.new(0,20,0,305)
load.Text="Load Waypoint"

load.MouseButton1Click:Connect(function()
if waypoint and root() then
root().CFrame=CFrame.new(waypoint)
end
end)

--------------------------------------------------
-- SERVER BUTTONS
--------------------------------------------------

local rejoin=Instance.new("TextButton",pages.Server)
rejoin.Size=UDim2.new(0,200,0,40)
rejoin.Position=UDim2.new(0,20,0,20)
rejoin.Text="Rejoin Server"

rejoin.MouseButton1Click:Connect(function()
TeleportService:Teleport(game.PlaceId)
end)

--------------------------------------------------
-- FPS BOOST
--------------------------------------------------

local fps=Instance.new("TextButton",pages.Misc)
fps.Size=UDim2.new(0,200,0,40)
fps.Position=UDim2.new(0,20,0,70)
fps.Text="FPS Boost"

fps.MouseButton1Click:Connect(function()
for _,v in pairs(game:GetDescendants()) do
if v:IsA("BasePart") then
v.Material="Plastic"
end
end
notify("FPS Boost Enabled")
end)

--------------------------------------------------
-- KILL SCRIPT
--------------------------------------------------

local kill=Instance.new("TextButton",pages.Misc)
kill.Size=UDim2.new(0,200,0,40)
kill.Position=UDim2.new(0,20,0,20)
kill.Text="Destroy Script"

kill.MouseButton1Click:Connect(function()
gui:Destroy()
end)

notify("pumaa-hub.3.2 premium loaded ")
