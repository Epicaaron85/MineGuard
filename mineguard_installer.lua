local function clearScreen()
    term.clear()
    term.setCursorPos(1, 1)
end

local function drawInterface()
    clearScreen()
    term.setTextColor(colors.cyan)
    term.setCursorPos(1, 2)
    print("===== MineGuard Installer =====")
    term.setCursorPos(1, 4)
    term.setBackgroundColor(colors.blue)
    term.setTextColor(colors.white)
    term.clearLine()
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
        "startup.lua",
        "main.lua",
        "manager.lua"
    }

    if not fs.exists("MineGuard") then
        fs.makeDir("MineGuard")
    end

    for _, file in ipairs(files) do
        local url = baseURL .. file
        local filePath = "/MineGuard/" .. file

        print("Downloading: " .. file)
        local response = http.get(url)
        if response then
            local fileHandle = fs.open(filePath, "w")
            fileHandle.write(response.readAll())
            fileHandle.close()
            response.close()
            print(file .. " downloaded successfully.")
        else
            print("Error: Could not download " .. file)
        end
    end
end

local function restartSystem()
    print("Restarting system in 5 seconds...")
    sleep(5)
    os.reboot()
end

local function main()
    if not http then
        print("HTTP API is disabled. Please enable it in the ComputerCraft configuration.")
        return
    end

    drawInterface()
    waitForButton()
    clearScreen()
    print("Downloading files...")
    downloadFiles()
    print("Download complete! Files saved in the 'MineGuard' directory.")

    -- Automatically move startup.lua to the root if it exists
    if fs.exists("/MineGuard/startup.lua") then
        fs.copy("/MineGuard/startup.lua", "/startup.lua")
        print("Startup file moved to root directory.")
    else
        print("Error: startup.lua not found. Check the repository.")
    end

    restartSystem()
end

main()
