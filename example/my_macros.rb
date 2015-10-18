Macros do
  def macro1(ast)
    treemap(ast) do |node|
      if smatch? node, s(:send, nil, :output)
        s(:send, nil, :puts, *node.children.drop(2))
      else
        node
      end
    end
  end
end
