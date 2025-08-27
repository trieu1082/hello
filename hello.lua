-- 🛠️ Fix Lag Script
task.wait(5)
pcall(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Color = Color3.fromRGB(128,128,128)
            v.Reflectance = 0
            v.CastShadow = false
        end
    end
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        if plr.Character then
            for _, obj in pairs(plr.Character:GetDescendants()) do
                if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Decal") then
                    obj:Destroy()
                end
            end
        end
    end
    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = false
    lighting.FogEnd = 9e9
    lighting.Brightness = 0
    lighting.ClockTime = 14
    lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    lighting.Ambient = Color3.fromRGB(128,128,128)
    for _, v in pairs(lighting:GetDescendants()) do
        if v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("BlurEffect") then
            v:Destroy()
        end
    end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            v:Destroy()
        end
    end
    workspace.Terrain.WaterWaveSize = 0
    workspace.Terrain.WaterWaveSpeed = 0
    workspace.Terrain.WaterReflectance = 0
    workspace.Terrain.WaterTransparency = 1
end)

-- 👑 Auto Collect Chest by Trieu
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")

-- UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TrieuUI"
local title = Instance.new("TextLabel", gui)
title.Size = UDim2.new(0.3,0,0.05,0)
title.Position = UDim2.new(0.35,0,0.05,0)
title.BackgroundColor3 = Color3.fromRGB(0,0,0)
title.TextColor3 = Color3.fromRGB(0,255,0)
title.TextScaled = true
title.Text = "Trieu - Auto Chest ✅"

-- Noclip
spawn(function()
    while task.wait() do
        local char = player.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

-- Tween từng đoạn nhỏ (mượt và tránh nước)
local function TweenToSmooth(targetPos)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    local safeHeight = 100
    local currentPos = root.Position
    local checkpoints = {}

    -- bay lên cao trước
    table.insert(checkpoints, Vector3.new(currentPos.X, safeHeight, currentPos.Z))
    -- bay ngang đến trên rương
    table.insert(checkpoints, Vector3.new(targetPos.X, safeHeight, targetPos.Z))
    -- hạ xuống gần rương
    table.insert(checkpoints, targetPos + Vector3.new(0,5,0))

    for _, point in ipairs(checkpoints) do
        local distance = (root.Position - point).Magnitude
        local speed = 300
        local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(point)})
        tween:Play()
        tween.Completed:Wait()
    end
end

-- Auto Chest
spawn(function()
    while task.wait(0.5) do
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")

        local nearest, dist = nil, math.huge
        for _, chest in pairs(CollectionService:GetTagged("_ChestTagged")) do
            if not chest:GetAttribute("IsDisabled") then
                local d = (root.Position - chest:GetPivot().Position).Magnitude
                if d < dist then
                    dist, nearest = d, chest
                end
            end
        end

        if nearest then
            TweenToSmooth(nearest:GetPivot().Position)
        end
    end
end)
