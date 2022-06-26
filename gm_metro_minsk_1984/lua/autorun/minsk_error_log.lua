Minsk = Minsk or {}
Minsk.ErrorLog = {}

function Minsk.ErrorLog.SetError(message, tag)
    tag = (tag) and "["..tag.."]" or ""

    ErrorNoHalt("[Minsk]", tag, " "..message..".", "\n")
end