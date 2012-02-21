Facter.add("datetime") do
        setcode do
                %x{/bin/date +%s}.chomp
        end
end

