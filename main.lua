-- Example.lua
print("Carregando exemplo...")
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Player3030/teste2/main.lua"))()
if not Fluent then
    error("Falha ao carregar Fluent.")
end

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Player3030/teste2/refs/heads/main/Addons/SaveManager.lua"))()
if not SaveManager then
    error("Falha ao carregar SaveManager.")
end

local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Player3030/teste2/InterfaceManager.lua"))()
if not InterfaceManager then
    error("Falha ao carregar InterfaceManager.")
end

print("Exemplo carregado.")

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- O desfoque pode ser detectável, definir isso como falso desativa o desfoque totalmente
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Usado quando não há MinimizeKeybind
})

-- Criando as abas
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Configurando os gerenciadores
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignorar configurações de temas para o SaveManager
SaveManager:IgnoreThemeSettings()

-- Defina o diretório para salvar configurações
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

-- Adicionando opções e interatividade à aba Main
do
    Fluent:Notify({
        Title = "Notificação",
        Content = "Esta é uma notificação",
        SubContent = "SubContent", -- Opcional
        Duration = 5 -- Defina como nil para não fazer a notificação desaparecer
    })

    Tabs.Main:AddParagraph({
        Title = "Parágrafo",
        Content = "Este é um parágrafo.\nSegunda linha!"
    })

    Tabs.Main:AddButton({
        Title = "Botão",
        Description = "Botão muito importante",
        Callback = function()
            Window:Dialog({
                Title = "Título",
                Content = "Este é um diálogo",
                Buttons = {
                    {
                        Title = "Confirmar",
                        Callback = function()
                            print("Diálogo confirmado.")
                        end
                    },
                    {
                        Title = "Cancelar",
                        Callback = function()
                            print("Diálogo cancelado.")
                        end
                    }
                }
            })
        end
    })

    -- Exemplos de Toggle, Slider, Dropdown, etc.
    local Toggle = Tabs.Main:AddToggle("MyToggle", { Title = "Toggle", Default = false })
    Toggle:OnChanged(function()
        print("Toggle alterado:", Options.MyToggle.Value)
    end)

    Options.MyToggle:SetValue(false)

    local Slider = Tabs.Main:AddSlider("Slider", {
        Title = "Slider",
        Description = "Este é um slider",
        Default = 2,
        Min = 0,
        Max = 5,
        Rounding = 1,
        Callback = function(Value)
            print("Slider foi alterado:", Value)
        end
    })

    Slider:OnChanged(function(Value)
        print("Slider alterado:", Value)
    end)

    Slider:SetValue(3)

    local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
        Title = "Dropdown",
        Values = {"um", "dois", "três", "quatro", "cinco"},
        Multi = false,
        Default = 1,
    })

    Dropdown:SetValue("quatro")
    Dropdown:OnChanged(function(Value)
        print("Dropdown alterado:", Value)
    end)

    -- Adicionando mais componentes conforme necessário...
end

-- Adicionando as seções de configuração do InterfaceManager e do SaveManager na aba de configurações
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Selecionando a aba principal por padrão
Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "O script foi carregado.",
    Duration = 8
})

-- Carregar configurações de autoload, se necessário
SaveManager:LoadAutoloadConfig()
