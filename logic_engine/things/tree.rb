module LogicEngine
  module Things
    class Tree < BaseThing
      def to_s
        "a #{attributes[:size]} tree"
      end
    end
  end
end