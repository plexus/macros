module Macros

  module Sexp
    extend self

    def s(type, *children)
      Parser::AST::Node.new(type, children)
    end

    # Traverse into sexp by type and child position
    def sfind(sexp, specs)
      specs.inject(sexp) do |node, spec|
        return NotFound if node.nil?

        if spec.is_a?(Symbol) && node.type == spec
          node
        elsif spec.is_a?(Integer) && node.children.length > spec
          node.children[spec]
        elsif spec.is_a?(Array)
          node.children.grep(AST::Node)
            .flat_map { |child| sfind(child, spec) }
            .reject { |child| child == NotFound }
        else
          return NotFound
        end
      end
    end

    def treemap(node, &block)
      block.call(treemap_1(node, &block))
    end

    def treemap_1(node, &block)
      s(node.type,
        *node.children.map do |child|
          next child unless child.is_a?(AST::Node)
          treemap_1(block.call(child), &block)
        end
       )
    end

    def treefilter(node, &block)
      acc = []
      acc << node if block.call(node)
      treemap(node) { |n| acc << n if block.call(n) ; n}
      acc.freeze
    end

    def smatch?(node, pattern)
      return false unless node.type == pattern.type
      pattern.children.zip(node.children).all? do |a, b|
        a == b || node?(a) && smatch?(b, a)
      end
    end

    def node?(node)
      node.is_a?(AST::Node)
    end

    def seval(ast)
      eval(Macros.unparse(ast))
    end
  end

end
