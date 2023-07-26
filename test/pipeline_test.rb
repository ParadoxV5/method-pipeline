# frozen_string_literal: true
require 'minitest/autorun'
require 'pipeline'
describe Pipeline do
  
  it 'is a module that refines the Object class and only that' do
    assert_kind_of Module, Pipeline
    assert_equal [Object], Pipeline.refinements.map(&:refined_class)
    assert_empty Pipeline.instance_methods
    assert_empty Pipeline.private_instance_methods
  end
  using Pipeline
  
  describe '`#method` shorthand' do
    it 'overrides `backticks` with a public delegate to #method or equivalent' do
      o = Object.new
      def o.echo = # do nothing for a phony name
      assert_equal o.method(:echo), o.`('echo')
      assert_equal o.method(:__id__), o.`(:__id__) 
      pass if o.`(:initialize)
    end
    
    it 'renames Object#` to Object#sys' do
      assert_equal :`, Object.instance_method(:sys).original_name
      random_string = Kernel.rand.to_s
      assert_equal random_string, sys("echo #{random_string}").chomp
    end
  end
  
  it 'defines Object#then_pipe that chain-calls each of the given _ToProc’s  with the receiver as the first arg' do
    receiver, proc_return = Object.new, Object.new
    # It is neither required nor forbidden for `#then_pipe` to also
    # pass their blocks to their _ToProc arg(s) (block-ception Lol)
    a_proc = proc do|arg|
      assert_same receiver, arg
      proc_return
    end
    a_proc_like = Object.new
    a_proc_like.define_singleton_method(:to_proc) { a_proc }
    assert_same proc_return, receiver.then_pipe(a_proc_like)
    receiver.then_pipe(a_proc, ->{ assert_same proc_return, _1 })
  end
end
