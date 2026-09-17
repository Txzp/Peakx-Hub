--[[
    Peakx Hub - Components/Button.lua
    Registra Library.Components.Button

    Uso desde un Tab:
        Tab:CreateButton({
            Name = "Reset Character",
            Callback = function() end
        })
]]

return function(Library, TweenService)
    Library.Components.Button = function(parent, config)
        config = config or {}
        local Name = config.Name or "Button"
        local Callback = config.Callback or function() end

        local Row = Instance.new("TextButton")
        Row.Size = UDim2.new(1, 0, 0, 36)
        Row.BackgroundColor3 = Library.Theme.Section
        Row.AutoButtonColor = false
        Row.Text = ""
        Row.BorderSizePixel = 0
        Row.Parent = parent
        Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Library.Theme.Stroke
        Stroke.Transparency = 0.88
        Stroke.Thickness = 1
        Stroke.Parent = Row

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -20, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Name
        Label.TextColor3 = Library.Theme.Text
        Label.Font = Enum.Font.GothamSemibold
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Row

        Row.MouseEnter:Connect(function()
            TweenService:Create(Row, TweenInfo.new(0.15), { BackgroundColor3 = Library.Theme.SectionHover }):Play()
        end)
        Row.MouseLeave:Connect(function()
            TweenService:Create(Row, TweenInfo.new(0.15), { BackgroundColor3 = Library.Theme.Section }):Play()
        end)
        Row.MouseButton1Click:Connect(function()
            Callback()
        end)

        return {
            SetText = function(txt) Label.Text = txt end,
        }
    end
end
