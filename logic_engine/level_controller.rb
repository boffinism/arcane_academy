module LogicEngine
  class LevelController
    def initialize(level_number=1)
      @level = Level.retrieve(level_number)
      Thinginess::Thing.clear_thing_register
      @selected_words = []
      @demon = Arcana::Demon.new
      @level.tomes.each do |tome|
        @demon.assimilate tome
      end
    end

    def when_message(&block)
      @notifier = block
    end

    def things
      @things ||= @level.things
    end

    def challenge_text
      @level.challenge_text
    end

    def challenge_met?
      @level.challenge_met?
    end

    def available_words
      @level.available_words
    end

    def selected_words
      @selected_words
    end

    def select_word(word)
      @selected_words << SelectedWord.make(word)
    end

    def delete_word(selected_word)
      @selected_words.delete(selected_word)
    end

    def cast_spell
      begin
        @demon.cast spell
      rescue StandardError
        @notifier.call "That spell makes no sense!"
        return
      end

      @notifier.call "Your spell is cast!"
      @selected_words = []
    end

    private

    def spell
      @selected_words.map(&:word).join(' ')
    end

  end
end