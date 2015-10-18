require_relative '../../lib/macros'

RSpec.describe Macros::Sexp do
  include described_class

  let(:block_node) {
    s(:block,
      s(:send, nil, :foo,
        s(:int, 1),
        s(:int, 2)),
      s(:args,
        s(:arg, :x)),
      s(:send, nil, :some_more_code))
  }

  describe '#smatch?' do
    specify do
      expect(smatch?(s(:send, nil, :foo), s(:send))).to be true
    end

    specify do
      expect(
        smatch?(
          s(:send, nil, :foo),
          s(:send, nil, :bar))).to be false
    end

    specify do
      expect(
        smatch?(
          block_node,
          s(:block, s(:send, nil, :foo))
        )
      ).to be true
    end
  end

  describe '#treefilter' do
    specify do
      expect(treefilter(block_node) { |n| smatch?(n, s(:send))})
        .to eql [
              s(:send, nil, :foo, s(:int, 1), s(:int, 2)),
              s(:send, nil, :some_more_code)]
    end
  end
end
