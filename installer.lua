local function clearScreen()
    term.clear()
    term.setCursorPos(1, 1)
end

local function drawInterface()
    clearScreen()
    term.setTextColor(colors.cyan)
    term.setCursorPos(1, 2)
    term.setBackgroundColor(colors.black)
    term.clearLine()
    print("===== MineGuard Installer =====")
    term.setCursorPos(1, 4)
    term.setBackgroundColor(colors.blue)
    term.setTextColor(colors.white)
    term.write(string.rep(" ", 15) .. "Install" .. string.rep(" ", 15))
    term.setBackgroundColor(colors.black)
end

local function waitForButton()
    while true do
        local event, button, x, y = os.pullEvent("mouse_click")
        if y == 4 then
            return
        end
    end
end

local function downloadFiles()
    local baseURL = "https://raw.githubusercontent.com/Epicaaron85/MineGuard/main/"
    local files = {
        "main.lua", "config.lua", "monitor.lua" -- Ajoutez tous les fichiers ici
    }

    if not fs.exists("MineGuard") then
        fs.makeDir("MineGuard")
    end

    for _, file in ipairs(files) do
        local url = baseURL .. file
        local response = http.get(url)
        if response then
            local filePath = "MineGuard/" .. file
            local fileHandle = fs.open(filePath, "w")
            fileHandle.write(response.readAll())
            fileHandle.close()
            response.close()
        else
            print("Erreur: Impossible de télécharger " .. file)
        end
    end
end

local function main()
    http.checkURL("https://raw.githubusercontent.com") -- Vérifie que HTTP est activé
    drawInterface()
    waitForButton()
    clearScreen()
    print("Téléchargement en cours...")
    downloadFiles()
    print("Installation terminée!")
end

main()
