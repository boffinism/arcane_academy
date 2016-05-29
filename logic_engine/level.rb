module LogicEngine
  class Level
    def self.retrieve(level_number = 1)
      LogicEngine.const_get("Level#{level_number}").new
    end
  end
end
