module LogicEngine
  module Things
    class Tree < BaseThing
      def description
        "a #{attributes[:size]} tree"
      end
    end
  end
end