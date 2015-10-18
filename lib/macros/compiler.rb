module Macros

  class Compiler
    include Sexp

    def collect_defmacros(sexp)
      Hash[
        treefilter(sexp, &method(:macros_node?)).flat_map(&method(:compile_macros))
      ]
    end

    def reject_defmacros(node)
      if macros_node?(node)
        s(:begin)
      else
        s(node.type, *node.children.reject(&method(:macros_node?)))
      end
    end

    def macros_node?(node)
      smatch?(node, s(:block, s(:send, nil, :Macros)))
    end

    def compile_macros(node)
      treefilter(node) { |n| smatch?(n, s(:def)) }.map(&method(:compile_macro))
    end

    def compile_macro(node)
      name, args, body = extract_macro(node)
      [name,
       s(:block,
         s(:send, nil, :lambda),
         s(:args, *args.map { |a| s(:arg, a) }),
         body)]
    end

    def extract_macro(node)
      name = sfind(node, [0])

      args = sfind(node, [:def, 1, :args, [0]])
      body = sfind(node, [:def, 2])

      [name, args, body]
    end

  end
end
