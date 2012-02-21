#! /usr/bin/env ruby

require File.dirname(__FILE__) + '/../../../spec_helper'

describe "the array_del function" do

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("array_del").should == "function_array_del"
  end

  it "should raise a ParseError if there is less than 2 arguments" do
    lambda { @scope.function_array_del(["foo"]) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there is more than 2 arguments" do
    lambda { @scope.function_array_del(["foo", "bar", "gazonk"]) }.should( raise_error(Puppet::ParseError))
  end

  it "should remove an item if it's present" do
    result = @scope.function_array_del(['a','b'],'b')
    result.should(eql(['a']))
  end

  it "should do nothing if an item is not present" do
    result = @scope.function_array_del(['a','b'],'c')
    result.should(eql(['a','b']))
  end

  it "should leave the argument untouched" do
    a = ['a','b']
    result = @scope.function_array_del(a,'b')
    a.should(eql(['a','b']))
  end

end
