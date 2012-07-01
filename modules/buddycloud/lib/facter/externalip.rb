Facter.add("externalip") do
        setcode do
                %x{curl -s http://api.externalip.net/ip/ 2> /dev/null}.chomp
        end
end

