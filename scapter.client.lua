local _ENV = getfenv()

while wait(1) do
    xpcall(function() return game.somerandomerror end, function()
        for level = 0, 5 do
            if getfenv(level) ~= _ENV then			
                while true do end
            end
        end
    end)
end