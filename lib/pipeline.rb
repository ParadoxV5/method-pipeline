require_relative 'pipeline/version'

module Pipeline; refine Object do
  def then_pipe(*procs) = procs.reduce(self) { _1.then(&_2) }
  
  alias sys `
  alias ` public_method
end end
