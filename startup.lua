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
    local files = {
        "startup.lua",
        "main.lua",
        "manager.lua"
    }
    
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

local function main()
    print("Checking for updates...")
    if checkAndUpdate() then
        print("All files are up to date.")
    else
        print("Update completed.")
    end

    if fs.exists("/main.lua") then
        shell.run("/main.lua")
    else
        print("Error: Main file not found. Check the installation.")
    end
end

main()
