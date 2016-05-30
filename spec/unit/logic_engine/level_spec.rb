RSpec.describe LogicEngine::Level do
  describe '.retrieve' do
    it 'loads a level according to the number passed in' do
      stub_const('LogicEngine::Levels::Level17', Class.new)
      expect(LogicEngine::Levels::Level17).to receive(:new).and_return :level17
      expect(LogicEngine::Level.retrieve(17)).to eq :level17
    end
  end
end
