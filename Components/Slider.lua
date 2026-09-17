--[[
    Peakx Hub - Components/Slider.lua
    Registra Library.Components.Slider

    Uso desde un Tab:
        Tab:CreateSlider({
            Name = "Speed",
            Min = 16,
            Max = 200,
            Default = 16,
            Callback = function(value) end
        })
]]

return function(Library, TweenService)
    local UserInputService = game:GetService("UserInputService")

    Library.Components.Slider = function(parent, config)
        config = config or {}
        local Name = config.Name or "Slider"
        local Min = config.Min or 0
        local Max = config.Max or 100
        local Default = math.clamp(config.Default or Min, Min, Max)
        local Callback = config.Callback or function() end

        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 50)
        Row.BackgroundColor3 = Library.Theme.Section
        Row.BorderSizePixel = 0
        Row.Parent = parent
        Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Library.Theme.Stroke
        Stroke.Transparency = 0.88
        Stroke.Thickness = 1
        Stroke.Parent = Row

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -70, 0, 20)
        Label.Position = UDim2.new(0, 12, 0, 6)
        Label.BackgroundTransparency = 1
        Label.Text = Name
        Label.TextColor3 = Library.Theme.Text
        Label.Font = Enum.Font.GothamSemibold
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Row

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0, 58, 0, 20)
        ValueLabel.Position = UDim2.new(1, -70, 0, 6)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(Default)
        ValueLabel.TextColor3 = Library.Theme.Accent
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.TextSize = 13
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = Row

        local Track = Instance.new("Frame")
        Track.Size = UDim2.new(1, -24, 0, 6)
        Track.Position = UDim2.new(0, 12, 0, 32)
        Track.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Track.BorderSizePixel = 0
        Track.Parent = Row
        Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

        local Fill = Instance.new("Frame")
        Fill.BackgroundColor3 = Library.Theme.Accent
        Fill.BorderSizePixel = 0
        Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
        Fill.Parent = Track
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

        local currentValue = Default
        local dragging = false

        local function updateFromInputPos(xPos)
            local relative = math.clamp((xPos - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            currentValue = math.floor(Min + (Max - Min) * relative + 0.5)
            Fill.Size = UDim2.new(relative, 0, 1, 0)
            ValueLabel.Text = tostring(currentValue)
            Callback(currentValue)
        end

        Track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateFromInputPos(input.Position.X)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateFromInputPos(input.Position.X)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        return {
            Set = function(v)
                v = math.clamp(v, Min, Max)
                currentValue = v
                local relative = (v - Min) / (Max - Min)
                Fill.Size = UDim2.new(relative, 0, 1, 0)
                ValueLabel.Text = tostring(v)
            end,
            Get = function() return currentValue end,
        }
    end
end
