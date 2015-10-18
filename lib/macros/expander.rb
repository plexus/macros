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
      return node unless macro_block?(node)
      macro = seval @macros[sfind(node, [:block, 0, :send, 1])]
      body = sfind(node, [:block, 2])
      macro.call(body)
    end

    # foo(1,2) { some_more_code }
    #
    # >>   (block
    # >>     (send nil :foo
    # >>       (int 1)
    # >>       (int 2))
    # >>     (args)
    # >>     (send nil :some_more_code)))
    def macro_block?(node)
      # send with block
      node.type == :block &&
        # target is implicit self
        sfind(node, [:block, 0, :send, 0]).nil? &&
        # known macro
        @macros.key?(sfind(node, [:block, 0, :send, 1]))
    end
  end

end
