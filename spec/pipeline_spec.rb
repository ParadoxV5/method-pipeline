# frozen_string_literal: true
require 'pipeline'
RSpec.describe Pipeline do
  
  it 'is a module that refines the Object class and only that' do
    expect(Pipeline).to be_a(Module)
    expect(Pipeline.refinements.map(&:refined_class)).to contain_exactly(Object)
    expect(Pipeline.instance_methods).to be_empty
    expect(Pipeline.private_instance_methods).to be_empty
  end
  
  using Pipeline
  
  
  describe '`#then_call` and `#!`' do
    it 'defines Object#then_call that invokes the given _ToProc with the receiver as arg' do
      expect(Object).to be_public_method_defined(:then_call)
      receiver, proc_return = double('receiver'), double('return of proc')
      # It is neither required nor forbidden for `#then_call` and `#!` to
      # also pass their blocks to their _ToProc arg(s) (block-ception Lol)
      a_proc = proc do|arg|
        expect(arg).to be receiver
        proc_return
      end
      expect(receiver.then_call(a_proc)).to be proc_return
      expect(receiver.then_call(double('a_proc_like', to_proc: a_proc))).to be proc_return
    end
    
    it 'does not hide o.! (with no args)' do
      expect([true, false, nil, 0, Object.new].map(&:!)).to eq([false, true, true, false, false])
    end
    
    it 'overrides Object#! with a vararg method that evaluates `o.!(f1, f2, …) as `o.then_call(f1).then_call(f2)…`' do
      expect(Object.public_method(:!).arity).to be(-1)
      r1 = double('o.then_call(f1)', then_call: true)
      o = double('o', then_call: r1)
      f1, f2 = double('f1'), double('f2')
      o.!(f1, f2)
      expect(o).to have_received(:then_call).with(f1).once
      expect(r1).to have_received(:then_call).with(f2).once
    end
  end
  
  
  describe '`#method` shorthand' do
    it 'overrides `backticks` with a public delegate to #public_method or equivalent' do
      expect(Object).to be_public_method_defined(:`)
      o = double(echo: false)
      expect(o.`('echo')).to eq(o.public_method(:echo))
      expect(o.`('__id__')).to eq(o.public_method(:__id__))
      expect { o.`('initialize') }.to raise_error(NameError)
    end
    
    it 'renames Object#` (inherited from Kernel#`) to Object#sys' do
      expect(Object).to be_private_method_defined(:sys)
      expect(Object.instance_method(:sys)).to eq(Kernel.instance_method(:`))
    end
  end
  
end
