-- FluentUI Library - Custom GUI Framework with Full Descriptions and Interactive Elements
-- Author: ItsAdam (for Blox Fruits or similar games)

local FluentUI = {}
FluentUI.__index = FluentUI

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
function FluentUI:CreateWindow(config)
    local self = setmetatable({}, FluentUI)

    local Main = Create("ScreenGui", {
        Name = "FluentUI",
        ResetOnSpawn = false,
        Parent = CoreGui
    })

    local Frame = Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(28, 28, 33),
        BorderSizePixel = 0,
        Size = config.Size or UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = Main
    })

    -- Adding Shadow for Smooth UI
    local Shadow = Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, 10, 1, 10),
        Position = UDim2.new(0, -5, 0, -5),
        Parent = Frame
    })
    Shadow.BackgroundTransparency = 0.4
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Shadow })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Frame })

    -- Title of the Window
    local Title = Create("TextLabel", {
        Text = config.Title or "Fluent UI",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        Font = Enum.Font.SegoeUI,
        TextSize = 22,
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
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Container
    })

    -- Tooltip Function to show descriptions
    local function showTooltip(element, description)
        local tooltip = Create("TextLabel", {
            Text = description,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.SegoeUI,
            TextSize = 14,
            Size = UDim2.new(0, 200, 0, 30),
            Position = UDim2.new(0, element.AbsolutePosition.X, 0, element.AbsolutePosition.Y - 35),
            Parent = CoreGui
        })
        tooltip.BackgroundTransparency = 0.7
        game:GetService("Debris"):AddItem(tooltip, 2)  -- Auto remove after 2 seconds
    end

    -- Add Toggle with description
    function self:AddToggle(name, default, callback, description)
        local toggle = default

        local Btn = Create("TextButton", {
            Text = name .. ": " .. (default and "ON" or "OFF"),
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Color3.fromRGB(50, 50, 60),
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.SegoeUI,
            TextSize = 16,
            Parent = Container
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Btn })

        -- Show tooltip when mouse hovers over the button
        Btn.MouseEnter:Connect(function()
            showTooltip(Btn, description or "This is a toggle button")
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
        end)

        Btn.MouseButton1Click:Connect(function()
            toggle = not toggle
            Btn.Text = name .. ": " .. (toggle and "ON" or "OFF")
            if callback then callback(toggle) end
        end)
    end

    -- Add Slider with description
    function self:AddSlider(name, min, max, default, callback, description)
        local Frame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Parent = Container
        })

        local Title = Create("TextLabel", {
            Text = name .. ": " .. default,
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.SegoeUI,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Frame
        })

        local SliderBack = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(70, 70, 80),
            Size = UDim2.new(1, 0, 0, 10),
            Position = UDim2.new(0, 0, 0, 25),
            Parent = Frame
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = SliderBack })

        local Slider = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(100, 160, 255),
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            Parent = SliderBack
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = Slider })

        -- Show description tooltip when hovering over slider
        SliderBack.MouseEnter:Connect(function()
            showTooltip(SliderBack, description or "This is a slider, drag to adjust value.")
        end)

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

    return self
end

return FluentUI
