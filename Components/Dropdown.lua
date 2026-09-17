--[[
    Peakx Hub - Components/Dropdown.lua
    Registra Library.Components.Dropdown

    Uso desde un Tab:
        Tab:CreateDropdown({
            Name = "Target",
            Options = {"Nearest", "Lowest HP", "Highest HP"},
            Default = "Nearest",
            Callback = function(option) end
        })
]]

return function(Library, TweenService)
    Library.Components.Dropdown = function(parent, config)
        config = config or {}
        local Name = config.Name or "Dropdown"
        local Options = config.Options or {}
        local Default = config.Default or Options[1]
        local Callback = config.Callback or function() end

        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 36)
        Row.BackgroundColor3 = Library.Theme.Section
        Row.BorderSizePixel = 0
        Row.ClipsDescendants = false
        Row.ZIndex = 2
        Row.Parent = parent
        Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Library.Theme.Stroke
        Stroke.Transparency = 0.88
        Stroke.Thickness = 1
        Stroke.Parent = Row

        local MainBtn = Instance.new("TextButton")
        MainBtn.Size = UDim2.new(1, 0, 0, 36)
        MainBtn.BackgroundTransparency = 1
        MainBtn.Text = ""
        MainBtn.ZIndex = 2
        MainBtn.Parent = Row

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -40, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Name .. ": " .. tostring(Default or "—")
        Label.TextColor3 = Library.Theme.Text
        Label.Font = Enum.Font.GothamSemibold
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.ZIndex = 2
        Label.Parent = Row

        local Arrow = Instance.new("TextLabel")
        Arrow.Size = UDim2.new(0, 20, 1, 0)
        Arrow.Position = UDim2.new(1, -28, 0, 0)
        Arrow.BackgroundTransparency = 1
        Arrow.Text = "▾"
        Arrow.TextColor3 = Library.Theme.Text
        Arrow.Font = Enum.Font.GothamBold
        Arrow.TextSize = 14
        Arrow.ZIndex = 2
        Arrow.Parent = Row

        local ListHolder = Instance.new("Frame")
        ListHolder.Size = UDim2.new(1, 0, 0, 0)
        ListHolder.Position = UDim2.new(0, 0, 0, 36)
        ListHolder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        ListHolder.BorderSizePixel = 0
        ListHolder.ClipsDescendants = true
        ListHolder.ZIndex = 3
        ListHolder.Parent = Row
        Instance.new("UICorner", ListHolder).CornerRadius = UDim.new(0, 8)

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Parent = ListHolder

        local currentValue = Default
        local isOpen = false

        local function close()
            isOpen = false
            TweenService:Create(ListHolder, TweenInfo.new(0.15), { Size = UDim2.new(1, 0, 0, 0) }):Play()
            TweenService:Create(Arrow, TweenInfo.new(0.15), { Rotation = 0 }):Play()
        end

        local function open()
            isOpen = true
            local h = math.min(#Options * 28, 140)
            TweenService:Create(ListHolder, TweenInfo.new(0.15), { Size = UDim2.new(1, 0, 0, h) }):Play()
            TweenService:Create(Arrow, TweenInfo.new(0.15), { Rotation = 180 }):Play()
        end

        for _, option in ipairs(Options) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Size = UDim2.new(1, 0, 0, 28)
            OptBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            OptBtn.AutoButtonColor = false
            OptBtn.Text = tostring(option)
            OptBtn.TextColor3 = Library.Theme.Text
            OptBtn.Font = Enum.Font.Gotham
            OptBtn.TextSize = 12
            OptBtn.BorderSizePixel = 0
            OptBtn.ZIndex = 3
            OptBtn.Parent = ListHolder

            OptBtn.MouseEnter:Connect(function()
                TweenService:Create(OptBtn, TweenInfo.new(0.1), { BackgroundColor3 = Library.Theme.SectionHover }):Play()
            end)
            OptBtn.MouseLeave:Connect(function()
                TweenService:Create(OptBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(15, 15, 15) }):Play()
            end)

            OptBtn.MouseButton1Click:Connect(function()
                currentValue = option
                Label.Text = Name .. ": " .. tostring(option)
                Callback(option)
                close()
            end)
        end

        MainBtn.MouseButton1Click:Connect(function()
            if isOpen then close() else open() end
        end)

        return {
            Set = function(v)
                currentValue = v
                Label.Text = Name .. ": " .. tostring(v)
            end,
            Get = function() return currentValue end,
        }
    end
end
