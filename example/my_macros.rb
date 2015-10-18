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

  def debug(arg1, arg2)
    s(:begin, *[arg1, arg2].map { |a| s(:send, nil, :puts, a) })
  end
end
