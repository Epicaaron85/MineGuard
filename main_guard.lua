local function scanForThreats()
    local threats = {}
    local programs = fs.list("/")
    local suspiciousNames = {"malware.lua", "keylogger.lua", "virus.lua", "disableInput.lua", "tkt.lua", "sys32.lua", "test.lua"}

    for _, program in ipairs(programs) do
        for _, name in ipairs(suspiciousNames) do
            if program == name then
                table.insert(threats, program)
            end
        end
    end

    return threats
end

local function scanCommand()
    print("Scanning for threats...")
    local threats = scanForThreats()
    
    if #threats > 0 then
        print("Threats detected:")
        for _, threat in ipairs(threats) do
            print("- " .. threat)
        end
    else
        print("No threats detected. Your system is safe!")
    end
end

local args = {...}
if #args > 0 and args[1] == "scan" then
    scanCommand()
end
