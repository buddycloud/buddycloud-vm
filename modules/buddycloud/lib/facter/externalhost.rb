Facter.add("externalhost") do
        setcode do
                %x{curl -s http://api.externalip.net/hostname/ 2> /dev/null}.chomp
        end
end

