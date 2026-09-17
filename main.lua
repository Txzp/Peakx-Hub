--[[
    Peakx Hub - main.lua
    Core: Window + Tab system + loader de Components/*.lua

    Uso:
        local Peakx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Txzp/Peakx-Hub/main/main.lua"))()

        local Window = Peakx:CreateWindow({
            Title = "Game Name",
            Icon  = "rbxassetid://113003226984087",
        })

        local Tab = Window:CreateTab("Main")

        Tab:CreateToggle({ Name = "Noclip", Default = false, Callback = function(v) end })
]]

local Library = {}
Library.Components = {}
Library.Flags = {}

-- SERVICIOS
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- CONFIG: de aquí se bajan los componentes
local REPO_RAW = "https://raw.githubusercontent.com/Txzp/Peakx-Hub/main/"

-- TEMA (full black, consistente con el resto del hub)
Library.Theme = {
    Background   = Color3.fromRGB(0, 0, 0),
    Section      = Color3.fromRGB(0, 0, 0),
    SectionHover = Color3.fromRGB(22, 22, 22),
    Stroke       = Color3.fromRGB(255, 255, 255),
    Text         = Color3.fromRGB(225, 225, 225),
    Accent       = Color3.fromRGB(70, 200, 110),
}

-- ════════════════════════════════════════
--   CARGA DE COMPONENTES DESDE Components/
-- ════════════════════════════════════════
local function loadComponent(name)
    local ok, src = pcall(function()
        return game:HttpGet(REPO_RAW .. "Components/" .. name .. ".lua")
    end)
    if not ok then
        warn("[Peakx] No se pudo descargar el componente: " .. name)
        return
    end

    local chunk, compileErr = loadstring(src)
    if not chunk then
        warn("[Peakx] Error compilando " .. name .. ": " .. tostring(compileErr))
        return
    end

    local success, runErr = pcall(chunk, Library, TweenService)
    if not success then
        warn("[Peakx] Error ejecutando " .. name .. ": " .. tostring(runErr))
    end
end

for _, name in ipairs({ "Button", "Toggle", "Slider", "Dropdown" }) do
    loadComponent(name)
end

-- ════════════════════════════════════════
--              CreateWindow
-- ════════════════════════════════════════
function Library:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "Peakx Hub"
    local Icon = config.Icon or ""

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PeakxHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = PlayerGui

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 480, 0, 340)
    Main.Position = UDim2.new(0.5, -240, 0.5, -170)
    Main.BackgroundColor3 = Library.Theme.Background
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Library.Theme.Stroke
    MainStroke.Transparency = 0.88
    MainStroke.Thickness = 1
    MainStroke.Parent = Main

    -- TOPBAR
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Library.Theme.Background
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

    local IconImg = Instance.new("ImageLabel")
    IconImg.Size = UDim2.new(0, 20, 0, 20)
    IconImg.Position = UDim2.new(0, 12, 0.5, -10)
    IconImg.BackgroundTransparency = 1
    IconImg.Image = Icon
    IconImg.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 40, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Position = UDim2.new(1, -32, 0.5, -12)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 40, 40)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 12
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = TopBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- TABBAR (columna izquierda con los botones de pestañas)
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(0, 120, 1, -50)
    TabBar.Position = UDim2.new(0, 0, 0, 40)
    TabBar.BackgroundColor3 = Library.Theme.Background
    TabBar.BorderSizePixel = 0
    TabBar.Parent = Main

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 4)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabBar

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)
    TabPadding.Parent = TabBar

    local Sep = Instance.new("Frame")
    Sep.Size = UDim2.new(0, 1, 1, -50)
    Sep.Position = UDim2.new(0, 120, 0, 40)
    Sep.BackgroundColor3 = Library.Theme.Stroke
    Sep.BackgroundTransparency = 0.9
    Sep.BorderSizePixel = 0
    Sep.Parent = Main

    -- CONTENEDOR DE PÁGINAS (una por tab)
    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, -121, 1, -50)
    Pages.Position = UDim2.new(0, 121, 0, 40)
    Pages.BackgroundTransparency = 1
    Pages.ClipsDescendants = true
    Pages.Parent = Main

    local Window = {}
    Window._tabs = {}

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Library.Theme.Section
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.BorderSizePixel = 0
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabBar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Library.Theme.Stroke
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        Page.Parent = Pages

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)
        PagePadding.Parent = Page

        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 8)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Parent = Page

        local function setActive()
            for _, t in pairs(Window._tabs) do
                t.page.Visible = false
                TweenService:Create(t.button, TweenInfo.new(0.15), {
                    BackgroundColor3 = Library.Theme.Section,
                    TextColor3 = Color3.fromRGB(180, 180, 180),
                }):Play()
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {
                BackgroundColor3 = Library.Theme.SectionHover,
                TextColor3 = Color3.fromRGB(255, 255, 255),
            }):Play()
        end

        TabBtn.MouseButton1Click:Connect(setActive)
        table.insert(Window._tabs, { button = TabBtn, page = Page, name = name })

        if #Window._tabs == 1 then
            setActive()
        end

        local Tab = {}

        function Tab:CreateButton(cfg)
            return Library.Components.Button(Page, cfg)
        end

        function Tab:CreateToggle(cfg)
            return Library.Components.Toggle(Page, cfg)
        end

        function Tab:CreateSlider(cfg)
            return Library.Components.Slider(Page, cfg)
        end

        function Tab:CreateDropdown(cfg)
            return Library.Components.Dropdown(Page, cfg)
        end

        return Tab
    end

    return Window
end

return Library
