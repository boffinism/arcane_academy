module LogicEngine
  class Level
    def self.retrieve(level_number = 1)
      LogicEngine::Levels.const_get("Level#{level_number}").new
    end

    def available_word_definitions
      @available_word_definitions ||= begin
        all_definitions = tomes.map(&:definitions).flatten
        all_definitions.select { |d| available_words.include? d.word }
      end
    end

    def tomes
      raise NotImplementedError
    end

    def things
      raise NotImplementedError
    end

    def challenge_text
      raise NotImplementedError
    end

    def challenge_met?
      raise NotImplementedError
    end

    def available_words
      raise NotImplementedError
    end
  end
end
