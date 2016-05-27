module LogicEngine
  class SelectedWord
    attr_reader :word, :id

    def self.make(word)
      @counter ||= 0
      @counter += 1
      new(word, @counter)
    end

    def initialize(word, id)
      @word = word
      @id = id
    end
  end
end