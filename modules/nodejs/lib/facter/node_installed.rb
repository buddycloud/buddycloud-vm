Facter.add("node_installed") do
  node_binary = "/opt/node/bin/node"

  setcode do
    File.exists? node_binary
  end
end
