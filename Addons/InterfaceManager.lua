local httpService = game:GetService("HttpService")

local InterfaceManager = {} do
    InterfaceManager.Folder = "FluentSettings"
    InterfaceManager.Settings = {
        Theme = "Dark",
        Acrylic = true,
        Transparency = true,
        MenuKeybind = "LeftControl"
    }

    -- Define o diretório para salvar as configurações
    function InterfaceManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end

    -- Define a biblioteca de interface
    function InterfaceManager:SetLibrary(library)
        self.Library = library
    end

    -- Cria a estrutura de pastas necessária
    function InterfaceManager:BuildFolderTree()
        local paths = {}

        local parts = self.Folder:split("/")
        for idx = 1, #parts do
            paths[#paths + 1] = table.concat(parts, "/", 1, idx)
        end

        table.insert(paths, self.Folder)
        table.insert(paths, self.Folder .. "/settings")

        for _, str in ipairs(paths) do
            if not isfolder(str) then
                makefolder(str)
            end
        end
    end

    -- Salva as configurações no arquivo
    function InterfaceManager:SaveSettings()
        writefile(self.Folder .. "/options.json", httpService:JSONEncode(self.Settings))
    end

    -- Carrega as configurações do arquivo
    function InterfaceManager:LoadSettings()
        local path = self.Folder .. "/options.json"
        if isfile(path) then
            local data = readfile(path)
            local success, decoded = pcall(httpService.JSONDecode, httpService, data)

            if success then
                for i, v in next, decoded do
                    self.Settings[i] = v
                end
            end
        end
    end

    -- Constrói a seção da interface onde as configurações são gerenciadas
    function InterfaceManager:BuildInterfaceSection(tab)
        assert(self.Library, "Must set InterfaceManager.Library")
        local Library = self.Library
        local Settings = self.Settings

        self:LoadSettings()

        local section = tab:AddSection("Interface")

        -- Dropdown para selecionar o tema
        local InterfaceTheme = section:AddDropdown("InterfaceTheme", {
            Title = "Theme",
            Description = "Changes the interface theme.",
            Values = Library.Themes,
            Default = Settings.Theme,
            Callback = function(Value)
                Library:SetTheme(Value)
                Settings.Theme = Value
                self:SaveSettings()
            end
        })

        InterfaceTheme:SetValue(Settings.Theme)

        -- Toggle para efeito acrílico
        if Library.UseAcrylic then
            section:AddToggle("AcrylicToggle", {
                Title = "Acrylic",
                Description = "The blurred background requires graphic quality 8+",
                Default = Settings.Acrylic,
                Callback = function(Value)
                    Library:ToggleAcrylic(Value)
                    Settings.Acrylic = Value
                    self:SaveSettings()
                end
            })
        end

        -- Toggle para transparência
        section:AddToggle("TransparentToggle", {
            Title = "Transparency",
            Description = "Makes the interface transparent.",
            Default = Settings.Transparency,
            Callback = function(Value)
                Library:ToggleTransparency(Value)
                Settings.Transparency = Value
                self:SaveSettings()
            end
        })

        -- Keybind para minimizar o menu
        local MenuKeybind = section:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = Settings.MenuKeybind })
        MenuKeybind:OnChanged(function()
            Settings.MenuKeybind = MenuKeybind.Value
            self:SaveSettings()
        end)
        Library.MinimizeKeybind = MenuKeybind
    end
end

return InterfaceManager
