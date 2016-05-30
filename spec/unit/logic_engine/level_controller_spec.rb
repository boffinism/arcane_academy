RSpec.describe LogicEngine::LevelController do
  subject { LogicEngine::LevelController.new(3) }

  let(:level) do
    double :level,
           tomes: tomes
  end

  let(:tomes) { [] }

  before do
    stub_const('LogicEngine::Levels::Level3',
               double(:level_class,
                      new: level))
  end

  describe '#when_message' do
    it 'accepts a block' do
      expect { subject.when_message { true } }.not_to raise_error
    end
  end

  describe '#things' do
    it "passes on the appropriate Level's things" do
      expect(level).to receive(:things).and_return :things
      expect(subject.things).to eq :things
    end
  end

  describe '#challenge_text' do
    it "passes on the appropriate Level's challenge text" do
      expect(level).to receive(:challenge_text).and_return :challenge_text
      expect(subject.challenge_text).to eq :challenge_text
    end
  end

  describe '#challenge_met?' do
    it "passes on the appropriate Level's challenge met check" do
      expect(level).to receive(:challenge_met?).and_return :challenge_met?
      expect(subject.challenge_met?).to eq :challenge_met?
    end
  end

  describe '#available_word_definitions' do
    it "passes on the appropriate Level's word definitions" do
      expect(level).to receive(:available_word_definitions).and_return :defs
      expect(subject.available_word_definitions).to eq :defs
    end
  end

  describe '#select_word' do
    before do
      expect(level).to receive(:available_words)
        .and_return([:available, :available2])
    end

    it 'adds available words to selected_words' do
      expect(LogicEngine::SelectedWord).to receive(:make)
        .with('available')
        .and_return :selected_word

      subject.select_word 'available'

      expect(subject.selected_words).to eq [:selected_word]
    end

    it 'sends a message if word is unavailable' do
      message_called = false
      subject.when_message do |message|
        message_called = true
        expect(message).to eq "'unavailable' is not an available word"
      end

      subject.select_word 'unavailable'

      expect(message_called).to eq true
    end
  end

  describe '#delete_word' do
    it 'removes a selected word' do
      expect(level).to receive(:available_words)
        .and_return([:available, :available2])
      expect(LogicEngine::SelectedWord).to receive(:make)
        .with('available')
        .and_return :selected_word

      subject.select_word 'available'
      subject.delete_word(:selected_word)

      expect(subject.selected_words).to eq []
    end
  end

  describe '#cast_spell' do
    let(:demon) { double :demon, cast: nil, assimilate: nil }
    let(:tomes) { [:tome_1, :tome_2] }

    before { expect(Arcana::Demon).to receive(:new).and_return demon }

    it 'resets change tracking' do
      subject.when_message { |_m| nil }
      expect(LogicEngine::Things::BaseThing).to receive(:reset_change_tracking)
      subject.cast_spell
    end

    it "calls `cast` on a demon that has assimilated the level's tomes" do
      expect(demon).to receive(:assimilate).with :tome_1
      expect(demon).to receive(:assimilate).with :tome_2
      expect(demon).to receive(:cast)
      subject.when_message { |_m| nil }
      subject.cast_spell
    end

    it 'calls `cast` with a string made up of selected words' do
      subject.when_message { |_m| nil }
      allow(level).to receive(:available_words)
        .at_least(1)
        .and_return([:selected, :words])

      subject.select_word 'selected'
      subject.select_word 'words'

      expect(demon).to receive(:cast).with('selected words')
      subject.cast_spell
    end

    context '(when spell cast successfully)' do
      it 'sends a success message' do
        message_sent = false
        subject.when_message do |message|
          message_sent = true
          expect(message).to eq 'Your spell is cast!'
        end

        subject.cast_spell
        expect(message_sent).to eq true
      end

      it 'empties out the selected word array' do
        subject.when_message { |_m| nil }
        allow(level).to receive(:available_words)
          .at_least(1)
          .and_return([:selected, :words])

        subject.select_word 'selected'
        subject.select_word 'words'

        subject.cast_spell

        expect(subject.selected_words).to eq []
      end
    end

    context '(when spell casting fails)' do
      it 'sends an error message' do
        expect(demon).to receive(:cast).and_raise StandardError
        message_sent = false
        subject.when_message do |message|
          message_sent = true
          expect(message).to eq 'That spell makes no sense!'
        end

        subject.cast_spell
        expect(message_sent).to eq true
      end
    end
  end
end
