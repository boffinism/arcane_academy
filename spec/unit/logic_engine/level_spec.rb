RSpec.describe LogicEngine::Level do
  describe '.retrieve' do
    it 'loads a level according to the number passed in' do
      stub_const('LogicEngine::Levels::Level17', Class.new)
      expect(LogicEngine::Levels::Level17).to receive(:new).and_return :level17
      expect(LogicEngine::Level.retrieve(17)).to eq :level17
    end
  end

  describe '#available_word_definitions' do
    subject { LogicEngine::Level.new }
    let(:definitions_1) { make_definitions [:available, :not_available] }
    let(:definitions_2) { make_definitions [:not_available_2, :available_2] }
    let(:tomes) do
      [make_tome(definitions_1),
       make_tome(definitions_2)]
    end

    it 'filters its Tome definitions by its available words' do
      expect(subject).to receive(:tomes)
        .and_return tomes

      expect(subject).to receive(:available_words)
        .at_least(1)
        .and_return([:available, :available_2])

      result = subject.available_word_definitions

      expect(result.length).to eq 2
      expect(result).to include(definitions_1[0])
      expect(result).to include(definitions_2[1])
    end
  end

  def make_tome(definitions)
    double :tome,
           definitions: definitions
  end

  def make_definitions(words)
    Array.new(words.count) do |index|
      double :definition,
             word: (words[index])
    end
  end
end
