module LogicEngine
  module Tomes
    class TreeLore
      extend Arcana::Tome
      type :arboria, -> { Things::Tree.all }
      selector :minimis, -> (t) { t.where(size: :small) }
      selector :medimal, -> (t) { t.where(size: :medium) }
      action :gorgal, -> (rs, o) { o.update_all(size: rs[:size]) if rs[:size] }
      refinement :grandis, -> (rs) { rs[:size] = :large }
    end
  end
end