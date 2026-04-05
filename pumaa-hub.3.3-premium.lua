-- pumaa-hub.3.3 premium
-- ChatGPT Edition | Xeno Optimized | First Sea Support

repeat wait() until game:IsLoaded()

local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TeleportService=game:GetService("TeleportService")
local StarterGui=game:GetService("StarterGui")

local player=Players.LocalPlayer

------------------------------------------------
-- GLOBAL STATES
------------------------------------------------

local AutoFruit=false
local FruitESP=false
local ChestESP=false
local PlayerESP=false
local BossESP=false
local AutoChestFarm=false
local AutoLevel=false

local TeleportLock=false

------------------------------------------------
-- ROOT
------------------------------------------------

local function root()
return player.Character
and player.Character:FindFirstChild("HumanoidRootPart")
end

------------------------------------------------
-- SAFE TELEPORT (ANTI SNAPBACK)
------------------------------------------------

local function safeTeleport(cf)

TeleportLock=true

if root() then
root().CFrame=cf
end

task.wait(3)

TeleportLock=false

end

------------------------------------------------
-- NOTIFY
------------------------------------------------

local function notify(t)

pcall(function()

StarterGui:SetCore("SendNotification",{

Title="pumaa-hub.3.3 premium",
Text=t,
Duration=3

})

end)

end

------------------------------------------------
-- GUI BASE
------------------------------------------------

local gui=Instance.new("ScreenGui",game.CoreGui)

local main=Instance.new("Frame",gui)

main.Size=UDim2.new(0,560,0,380)
main.Position=UDim2.new(.3,0,.25,0)
main.BackgroundColor3=Color3.fromRGB(30,30,30)
main.Active=true
main.Draggable=true

------------------------------------------------
-- SIDEBAR
------------------------------------------------

local sidebar=Instance.new("Frame",main)

sidebar.Size=UDim2.new(0,160,1,0)
sidebar.BackgroundColor3=Color3.fromRGB(40,40,40)

local tabs={"Fruit","Chest","ESP","Teleport","Boss","Server","Misc"}

local pages={}

for _,t in pairs(tabs) do

local p=Instance.new("Frame",main)

p.Size=UDim2.new(1,-160,1,0)
p.Position=UDim2.new(0,160,0,0)
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

------------------------------------------------
-- MINIMIZE
------------------------------------------------

local minimize=Instance.new("TextButton",main)

minimize.Size=UDim2.new(0,30,0,30)
minimize.Position=UDim2.new(1,-35,0,5)
minimize.Text="-"

minimize.MouseButton1Click:Connect(function()

main.Visible=false

local reopen=Instance.new("TextButton",gui)

reopen.Size=UDim2.new(0,120,0,40)
reopen.Position=UDim2.new(0,20,0,200)
reopen.Text="Open Hub"

reopen.MouseButton1Click:Connect(function()

main.Visible=true
reopen:Destroy()

end)

end)

------------------------------------------------
-- DISTANCE ESP
------------------------------------------------

local function makeESP(part,color)

if part:FindFirstChild("ESP") then return end

local bill=Instance.new("BillboardGui",part)

bill.Size=UDim2.new(0,120,0,40)
bill.AlwaysOnTop=true

local label=Instance.new("TextLabel",bill)

label.Size=UDim2.new(1,0,1,0)
label.BackgroundTransparency=1
label.TextColor3=color
label.TextScaled=true

task.spawn(function()

while wait(.5) do

if part.Parent and root() then

local dist=(part.Position-root().Position).Magnitude

label.Text=part.Name.." ["..math.floor(dist).."]"

end

end

end)

end

------------------------------------------------
-- AUTO FRUIT
------------------------------------------------

task.spawn(function()

while wait(2) do

if AutoFruit and root() and not TeleportLock then

for _,v in pairs(Workspace:GetChildren()) do

if v:IsA("Tool") and string.find(v.Name,"Fruit") then

safeTeleport(v.Handle.CFrame)

ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit")

notify("Stored "..v.Name)

end

end

end

end

end)

