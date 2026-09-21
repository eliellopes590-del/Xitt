--// Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// Config
local Config = {
    AimbotEnabled = false,
    AimbotFOV = 150,
    AimbotSmoothness = 0.25,
    WallCheck = true,             -- 🔥 só mira se tiver linha de visão
    ShowFOV = true,
    ESPName = false,
    ESPBody = false,
    ESPColor = Color3.fromRGB(255, 60, 60),
}

local Minimized = false

------------------------------------------------------------
-- GUI
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LuaPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 420, 0, 250)
Main.Position = UDim2.new(0.5, -210, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(70, 70, 90)
Stroke.Thickness = 1

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Lua Panel"
TitleLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 20)
MinBtn.Position = UDim2.new(1, -60, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 20)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 55, 55)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -16, 1, -38)
Scroll.Position = UDim2.new(0, 8, 0, 34)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(90, 150, 250)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout", Scroll)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 5)

local Padding = Instance.new("UIPadding", Scroll)
Padding.PaddingTop = UDim.new(0, 4)
Padding.PaddingBottom = UDim.new(0, 6)

------------------------------------------------------------
-- Helpers UI
------------------------------------------------------------
local function label(text)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -8, 0, 18)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.fromRGB(140, 140, 160)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 11
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = Scroll
    return L
end

local function toggle(text, default, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -8, 0, 28)
    Btn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.BorderSizePixel = 0
    Btn.Parent = Scroll
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

    local Txt = Instance.new("TextLabel")
    Txt.Size = UDim2.new(1, -60, 1, 0)
    Txt.Position = UDim2.new(0, 10, 0, 0)
    Txt.BackgroundTransparency = 1
    Txt.Text = text
    Txt.TextColor3 = Color3.fromRGB(220, 220, 235)
    Txt.TextXAlignment = Enum.TextXAlignment.Left
    Txt.Font = Enum.Font.Gotham
    Txt.TextSize = 12
    Txt.Parent = Btn

    local Ind = Instance.new("Frame")
    Ind.Size = UDim2.new(0, 34, 0, 16)
    Ind.Position = UDim2.new(1, -44, 0.5, -8)
    Ind.BackgroundColor3 = default and Color3.fromRGB(80, 180, 100) or Color3.fromRGB(60, 60, 75)
    Ind.BorderSizePixel = 0
    Ind.Parent = Btn
    Instance.new("UICorner", Ind).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = Ind
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local state = default
    local function set(v)
        state = v
        Ind.BackgroundColor3 = state and Color3.fromRGB(80, 180, 100) or Color3.fromRGB(60, 60, 75)
        Knob.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        if callback then callback(state) end
    end

    Btn.MouseButton1Click:Connect(function() set(not state) end)
    return set
end

local function slider(text, min, max, default, callback)
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1, -8, 0, 44)
    Holder.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    Holder.BorderSizePixel = 0
    Holder.Parent = Scroll
    Instance.new("UICorner", Holder).CornerRadius = UDim.new(0, 5)

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -20, 0, 18)
    L.Position = UDim2.new(0, 10, 0, 3)
    L.BackgroundTransparency = 1
    L.Text = text .. ": " .. default
    L.TextColor3 = Color3.fromRGB(220, 220, 235)
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Font = Enum.Font.Gotham
    L.TextSize = 11
    L.Parent = Holder

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -20, 0, 6)
    Bar.Position = UDim2.new(0, 10, 0, 28)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    Bar.BorderSizePixel = 0
    Bar.Parent = Holder
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(90, 150, 250)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * rel)
        Fill.Size = UDim2.new(rel, 0, 1, 0)
        L.Text = text .. ": " .. val
        callback(val)
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

------------------------------------------------------------
-- Controles
------------------------------------------------------------
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -8, 0, 24)
StatusLabel.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
StatusLabel.Text = "Aimbot: DESLIGADO"
StatusLabel.TextColor3 = Color3.fromRGB(200, 80, 80)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 11
StatusLabel.BorderSizePixel = 0
StatusLabel.Parent = Scroll
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 5)

label("AIMBOT")
toggle("Aimbot (Auto)", false, function(v)
    Config.AimbotEnabled = v
    StatusLabel.Text = v and "Aimbot: LIGADO" or "Aimbot: DESLIGADO"
    StatusLabel.TextColor3 = v and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(200, 80, 80)
end)
slider("FOV", 20, 500, 150, function(v) Config.AimbotFOV = v end)
slider("Smoothness %", 1, 100, 25, function(v) Config.AimbotSmoothness = v / 100 end)
toggle("Wall Check (não mira atrás de parede)", true, function(v) Config.WallCheck = v end)
toggle("Mostrar Círculo FOV", true, function(v) Config.ShowFOV = v end)

label("ESP")
toggle("ESP Nome", false, function(v) Config.ESPName = v end)
toggle("ESP Corpo", false, function(v) Config.ESPBody = v end)

------------------------------------------------------------
-- Drag
------------------------------------------------------------
do
    local drag, start, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true; start = input.Position; startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - start
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
end

MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    Scroll.Visible = not Minimized
    Main.Size = Minimized and UDim2.new(0, 420, 0, 30) or UDim2.new(0, 420, 0, 250)
    MinBtn.Text = Minimized and "+" or "—"
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

------------------------------------------------------------
-- FOV Circle
------------------------------------------------------------
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.NumSides = 60
FOVCircle.Filled = false
FOVCircle.Transparency = 0.6
FOVCircle.Visible = false

------------------------------------------------------------
-- WALL CHECK (Raycast)
------------------------------------------------------------
-- Lista de objetos que NÃO bloqueiam a visão
local ignoreList = {}
local function refreshIgnore()
    ignoreList = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            table.insert(ignoreList, plr.Character)
        end
    end
    local char = LocalPlayer.Character
    if char then table.insert(ignoreList, char) end
end
refreshIgnore()

-- Parâmetros do raycast
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

-- Atualiza a ignore list quando alguém entra/sai
Players.PlayerAdded:Connect(function() task.wait(1); refreshIgnore() end)
Players.PlayerRemoving:Connect(refreshIgnore)
LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5); refreshIgnore() end)

-- Função principal: verifica se há parede entre câmera e alvo
local function hasLineOfSight(targetPart)
    if not Config.WallCheck then return true end -- se desligado, sempre mira

    refreshIgnore()
    rayParams.FilterDescendantsInstances = ignoreList

    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)

    local result = Workspace:Raycast(origin, direction, rayParams)

    -- Se não bateu em nada, tem visão limpa
    if not result then return true end

    -- Se bateu no próprio alvo (raro, mas pode acontecer), ainda tem visão
    if result.Instance and result.Instance:IsDescendantOf(targetPart.Parent) then
        return true
    end

    -- Bateu em outra coisa = parede
    return false
end

------------------------------------------------------------
-- AIMBOT
------------------------------------------------------------
local function getTarget()
    local closest, closestDist = nil, Config.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if head and hum and hum.Health > 0 then
                    local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist <= closestDist then
                            -- 🔥 WALL CHECK: só considera se tiver visão
                            if hasLineOfSight(head) then
                                closest = head
                                closestDist = dist
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    -- FOV Circle
    if Config.ShowFOV then
        FOVCircle.Visible = true
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = Config.AimbotFOV
    else
        FOVCircle.Visible = false
    end

    -- Aimbot
    if Config.AimbotEnabled then
        local target = getTarget()
        if target then
            local camPos = Camera.CFrame.Position
            local desired = CFrame.new(camPos, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(desired, Config.AimbotSmoothness)
        end
    end
end)

------------------------------------------------------------
-- ESP
------------------------------------------------------------
local espObjects = {}

local function clearESP(plr)
    if espObjects[plr] then
        for _, obj in pairs(espObjects[plr]) do
            pcall(function() obj:Remove() end)
        end
        espObjects[plr] = nil
    end
end

local function createESP(plr)
    clearESP(plr)
    local data = {}
    if Config.ESPName then
        local t = Drawing.new("Text")
        t.Size = 14; t.Center = true; t.Outline = true
        t.Color = Config.ESPColor; t.Visible = false
        data.NameTag = t
    end
    if Config.ESPBody then
        local b = Drawing.new("Square")
        b.Thickness = 1.5; b.Color = Config.ESPColor
        b.Filled = false; b.Transparency = 1; b.Visible = false
        data.Box = b
    end
    espObjects[plr] = data
end

local function rebuildAll()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then createESP(plr) end
    end
end

local last = { Config.ESPName, Config.ESPBody }
spawn(function()
    while ScreenGui.Parent do
        if last[1] ~= Config.ESPName or last[2] ~= Config.ESPBody then
            last = { Config.ESPName, Config.ESPBody }
            rebuildAll()
        end
        RunService.RenderStepped:Wait()
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then createESP(plr) end
end)
Players.PlayerRemoving:Connect(clearESP)
rebuildAll()

RunService.RenderStepped:Connect(function()
    for plr, data in pairs(espObjects) do
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if char and hrp and head and hum and hum.Health > 0 and plr ~= LocalPlayer then
            local hp, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                if data.NameTag then
                    data.NameTag.Text = plr.Name .. " [" .. math.floor(hum.Health) .. "]"
                    data.NameTag.Position = Vector2.new(hp.X, hp.Y - 25)
                    data.NameTag.Visible = true
                end
                if data.Box then
                    local rootPos = Camera:WorldToViewportPoint(hrp.Position)
                    local top = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, 1.5, 0)).Position)
                    local bot = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, -2.5, 0)).Position)
                    local height = math.abs(top.Y - bot.Y)
                    local width = height / 2
                    data.Box.Size = Vector2.new(width, height)
                    data.Box.Position = Vector2.new(rootPos.X - width / 2, rootPos.Y - height / 2)
                    data.Box.Visible = true
                end
            else
                if data.NameTag then data.NameTag.Visible = false end
                if data.Box then data.Box.Visible = false end
            end
        else
            if data.NameTag then data.NameTag.Visible = false end
            if data.Box then data.Box.Visible = false end
        end
    end
end)
