Puppet::Parser::Functions::newfunction(
  :uniq_flatten,
  :type => :rvalue,
  :doc => "Flattens an array and make it uniq

    Example: uniq_flatten([['a','b'],'a']) -> ['a','b']"
) do |args|
  raise Puppet::ParseError, 'uniq_flatten() needs one arguments' if args.length != 1
  args[0].to_a.flatten.collect(&:to_s).uniq
end
