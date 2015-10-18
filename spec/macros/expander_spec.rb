require_relative '../../lib/macros'

RSpec.describe Macros::Expander do
  include Macros::Sexp

  let(:macro) { Macros.parse("
-> ast {
  S = Macros::Sexp
  S.treemap(ast) do |node|
    if S.smatch? node, s(:send, nil, :output)
      s(:send, nil, :puts, *node.children.drop(2))
    else
      node
    end
  end
}")}


  subject { described_class.new(foo: macro) }

  describe '#macro_block?' do
    specify do
      expect(subject.macro_block?(Macros.parse("foo { bar }"))).to be true
    end
  end

  describe '#macroexpand_1' do
    specify do
      expect(subject.macroexpand_1(Macros.parse("foo { output 'x' ; output 'y' }")))
        .to eql s(:begin,
                  s(:send, nil, :puts,
                    s(:str, "x")),
                  s(:send, nil, :puts,
                    s(:str, "y")))
    end
  end
end
