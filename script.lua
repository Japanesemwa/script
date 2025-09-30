local runservice = game:GetService('RunService')
local uis = game:GetService('UserInputService')
local rs = game:GetService('ReplicatedStorage')

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local player = nil
repeat
    task.wait()
    player = game.Players.LocalPlayer
until player ~= nil

local winEvent = rs:WaitForChild('WinUpgradeEvent')
local rebirthEvent = rs:WaitForChild('RebirthEvent')

local winTier, winLoop, winDelay = 1, false, 1
local rebirthTier, rebirthLoop, rebirthDelay = 1, false, 1

local leaderstats = player:WaitForChild('leaderstats')
local winsStat = leaderstats:WaitForChild('Wins')
local rebirthStat = leaderstats:WaitForChild('Rebirths')

local currentView = 'Wins'

local PRIMARY_BG = Color3.fromRGB(20, 20, 30)
local SECONDARY_BG = Color3.fromRGB(30, 30, 45)
local ACCENT_COLOR = Color3.fromRGB(80, 50, 200)
local OFF_COLOR = Color3.fromRGB(200, 50, 50)

local screenGui = Instance.new('ScreenGui', player.PlayerGui)
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new('Frame', screenGui)
mainFrame.Size = UDim2.new(0, 500, 0, 230)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -115)
mainFrame.BackgroundColor3 = PRIMARY_BG
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new('UICorner', mainFrame).CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new('Frame', mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = SECONDARY_BG
titleBar.Position = UDim2.new(0, 0, 0, 0)
local titleLabel = Instance.new('TextLabel', titleBar)
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = '1+ SIZE EVERY SECOND'
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.BackgroundTransparency = 1

local keybindLabel = Instance.new('TextLabel', titleBar)
keybindLabel.Size = UDim2.new(0, 100, 1, 0)
keybindLabel.Position = UDim2.new(1, -145, 0, 0)
keybindLabel.Text = '[T] Toggle Menu'
keybindLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
keybindLabel.Font = Enum.Font.Gotham
keybindLabel.TextSize = 14
keybindLabel.BackgroundTransparency = 1

local closeBtn = Instance.new('TextButton', titleBar)
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 2)
closeBtn.Text = 'X'
closeBtn.BackgroundColor3 = OFF_COLOR
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
Instance.new('UICorner', closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

local sidebar = Instance.new('Frame', mainFrame)
sidebar.Size = UDim2.new(0, 140, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = SECONDARY_BG

local sidebarList = Instance.new('UIListLayout', sidebar)
sidebarList.Padding = UDim.new(0, 5)
sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
sidebarList.FillDirection = Enum.FillDirection.Vertical
sidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local contentPanel = Instance.new('Frame', mainFrame)
contentPanel.Size = UDim2.new(1, -140, 1, -40)
contentPanel.Position = UDim2.new(0, 140, 0, 40)
contentPanel.BackgroundColor3 = PRIMARY_BG
contentPanel.ClipsDescendants = true

local contentTitle = Instance.new('TextLabel', contentPanel)
contentTitle.Size = UDim2.new(1, -20, 0, 30)
contentTitle.Position = UDim2.new(0, 10, 0, 10)
contentTitle.Text = 'Automation Settings'
contentTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextSize = 20
contentTitle.BackgroundTransparency = 1

local function createNavButton(name)
    local btn = Instance.new('TextButton', sidebar)
    btn.Size = UDim2.new(1, -20, 0, 50)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.BackgroundColor3 = SECONDARY_BG
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Instance.new('UICorner', btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local function createFeaturePanel(
    name,
    description,
    tierDefault,
    delayDefault,
    maxTier
)
    local panel = Instance.new('Frame')
    panel.Size = UDim2.new(1, 0, 1, -50)
    panel.Position = UDim2.new(0, 0, 0, 50)
    panel.BackgroundTransparency = 1
    panel.Name = name .. 'Panel'
    panel.Visible = false

    local listLayout = Instance.new('UIListLayout', panel)
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.FillDirection = Enum.FillDirection.Vertical

    local statusFrame = Instance.new('Frame', panel)
    statusFrame.Size = UDim2.new(1, -40, 0, 40)
    statusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Instance.new('UICorner', statusFrame).CornerRadius = UDim.new(0, 8)

    local statusLabel = Instance.new('TextLabel', statusFrame)
    statusLabel.Size = UDim2.new(1, 0, 1, 0)
    statusLabel.Text = 'Loop: OFF'
    statusLabel.TextColor3 = OFF_COLOR
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 18
    statusLabel.BackgroundTransparency = 1

    local descLabel = Instance.new('TextLabel', panel)
    descLabel.Size = UDim2.new(1, -40, 0, 40)
    descLabel.Text = description .. ' | Max Tier: ' .. maxTier
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 15
    descLabel.BackgroundTransparency = 1

    local inputContainer = Instance.new('Frame', panel)
    inputContainer.Size = UDim2.new(1, -40, 0, 50)
    inputContainer.BackgroundTransparency = 1

    local gridLayout = Instance.new('UIGridLayout', inputContainer)
    gridLayout.CellSize = UDim2.new(0.5, -5, 1, -10)
    gridLayout.FillDirection = Enum.FillDirection.Horizontal
    gridLayout.CellPadding = UDim2.new(0, 10, 0, 0)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local tierBox = Instance.new('TextBox', inputContainer)
    tierBox.Size = UDim2.new(0.5, -5, 1, 0)
    tierBox.PlaceholderText = 'Tier (1 - ' .. maxTier .. ')'
    tierBox.Text = ''
    tierBox.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    tierBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    tierBox.TextSize = 16
    Instance.new('UICorner', tierBox).CornerRadius = UDim.new(0, 6)

    local delayBox = Instance.new('TextBox', inputContainer)
    delayBox.Size = UDim2.new(0.5, -5, 1, 0)
    delayBox.PlaceholderText = 'Delay (Seconds)'
    delayBox.Text = ''
    delayBox.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    delayBox.TextSize = 16
    Instance.new('UICorner', delayBox).CornerRadius = UDim.new(0, 6)

    return panel, statusLabel, tierBox, delayBox
end

local function createCreditsPanel(name, creditsText)
    local panel = Instance.new('Frame')
    panel.Size = UDim2.new(1, 0, 1, -50)
    panel.Position = UDim2.new(0, 0, 0, 50)
    panel.BackgroundTransparency = 1
    panel.Name = name .. 'Panel'
    panel.Visible = false

    local label = Instance.new('TextLabel', panel)
    label.Size = UDim2.new(1, -40, 1, -20)
    label.Position = UDim2.new(0, 20, 0, 10)
    label.Text = creditsText
    label.TextColor3 = Color3.fromRGB(150, 150, 180)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center

    return panel
end

local winPanel, winStatus, winTierBox, winDelayBox = createFeaturePanel(
    'Wins',
    'Fires Win Upgrade event for boosting size.',
    winTier,
    winDelay,
    8
)
winPanel.Parent = contentPanel
winPanel.Position = UDim2.new(0, 0, 0, 50)

local rebirthPanel, rebirthStatus, rebirthTierBox, rebirthDelayBox =
    createFeaturePanel(
        'Rebirths',
        'Fires Rebirth event to reset and gain multipliers.',
        rebirthTier,
        rebirthDelay,
        24 -- Max tier updated to 24
    )
rebirthPanel.Parent = contentPanel
rebirthPanel.Position = UDim2.new(0, 0, 0, 50)

local creditsPanel = createCreditsPanel(
    'Credits',
    'Made by:\nRoblox: carsgovroom\nDiscord: offmyantidepressants'
)
creditsPanel.Parent = contentPanel
creditsPanel.Position = UDim2.new(0, 0, 0, 50)

local winNavBtn = createNavButton('Wins Upgrade')
local rebirthNavBtn = createNavButton('Rebirth Automation')
local creditsNavBtn = createNavButton('Credits')

local navButtons = {
    ['Wins'] = winNavBtn,
    ['Rebirths'] = rebirthNavBtn,
    ['Credits'] = creditsNavBtn,
}
local panels = {
    ['Wins'] = winPanel,
    ['Rebirths'] = rebirthPanel,
    ['Credits'] = creditsPanel,
}

local function switchView(viewName)
    currentView = viewName
    contentTitle.Text = viewName .. ' Settings'
    if viewName == 'Credits' then
        contentTitle.Text = 'Credits'
    end

    for name, panel in pairs(panels) do
        panel.Visible = (name == viewName)
    end

    for name, btn in pairs(navButtons) do
        if name == viewName then
            btn.BackgroundColor3 = ACCENT_COLOR
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = SECONDARY_BG
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
end

winNavBtn.MouseButton1Click:Connect(function()
    switchView('Wins')
end)

rebirthNavBtn.MouseButton1Click:Connect(function()
    switchView('Rebirths')
end)

creditsNavBtn.MouseButton1Click:Connect(function()
    switchView('Credits')
end)

switchView('Wins')

local function updateStatusLabels()
    winStatus.Text = 'Loop: ' .. (winLoop and 'ON' or 'OFF')
    winStatus.TextColor3 = winLoop and Color3.fromRGB(0, 255, 0) or OFF_COLOR

    rebirthStatus.Text = 'Loop: ' .. (rebirthLoop and 'ON' or 'OFF')
    rebirthStatus.TextColor3 = rebirthLoop and Color3.fromRGB(0, 255, 0)
        or OFF_COLOR
end
updateStatusLabels()

local function validateInput(textBox, defaultValue, minVal, maxVal, settingVar)
    return function(enterPressed)
        if enterPressed then
            local n = tonumber(textBox.Text)
            local isValid = n and n >= minVal
            if maxVal then
                isValid = isValid and n <= maxVal
            end

            if isValid then
                if settingVar == 'winTier' then
                    winTier = n
                elseif settingVar == 'winDelay' then
                    winDelay = n
                elseif settingVar == 'rebirthTier' then
                    rebirthTier = n
                elseif settingVar == 'rebirthDelay' then
                    rebirthDelay = n
                end
            elseif textBox.Text == '' then
            else
                textBox.Text = ''
            end
        end
    end
end

winTierBox.FocusLost:Connect(
    validateInput(winTierBox, winTier, 1, 8, 'winTier')
)
winDelayBox.FocusLost:Connect(
    validateInput(winDelayBox, winDelay, 0.001, nil, 'winDelay')
)
rebirthTierBox.FocusLost:Connect(
    validateInput(rebirthTierBox, rebirthTier, 1, 24, 'rebirthTier') -- Max tier updated to 24
)
rebirthDelayBox.FocusLost:Connect(
    validateInput(rebirthDelayBox, rebirthDelay, 0.001, nil, 'rebirthDelay')
)

uis.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.T and not gameProcessed then
        mainFrame.Visible = not mainFrame.Visible
        return
    end

    if gameProcessed or uis:GetFocusedTextBox() or not mainFrame.Visible then
        return
    end

    if input.KeyCode == Enum.KeyCode.E then
        winLoop = not winLoop
        updateStatusLabels()
    elseif input.KeyCode == Enum.KeyCode.Q then
        rebirthLoop = not rebirthLoop
        updateStatusLabels()
    end
end)

task.spawn(function()
    while runservice.Heartbeat:Wait() do
        if winLoop and winsStat and winsStat.Value > 0 then
            winEvent:FireServer('tier' .. winTier)
            task.wait(winDelay)
        end
    end
end)

task.spawn(function()
    while runservice.Heartbeat:Wait() do
        if rebirthLoop and winsStat and winsStat.Value > 0 then
            rebirthEvent:FireServer('tier' .. rebirthTier)
            task.wait(rebirthDelay)
        end
    end
end)