------------------------------------------------
-- AUTO CHEST FARM
------------------------------------------------

task.spawn(function()

while wait(1) do

if AutoChestFarm and root() and not TeleportLock then

local closest=nil
local dist=math.huge

for _,v in pairs(Workspace:GetDescendants()) do

if string.find(v.Name,"Chest") and v:IsA("BasePart") then

local d=(v.Position-root().Position).Magnitude

if d<dist then

dist=d
closest=v

end

end

end

if closest then

safeTeleport(CFrame.new(closest.Position))

end

end

end

end)

------------------------------------------------
-- AUTO LEVEL FARM
------------------------------------------------

local QuestTable={

[1]={Quest="BanditQuest1",Mob="Bandit",QuestPos=CFrame.new(1060,16,1547),MobPos=CFrame.new(1145,17,1634)},
[15]={Quest="MonkeyQuest",Mob="Monkey",QuestPos=CFrame.new(-1598,36,153),MobPos=CFrame.new(-1448,67,11)}

}

local function getQuest()

local lvl=player.Data.Level.Value

local selected=nil

for i,v in pairs(QuestTable) do

if lvl>=i then selected=v end

end

return selected

end

task.spawn(function()

while wait(.5) do

if AutoLevel and root() and not TeleportLock then

local q=getQuest()

if q then

safeTeleport(q.QuestPos)

ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest",q.Quest,1)

for _,enemy in pairs(Workspace.Enemies:GetChildren()) do

if enemy.Name==q.Mob and enemy:FindFirstChild("HumanoidRootPart") then

safeTeleport(enemy.HumanoidRootPart.CFrame)

end

end

end

end

end

end)

------------------------------------------------
-- TELEPORTS
------------------------------------------------

local islands={

Starter=Vector3.new(1071,16,1426),
Jungle=Vector3.new(-1612,36,149),
Pirate=Vector3.new(-1160,5,3820),
Desert=Vector3.new(1094,7,4193),
Snow=Vector3.new(1111,7,-1163)

}

local yPos=20

for name,pos in pairs(islands) do

local btn=Instance.new("TextButton",pages.Teleport)

btn.Size=UDim2.new(0,200,0,40)
btn.Position=UDim2.new(0,20,0,yPos)
btn.Text=name

btn.MouseButton1Click:Connect(function()

safeTeleport(CFrame.new(pos))

end)

yPos=yPos+45

end

------------------------------------------------
-- WAYPOINT
------------------------------------------------

local waypoint=nil

local save=Instance.new("TextButton",pages.Teleport)

save.Size=UDim2.new(0,200,0,40)
save.Position=UDim2.new(0,20,0,260)
save.Text="Save Waypoint"

save.MouseButton1Click:Connect(function()

if root() then

waypoint=root().Position
notify("Waypoint Saved")

end

end)

local load=Instance.new("TextButton",pages.Teleport)

load.Size=UDim2.new(0,200,0,40)
load.Position=UDim2.new(0,20,0,305)
load.Text="Load Waypoint"

load.MouseButton1Click:Connect(function()

if waypoint and root() then

safeTeleport(CFrame.new(waypoint))

end

end)

------------------------------------------------
-- SERVER BUTTONS
------------------------------------------------

local rejoin=Instance.new("TextButton",pages.Server)

rejoin.Size=UDim2.new(0,200,0,40)
rejoin.Position=UDim2.new(0,20,0,20)
rejoin.Text="Rejoin Server"

rejoin.MouseButton1Click:Connect(function()

TeleportService:Teleport(game.PlaceId)

end)

------------------------------------------------
-- FPS BOOST
------------------------------------------------

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

------------------------------------------------
-- DESTROY SCRIPT
------------------------------------------------

local kill=Instance.new("TextButton",pages.Misc)

kill.Size=UDim2.new(0,200,0,40)
kill.Position=UDim2.new(0,20,0,20)
kill.Text="Destroy Script"

kill.MouseButton1Click:Connect(function()

gui:Destroy()

end)

notify("pumaa-hub.3.3 premium loaded ✅")
