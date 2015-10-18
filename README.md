# Macros

Macros for Ruby

``` ruby
defmacro foo(param1_ast, param2_ast, &block_ast) do
  build_new_ast(param1_ast, param2_ast, block_ast)
end

foo(1, 2) do
  some_more_code
end
```

© Arne Brasseur 2015

## License

Eclipse Public License
