module LogicEngine
  class Level
    def self.retrieve(level_number = 1)
      new(1)
    end

    def initialize(level_number)
      #TODO: Load dynamically or something
    end

    def tomes
      [Tomes::TreeLore]
    end

    def things
      @things ||= [Things::Tree.create(size: :small),
                   Things::Tree.create(size: :medium),
                   Things::Tree.create(size: :large)]

    end

    def challenge_text
      "Make all the trees large"
    end

    def challenge_met?
      Things::Tree.where(size: :large).count == Things::Tree.all.count
    end

    def available_words
      [:arboria, :minimis, :medimal, :gorgal, :grandis]
    end

  end
end