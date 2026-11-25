--[[ 
    RIDE STORM - GOD NITRO V500
    Protection: Infinite ForceField and total anti-death.
    Speed: starts at 100k -> ramps up to 500k (progressive acceleration).
    System: reinforced Anti-Ragdoll and Auto-Sit to prevent money pause.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- --- ANTI-AFK ---
LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- --- CLEANUP ---
if CoreGui:FindFirstChild("GodNitroV500") then CoreGui.GodNitroV500:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "GodNitroV500"

-- --- STATE ---
local diabloActive = false
local currentSpeed = 0
local maxSpeed = 500000 -- the 500k limit
local lockedCFrame = nil

-- --- PHYSICS MOTOR ---
local bv = Instance.new("BodyVelocity")
local bg = Instance.new("BodyGyro")
bg.D = 20000 
bg.P = 2000000
bv.MaxForce = Vector3.new(1e12, 1e12, 1e12) -- force raised for 500k
bg.MaxTorque = Vector3.new(1e12, 1e12, 1e12)

-- --- IMMORTALITY FUNCTION ---
local function applyGodMode()
    local char = LocalPlayer.Character
    if char then
        if not char:FindFirstChildOfClass("ForceField") then
            Instance.new("ForceField", char).Visible = true
        end
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            if hum.Health < 100 then hum.Health = 100 end
        end
    end
end

-- --- SEAT WELD (PREVENTS FALLING OFF) ---
local function instantWeld()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = true
        char.Humanoid.Sit = true
        local hrp = char:FindFirstChild("HumanoidRootPart")
        -- find the seat to make sure money counts
        local seat = char.Humanoid.SeatPart or char:FindFirstChild("DriveSeat", true)
        if hrp and seat then
            hrp.CFrame = seat.CFrame * CFrame.new(0, 0.6, 0)
        end
    end
end

-- --- GOD NITRO V500 BUTTON ---
local NitroBtn = Instance.new("TextButton", ScreenGui)
NitroBtn.Size = UDim2.new(0, 150, 0, 50)
NitroBtn.Position = UDim2.new(0.8, 0, 0.15, 0)
NitroBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- devil red
NitroBtn.Text = "ACTIVATE 500K"
NitroBtn.Font = Enum.Font.GothamBold
NitroBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", NitroBtn)

NitroBtn.MouseButton1Click:Connect(function()
    diabloActive = not diabloActive
    local char = LocalPlayer.Character
    
    if diabloActive then
        NitroBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        NitroBtn.Text = "500K ACTIVE 🔥"
        lockedCFrame = char.HumanoidRootPart.CFrame
        bv.Parent = char.HumanoidRootPart
        bg.Parent = char.HumanoidRootPart
        currentSpeed = 100000 -- starts at 100k
        
        task.spawn(function()
            while diabloActive do
                -- ACCELERATE TOWARD 500K
                if currentSpeed < maxSpeed then 
                    currentSpeed = currentSpeed + 5000 
                end
                applyGodMode()
                instantWeld()
                task.wait(0.1)
            end
        end)
    else
        currentSpeed = 0
        NitroBtn.Text = "ACTIVATE 500K"
        NitroBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        if char:FindFirstChild("Humanoid") then 
            char.Humanoid.PlatformStand = false 
            char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            if char:FindFirstChildOfClass("ForceField") then char:FindFirstChildOfClass("ForceField"):Destroy() end
        end
    end
end)

-- --- RENDER LOOP ---
RunService.Stepped:Connect(function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp and diabloActive then
        bg.CFrame = lockedCFrame
        bv.Velocity = lockedCFrame.LookVector * currentSpeed
        applyGodMode()
        instantWeld()
    end
end)