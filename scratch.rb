require '/home/arne/projects/macros/lib/macros'

code = %q{
Macros do
  def foo(param1_ast, param2_ast, &block_ast)
    inside_macro_1(param1_ast, param2_ast, block_ast)
    inside_macro_2(param1_ast, param2_ast, block_ast)
  end

  def bar(a,b)
    inside_macro_1(param1_ast, param2_ast, block_ast)
    inside_macro_2(param1_ast, param2_ast, block_ast)
  end
end

foo(1, 2) do |x|
  some_more_code
end

}

include Macros::Sexp

tree = Parser::CurrentRuby.parse(code)

dm = tree.children.first # !> assigned but unused variable - dm
#p sfind(dm, [:block, 0, :send, 2, 1])

#puts Macros::Compiler.new.collect_defmacros(Parser::CurrentRuby.parse(code))

p Parser::CurrentRuby.parse(code).children.last
# >> (block
# >>   (send nil :foo
# >>     (int 1)
# >>     (int 2))
# >>   (args
# >>     (arg :x))
# >>   (send nil :some_more_code))
