-- GENGAR HUB x FLUENT COM BOTÃO FLUTUANTE FUNCIONAL

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- Carregar Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Criar a Janela Fluent
local Window = Fluent:CreateWindow({
    Title = "Gengar Hub",
    SubTitle = "Script feito por um brasileiro",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Principal", Icon = "target" }),
    Settings = Window:AddTab({ Title = "Config", Icon = "settings" })
}

Tabs.Main:AddButton({
    Title = "Mostrar Notificação",
    Description = "Testando o botão",
    Callback = function()
        Fluent:Notify({
            Title = "Funcionando!",
            Content = "O menu foi carregado com sucesso.",
            Duration = 5
        })
    end
})

Tabs.Main:AddToggle("TestToggle", {
    Title = "Alternar Algo",
    Default = false,
    Callback = function(v)
        print("Toggle:", v)
    end
})

-- BOTÃO FLUTUANTE (MÓVEL) PARA EXIBIR/OCULTAR MENU
local CoreGui = game:GetService("CoreGui")
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "GengarFloatingButton"
toggleGui.ResetOnSpawn = false
toggleGui.Parent = CoreGui

local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 10, 0.6, 0)
toggleBtn.Image = "rbxassetid://131536021675215" -- Ícone do Gengar
toggleBtn.BackgroundTransparency = 1
toggleBtn.Active = true
toggleBtn.ZIndex = 999
toggleBtn.Parent = toggleGui

-- Função para arrastar o botão
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    toggleBtn.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Toggle de abrir/fechar o Fluent
toggleBtn.MouseButton1Click:Connect(function()
    if Window and Window.Minimize then
        Window:Minimize() -- Alterna visibilidade corretamente
    end
end)

-- Configuração SaveManager e InterfaceManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("GengarHubFluent")
SaveManager:SetFolder("GengarHubFluent/Game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
