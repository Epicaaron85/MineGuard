local function downloadFile(url, path)
    local response = http.get(url)
    if response then
        local fileHandle = fs.open(path, "w")
        fileHandle.write(response.readAll())
        fileHandle.close()
        response.close()
        return true
    else
        return false
    end
end

local function checkAndUpdate()
    local baseURL = "https://raw.githubusercontent.com/Epicaaron85/MineGuard/main/"
    local files = {"startup.lua", "main.lua", "manager.lua"}
    local isUpToDate = true

    for _, file in ipairs(files) do
        local url = baseURL .. file
        local tempPath = "/.temp_" .. file
        local localPath = "/" .. file

        if downloadFile(url, tempPath) then
            if fs.exists(localPath) then
                local tempContent = fs.open(tempPath, "r").readAll()
                local localContent = fs.open(localPath, "r").readAll()
                
                if tempContent ~= localContent then
                    isUpToDate = false
                    downloadFile(url, localPath)
                end
                
                fs.delete(tempPath)
            else
                isUpToDate = false
                downloadFile(url, localPath)
            end
        else
            print("Error: Unable to verify or update " .. file)
        end
    end

    return isUpToDate
end

local function displayWelcome()
    term.clear()
    term.setCursorPos(1, 1)
    term.setTextColor(colors.cyan)
    print("===== Welcome in your computer =====")
    term.setCursorPos(1, 19)
    term.setTextColor(colors.yellow)
    print("===== Protected by MineGuard =====")
    term.setCursorPos(1, 20)
    term.setTextColor(colors.lightGray)
    print("= Use \"scan\" to scan your computer =")
    term.setTextColor(colors.white)
end

local function scanForThreats()
    local threats = {}
    local programs = fs.list("/")
    local suspiciousNames = {"malware.lua", "keylogger.lua", "virus.lua", "disableInput.lua"}

    for _, program in ipairs(programs) do
        for _, name in ipairs(suspiciousNames) do
            if program == name then
                table.insert(threats, program)
            end
        end
    end

    return threats
end

local function main()
    displayWelcome()
    print("Checking for updates...")
    if checkAndUpdate() then
        print("All files are up to date.")
    else
        print("Update completed.")
    end
    
    print("Performing initial scan...")
    local threats = scanForThreats()
    if #threats > 0 then
        print("Warning: Potential threats detected!")
        for _, threat in ipairs(threats) do
            print("- " .. threat)
        end
    else
        print("System is safe.")
    end

    if fs.exists("/main.lua") then
        shell.run("/main.lua")
    else
        print("Error: Main file not found. Check the installation.")
    end
end

main()
