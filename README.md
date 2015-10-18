# Macros

Macros for Ruby

## Install

```
gem install macros
```

## Usage

Any source file that contains macro definitions, or that requires macro
expansion, should be loaded with `Macros.require`.

``` ruby
require 'macros'

Macros.require 'my_macros'
Macros.require 'my_code_using_macros'
```

Macros look like normal method definitions, but they are defined inside a
`Macros do ; end` block.

``` ruby
# my_macros.rb

Macros do
  # Replace the +output+ method with the +puts+ method
  def with_output(ast)
    treemap(ast) do |node|
      if smatch? node, s(:send, nil, :output)
        s(:send, nil, :puts, *node.children.drop(2))
      else
        node
      end
    end
  end
end
```

Now this code

``` ruby
# my_code_using_macros.rb

with_output do
  output "foo"
  output "bar"
end
```

Will be transformed into

``` ruby
puts "foo"
puts "bar"
```

## AST basics

AST stands for Abstract Syntax Tree, a way of representing the structure of code
as data.

The macro will receive an instance of `Parser::AST::Node`, and must return an
instance of `Parser::AST::Node`. A `Node` consists of a `type` and zero or more
`children`. You can use `Macros.parse` and `Macros.unparse` to experiment.

For example

```ruby
obj.do_thing(x, y)
```

parses to

```ruby
s(:send,
  s(:send, nil, :obj), :do_thing,
  s(:send, nil, :x),
  s(:send, nil, :y))
```

## Helpers

Inside the macro definition the following convenience functions are available:

### `s(type, *children)`

Construct an AST node of given type, with specific children.

### `node?(n)`

Is the given object an AST node?

### `treemap(node, &tranform)`

Similar to `Enumerable#map`, but performs a full tree walk, passing any
`AST::Node` to the block.

### `treefilter(node, &pred)`

Returns an array of any node in the tree that satisfies the predicate

### `sfind(node, spec)`

`spec` is an Array of symbols, integers, and arrays. It is used a bit like XPath
or CSS locators.

``` ruby
node = s(:def, :a_name, s(:args, s(:arg, :x), s(:arg, :y)))
sfind(node, [:def, 1, :args, [:arg, 0]])
# => [:x, y]
```

### `smatch?(node, pattern)`

Checks if the node matches the "pattern"

``` ruby
node = s(:def, :a_name, s(:args, s(:arg, :x), s(:arg, :y)))
smatch?(node, s(:def, :a_name))
# => true
```

## Is this a joke?

Well, it works, but it's a toy. Working with Ruby syntax trees is pretty
awkward, and macros can easily lead to a mess. You have been warned!

## License

© Arne Brasseur 2015

Eclipse Public License
