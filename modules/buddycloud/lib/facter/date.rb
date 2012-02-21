Facter.add("datetime") do
        setcode do
                %x{/bin/date +%Y%M%d%H%M}.chomp
        end
end

