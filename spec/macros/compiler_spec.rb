require_relative '../../lib/macros'

RSpec.describe Macros::Compiler do
  include Macros::Sexp

  let(:code) {
    %q{
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
    }
  }

  let(:ast) { Macros.parse(code) }

  describe '#collect_defmacros' do
    specify do
      expect(subject.collect_defmacros(ast)).to eql(
        foo: s(:block,
                s(:send, nil, :lambda),
                s(:args,
                  s(:arg, :param1_ast),
                  s(:arg, :param2_ast),
                  s(:arg, :block_ast)),
                s(:begin,
                  s(:send, nil, :inside_macro_1,
                    s(:lvar, :param1_ast),
                    s(:lvar, :param2_ast),
                    s(:lvar, :block_ast)),
                  s(:send, nil, :inside_macro_2,
                    s(:lvar, :param1_ast),
                    s(:lvar, :param2_ast),
                    s(:lvar, :block_ast)))),
         bar: s(:block,
                s(:send, nil, :lambda),
                s(:args,
                  s(:arg, :a),
                  s(:arg, :b)),
                s(:begin,
                  s(:send, nil, :inside_macro_1,
                    s(:send, nil, :param1_ast),
                    s(:send, nil, :param2_ast),
                    s(:send, nil, :block_ast)),
                  s(:send, nil, :inside_macro_2,
                    s(:send, nil, :param1_ast),
                    s(:send, nil, :param2_ast),
                    s(:send, nil, :block_ast)))))
    end
  end

  describe '#macros_node?' do
    it 'will match "Macros" blocks' do
      expect(subject.macros_node? Macros.parse('Macros { foo }')).to be true
    end
  end

  describe ''
end
