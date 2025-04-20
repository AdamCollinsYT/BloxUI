-- ModernUI Library - Custom GUI Framework
-- Author: ItsAdam (for Blox Fruits or similar games)
-- Wait, what How You Steel This File 😡
-- This Trap this Virus File you pc got destoryed

local ModernUI = {}
ModernUI.__index = ModernUI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Utility: Create UI element
local function Create(class, props)
    local obj = Instance.new(class)
    for i,v in pairs(props) do
        obj[i] = v
    end
    return obj
end

-- Init Window
function ModernUI:CreateWindow(config)
    local self = setmetatable({}, ModernUI)

    local Main = Create("ScreenGui", {
        Name = "ModernUI",
        ResetOnSpawn = false,
        Parent = CoreGui
    })

    local Frame = Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        BorderSizePixel = 0,
        Size = config.Size or UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = Main
    })

    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Frame })

    local Title = Create("TextLabel", {
        Text = config.Title or "Modern UI",
        TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        Font = Enum.Font.GothamSemibold,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Frame
    })

    local Container = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 50),
        Parent = Frame
    })

    local UIList = Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Container
    })

    function self:AddToggle(name, default, callback)
        local toggle = false

        local Btn = Create("TextButton", {
            Text = name .. ": " .. (default and "ON" or "OFF"),
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(40,40,50),
            TextColor3 = Color3.new(1,1,1),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            Parent = Container
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn })

        toggle = default

        Btn.MouseButton1Click:Connect(function()
            toggle = not toggle
            Btn.Text = name .. ": " .. (toggle and "ON" or "OFF")
            if callback then callback(toggle) end
        end)
    end

    function self:AddSlider(name, min, max, default, callback)
        local Frame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Parent = Container
        })

        local Title = Create("TextLabel", {
            Text = name .. ": " .. default,
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            TextColor3 = Color3.new(1,1,1),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Frame
        })

        local SliderBack = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(50,50,60),
            Size = UDim2.new(1, 0, 0, 10),
            Position = UDim2.new(0, 0, 0, 25),
            Parent = Frame
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = SliderBack })

        local Slider = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(90,150,255),
            Size = UDim2.new((default-min)/(max-min), 0, 1, 0),
            Parent = SliderBack
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = Slider })

        local dragging = false
        local function update(input)
            local pos = input.Position.X - SliderBack.AbsolutePosition.X
            local ratio = math.clamp(pos / SliderBack.AbsoluteSize.X, 0, 1)
            local val = math.floor((min + (max - min) * ratio) + 0.5)
            Slider.Size = UDim2.new(ratio, 0, 1, 0)
            Title.Text = name .. ": " .. val
            if callback then callback(val) end
        end

        SliderBack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        SliderBack.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                update(input)
            end
        end)
    end

    function self:AddDropdown(name, options, callback)
        local current = options[1]

        local Btn = Create("TextButton", {
            Text = name .. ": " .. current,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(40,40,50),
            TextColor3 = Color3.new(1,1,1),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            Parent = Container
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn })

        Btn.MouseButton1Click:Connect(function()
            local new = options[(table.find(options, current) % #options) + 1]
            current = new
            Btn.Text = name .. ": " .. current
            if callback then callback(current) end
        end)
    end

    return self
end

return ModernUI