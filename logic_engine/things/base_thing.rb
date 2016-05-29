module LogicEngine
  module Things
    class BaseThing
      include Thinginess::Thingish

      def to_s
        (changed? && "#{description} (changed)") || description
      end

      private

      def description
        'a thing'
      end
    end
  end
end