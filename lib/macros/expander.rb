module Macros

  class Expander
    include Sexp

    def initialize(macros)
      @macros = macros
    end

    def macroexpand(sexp)
      treemap(sexp, &method(:macroexpand_1))
    end

    def macroexpand_1(node)
      if macro_block?(node)
        macro = seval @macros[sfind(node, [:block, 0, :send, 1])]
        args  = collect_args(node)
        block = sfind(node, [:block, 2])
        macro.call(*args, block)
      elsif macro_send?(node)
        macro = seval @macros[sfind(node, [:send, 1])]
        args  = collect_args(node)
        macro.call(*args)
      else
        node
      end
    end

    # foo(1,2) { some_more_code }
    #
    #   (block
    #     (send nil :foo
    #       (int 1)
    #       (int 2))
    #     (args)
    #     (send nil :some_more_code)))
    def macro_block?(node)
      # send with block, target is implicit self
      smatch?(node, s(:block, s(:send, nil))) &&
        # known macro
        @macros.key?(sfind(node, [:block, 0, :send, 1]))
    end

    # foo(1,2)
    #
    #   (send nil :foo
    #     (int 1)
    #     (int 2))
    def macro_send?(node)
      smatch?(node, s(:send, nil)) && @macros.key?(sfind(node, [:send, 1]))
    end

    def collect_args(node)
      if node.type == :block
        node = sfind(node, [:block, 0])
      end
      node.children.drop(2)
    end
  end

end
