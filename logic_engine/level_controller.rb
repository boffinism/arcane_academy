module LogicEngine
  class LevelController
    def initialize(level_number = 1)
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

    def available_word_definitions
      @level.available_word_definitions
    end

    attr_reader :selected_words

    def select_word(word)
      if @level.available_words.include? word.to_sym
        @selected_words << SelectedWord.make(word)
      else
        @notifier.call "'#{word}' is not an available word"
      end
    end

    def delete_word(selected_word)
      @selected_words.delete(selected_word)
    end

    def cast_spell
      Things::BaseThing.reset_change_tracking
      begin
        @demon.cast spell
      rescue StandardError
        @notifier.call 'That spell makes no sense!'
        return
      end

      @notifier.call 'Your spell is cast!'
      @selected_words = []
    end

    private

    def spell
      @selected_words.map(&:word).join(' ')
    end
  end
end
