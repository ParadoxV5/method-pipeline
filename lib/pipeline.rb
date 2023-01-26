require_relative 'pipeline/version'

module Pipeline; refine Object do
  def then_call(prc = nil) = self.then(&prc)
  def !(*prcs)
    if prcs.empty?
      super
    else
      prcs.reduce(self) { _1.then_call(_2) }
    end
  end
end end
