Facter.add("serversecret") do
        setcode do
                %x{cat /etc/bc-secret 2> /dev/null || (uuidgen | tee /etc/bc-secret)}.chomp
        end
end

