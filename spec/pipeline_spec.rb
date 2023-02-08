# frozen_string_literal: true
require 'pipeline'
RSpec.describe Pipeline do
  
  it 'is a module that refines the Object class and only that' do
    expect(Pipeline).to be_a Module
    expect(Pipeline.refinements.map(&:refined_class)).to contain_exactly(Object)
    expect(Pipeline.instance_methods).to be_empty
    expect(Pipeline.private_instance_methods).to be_empty
  end
  using Pipeline
  
  describe '`#method` shorthand' do
    it 'overrides `backticks` with a public delegate to #method or equivalent' do
      o = double(echo: false)
      expect(o.`('echo')).to eq o.method(:echo)
      expect(o.`(:__id__)).to eq o.method(:__id__)
      expect { o.`(:initialize) }.not_to raise_error
    end
    
    it 'renames Object#` to Object#sys' do
      expect(Object.instance_method(:sys).original_name).to eq :`
      seed = Kernel.rand.to_s
      expect(sys("echo #{seed}").chomp).to eq seed # verify functionality
    end
  end
  
  it 'defines Object#then_pipe that chain-calls each of the given _ToProc’s  with the receiver as the first arg' do
    receiver, proc_return = double('receiver'), double('return of proc')
    # It is neither required nor forbidden for `#then_pipe` to also
    # pass their blocks to their _ToProc arg(s) (block-ception Lol)
    a_proc = proc do|arg|
      expect(arg).to be receiver
      proc_return
    end
    expect(receiver.then_pipe(double('a_proc_like', to_proc: a_proc))).to be proc_return
    receiver.then_pipe(a_proc, ->{ expect(_1).to be proc_return })
  end
end
