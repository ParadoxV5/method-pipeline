# The `Pipeline` Refinement module bundles a couple of methods that together
# builds a clean and clever pure-Ruby solution to rightward method piping.
# 
# Consult [the README](index.html) for examples.
# 
# @!method then_pipe(*procs)
#   Yield `self` to the first `Proc` (or a `#to_proc` object) argument,
#   then the result to the second argument, and so forth.
#   ```ruby
#   construct_url(arguments).then_pipe(
#     proc {|url| URI(url).read },
#     JSON.public_method :parse
#   )
#   ```
#   @param procs `Proc` or `#to_proc` objects to call
#   @return the result of calling the last argument, or `self` if none given.
# 
# @!method sys(command)
#   Provides a replacement alias for `` Kernel#` ``, the subshell method.
#   @see #`
# 
# @!method `(name)
#   Aliases `Object#method`.
#   ```ruby
#   m = 42.` :to_s
#   m.call #=> "42"
#   ```
#   The `` ` `` method is the backend to the `` `…` `` and `%x{…}` syntaxes.
#   ```ruby
#   class MyArray < Array
#     using Pipeline
#     def fetch_values(*indices)
#       indices.map(&`[]`)
#     end
#   end
#   a = MyArray.new(['A', 'B', 'C'])
#   a.fetch_values 1, 3 #=> ["B", nil]
#   ```
#   @see #sys

module Pipeline; refine Object do
  def then_pipe(*procs) = procs.reduce(self) { _1.then(&_2) }
  
  alias sys `
  alias ` method
end end
