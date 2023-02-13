The `Pipeline` Refinement module bundles a couple of methods that together
builds a clean and clever pure-Ruby solution to rightward method piping.

A reminder that Refinement modules are activated with `using` and lasts only
for that module/class block or file (if top-level). See: `refinements.rdoc`
([on docs.ruby-lang.org](https://docs.ruby-lang.org/en/master/syntax/refinements_rdoc.html))


## Synopsis Example

Here’s the example from `Kernel#then` straight off the Ruby 3.2 docs:
```ruby
require 'open-uri'
require 'json'

construct_url(arguments).
  then {|url| URI(url).read }.
  then {|response| JSON.parse(response) }
```

With the new Refinement active: (Oh gosh, this looks like a brand new language!)
```ruby
using Pipeline

arguments.then_pipe(
  `construct_url`,
  `URI`,
  :read,
  JSON.`:parse
)
```


## Walkthrough Introduction

We traditionally pipe methods leftwards as nesting arguments:
```ruby
def parse(string) = …
do_stuff = ->(a){ … }

# This is even more incomprehensible if omitting round parentheses (poetry mode)
STDOUT.puts(     # different-scope method
  do_stuff.call( # Proc
    parse(       # same-scope method
      input
    )
  )
)
```

The trending Rightward Operations improve readability –
especially for long expressions like that one –
by matching English’s left-to-right writing direction.
We currently accomplish this with `Object#then` and *light-weight Procs*:
```ruby
input
  .then { parse _1 }        
  .then { do_stuff.call _1 }
  .then { STDOUT.puts _1 } 
```

We alternatively can deconstruct the corresponding `#to_proc` objects with `&`:
```ruby
# heck, these `method` calls can't even go poetry mode
input
  .then(&method(:parse))
  .then(&do_stuff)
  .then(&STDOUT.method(:puts))
```

The Refinement module `Pipeline` introduces `Object#then_pipe` to
eliminate repeating `then(&…)`. It gives a beautiful vibe similar
to that of some other languages’ (namely Elixir) Pipe Operator `|>`.
```ruby
using Pipeline

input.then_pipe(
  method(:parse),
  do_stuff,
  STDOUT.method(:puts)
)
```

However, unlike Lisp-1 languages like Python or JavaScript,
Lisp-2’s like Ruby face the additional challenge of namespace disambiguation.
Ruby solves it with the reflection methods `method` & co., but, as seen above,
their verbosity makes them eyesores inside otherwise elegant syntax.
Therefore, `Pipeline` further improves the grammar by replacing the `` `…` ``
syntax (powered by `` Kernel#` ``) with an `alias` of the bulky `Object#method`:
```ruby
using Pipeline

input.then_pipe(
  `parse`,
  do_stuff,
  STDOUT.`:puts
)
```


## Why `` #` ``?

* It is the backend of both `` `…` `` and `%x{…}` syntaxes –
  ``self.`:meth`` can instead be `%x:meth:` or `` `meth` ``.
* A Ruby script is not (strictly) a Shell script. User system differences aside,
  Summoning subshells should be the last resort when there’re no Ruby/Gem APIs.
  Dedicating the `` ` `` char to subshells is a waste;
  e.g., you typically see `$(…)` in bash rather than `` `…` ``.
  `Pipeline` assigns `` #` `` a new and recurrent purpose; it also `alias`es
  the original `` Kernel#` `` to `Object#sys` in the event of its preference.


## Limitations

* **The new `` #` `` ignores method visibilities (`private` or `protected`).**
  * This is a Ruby limitation – one can bypass visibilities with
    `Object#method` and `Method#call` regardless of this Refinement.
    A security engineer would love reflection APIs that respect visibilities.
  * The original design for the new `` #` `` is to match `Object#public_method`,
    but it couldn’t retrieve oneself’s own `private` and `protected` methods.
* **`#then_pipe` cannot pass additional arguments each step.**
  * The current `Object#then`-based solution is as good as it can get –
    There are no syntactical benefits to avoid a block whist calling rightwards.
    Hey, (inner) blocks are accepted too, unlike `#then_pipe`.
    ```ruby
    # a lambda – a Proc with fixed arities, unlike regula-o’ procs (or blocks)
    do_stuff = ->(a, o, z){ … }
    
    # This essentially wraps `do_stuff` in a one-arg block (as in F#).
    # The `_1` resembles Hack’s special pipe variable `$$`.
    o.then { do_stuff.(a, _1, z) }
    # The previous, adapted for `then_pipe`
    o.then_pipe ->{ do_stuff.(a, _1, z) }
    # Pure-rightward solution
    [a, o, b].then { do_stuff.(*_1) }
    ```


## Miniblog: My insights on a Pipeline Operator for Ruby

https://gist.github.com/ParadoxV5/4f563e609decbdac07d40e5f2dead751


## License

Copyright (c) 2023 ParadoxV5

Licensed under the [Universal Permissive License v 1.0](https://oss.oracle.com/licenses/upl/)
