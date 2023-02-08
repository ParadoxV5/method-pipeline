
module Pipeline; refine Object do
  def then_pipe(*procs) = procs.reduce(self) { _1.then(&_2) }
  
  alias sys `
  alias ` method
end end
