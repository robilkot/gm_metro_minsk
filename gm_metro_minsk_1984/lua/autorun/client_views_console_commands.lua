-----------------------------------------------------------------------------------------
--                          Творческое объединение "MetroPack"
--	Скрипт написан в 2022 году для карты gm_metro_minsk_1984.
--	Аддон позваляет добавлять видимость серверных консольных команд на клиенте,
--  а так же добавлять для них автозаполнение.
--	Автор: 	klusandr
--	Steam: 	https://steamcommunity.com/id/andr47/
--	VK:		https://vk.com/andreyklysevich
--  Дополнительная информация в файле lua/licence.lua
-----------------------------------------------------------------------------------------

if (game.GetMap() != "gm_metro_minsk_1984") then return end

-- Returns the number of repetitions of a character.
-- (str) - The string to search for.
-- (char) - Search character.
-- RETURN - The number of repetitions of a character.
local function charCount(str, char)
    local count = 0

    for i = 1, #str do
        if (str[i] == char) then count = count + 1 end    
    end

    return count
end

if (CLIENT) then
    if (not game.SinglePlayer()) then
        local adminOnlyCommands = {}

        -- Send console command and arguments to server.
        -- (command) - Console command.
        -- (argStr) - String of console command arguments.
        local function sendConCommandToServer(ply, command, _, argStr)
            if (adminOnlyCommands[command]) then
                if (not LocalPlayer():IsAdmin()) then
                    print("У вас недостаточно прав для использования этой команды.")
                    return
                end
            end

            local message = command

            if (argStr) then message = message.." "..argStr end

            net.Start("client-views-console-commands")
                net.WriteString(message)
            net.SendToServer()
        end
        
        -- Add console command view for client.
        -- (name) - Name of console command.
        -- (autoComplete) - Function of auto complete command. 
        --      Receives parameters: 
        --          (command) - Console command.
        --          (argStr) - String of command arguments.
        --          (argNum) - Number of the current argument, where cursore is located.
        -- (helpText) - The text to display should a user run 'help cmdName'.
        -- (isAdminOnly) - Only the admin can use the command.
        function concommand.AddClientView(command, autoComplete, helpText, isAdminOnly)
            local autoCompleteEx
            if (autoComplete) then
                autoCompleteEx = function(command, argStr)
                    return autoComplete(command, argStr, charCount(argStr, ' '))
                end
            end
            
            if (isAdminOnly) then
                adminOnlyCommands[command] = true
            end

            concommand.Add(command, sendConCommandToServer, autoCompleteEx, helpText)
        end
    else
        -- Null function for singleplayer.
        function concommand.AddClientView() end
    end
end

if (SERVER) then
    if (not game.SinglePlayer()) then

        -- Run console command function.
        -- (command) - Console command.
        -- (args) - Console command arguments.
        -- (ply) - Player on whose behalf the command will be run.
        local function runConCommandFunc(command, args, ply)
            local commndTable = concommand.GetTable()
            local commandFunc = commndTable[command]
            
            if (commandFunc) then
                local argStr = ""
    
                if (args) then
                    for _, arg in ipairs(args) do
                        argStr = argStr.." "..tostring(arg)
                    end
                end
                
                commandFunc(ply, command, args or {}, argStr)
            end
        end
        
        -- Receiev console command from client.
        -- (ply) - Player who sent the message.
        local function receievConCommand(_, ply)
            local commandStr = net.ReadString()
            local commandParts = string.Split(commandStr, ' ')
    
            local command = commandParts[1]
            local args = {}
            
            for i = 2, #commandParts do
                table.insert(args, commandParts[i])
            end
    
            runConCommandFunc(command, args, ply)
        end
        
        util.AddNetworkString("client-views-console-commands")
        net.Receive("client-views-console-commands", receievConCommand)

        -- Null function for multiplayer.
        function concommand.AddClientView() end
    else
        -- Add function of the auto complete for console commands.
        -- (command) - Console commands.
        -- (autoComplete) - Function of the auto complete.
        local function addAutoComplete(command, autoComplete)
            local _, completeTable = concommand.GetTable()
            completeTable[command] = autoComplete
        end
        
        -- Add console command view for client.
        -- (name) - Name of console command.
        -- (autoComplete) - Function of auto complete command. 
        --      Receives parameters: 
        --          (command) - Console command.
        --          (argStr) - String of command arguments.
        --          (argNum) - Number of the current argument, where cursore is located.
        function concommand.AddClientView(command, autoComplete)
            local autoCompleteEx
    
            if (autoComplete) then
                autoCompleteEx = function(command, argStr)
                    return autoComplete(command, argStr, charCount(argStr, ' '))
                end

                addAutoComplete(command, autoCompleteEx)
            end
        end
    end 
end