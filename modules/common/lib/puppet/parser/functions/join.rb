Puppet::Parser::Functions::newfunction(
  :join,
  :type => :rvalue,
  :doc => "Joins the values of the array in arg1 with the string in arg2

    Example: join(['a','b'],',') -> 'a,b'"
) do |args|
  raise Puppet::ParseError, 'join() needs two arguments' if args.length != 2
  args[0].to_a.join(args[1])
end
