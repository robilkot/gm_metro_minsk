util.AddNetworkString( "setr3dsky0" )
util.AddNetworkString( "setr3dsky1" )
function fSetr3dsky(ACTIVATOR,CALLER,state)
    if state == 0 then
        net.Start("setr3dsky0")
        net.Send(ACTIVATOR)
    else
        net.Start("setr3dsky1")
        net.Send(ACTIVATOR)
    end
end
