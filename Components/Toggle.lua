--[[
    Peakx Hub - Components/Toggle.lua
    Registra Library.Components.Toggle

    Uso desde un Tab:
        Tab:CreateToggle({
            Name = "Noclip",
            Default = false,
            Callback = function(state) end
        })
]]

return function(Library, TweenService)
    Library.Components.Toggle = function(parent, config)
        config = config or {}
        local Name = config.Name or "Toggle"
        local Default = config.Default or false
        local Callback = config.Callback or function() end

        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 36)
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
        Label.Size = UDim2.new(1, -70, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Name
        Label.TextColor3 = Library.Theme.Text
        Label.Font = Enum.Font.GothamSemibold
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Row

        local Pill = Instance.new("Frame")
        Pill.Size = UDim2.new(0, 42, 0, 22)
        Pill.Position = UDim2.new(1, -54, 0.5, -11)
        Pill.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Pill.BorderSizePixel = 0
        Pill.Parent = Row
        Instance.new("UICorner", Pill).CornerRadius = UDim.new(1, 0)

        local Dot = Instance.new("Frame")
        Dot.Size = UDim2.new(0, 16, 0, 16)
        Dot.Position = UDim2.new(0, 3, 0.5, -8)
        Dot.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
        Dot.BorderSizePixel = 0
        Dot.Parent = Pill
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

        local ClickBtn = Instance.new("TextButton")
        ClickBtn.Size = UDim2.new(1, 0, 1, 0)
        ClickBtn.BackgroundTransparency = 1
        ClickBtn.Text = ""
        ClickBtn.Parent = Row

        local isOn = false
        local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quad)

        local function setState(v, fireCallback)
            isOn = v
            if v then
                TweenService:Create(Pill, ti, { BackgroundColor3 = Library.Theme.Accent }):Play()
                TweenService:Create(Dot, ti, {
                    Position = UDim2.new(0, 23, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                }):Play()
            else
                TweenService:Create(Pill, ti, { BackgroundColor3 = Color3.fromRGB(35, 35, 35) }):Play()
                TweenService:Create(Dot, ti, {
                    Position = UDim2.new(0, 3, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(160, 160, 160),
                }):Play()
            end
            if fireCallback ~= false then
                Callback(isOn)
            end
        end

        ClickBtn.MouseButton1Click:Connect(function() setState(not isOn) end)
        ClickBtn.MouseEnter:Connect(function()
            TweenService:Create(Row, TweenInfo.new(0.15), { BackgroundColor3 = Library.Theme.SectionHover }):Play()
        end)
        ClickBtn.MouseLeave:Connect(function()
            TweenService:Create(Row, TweenInfo.new(0.15), { BackgroundColor3 = Library.Theme.Section }):Play()
        end)

        setState(Default, false)

        return {
            Set = function(v) setState(v) end,
            Get = function() return isOn end,
        }
    end
end
