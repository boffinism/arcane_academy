module LogicEngine
  module Tomes
    class TreeLore
      extend Arcana::Tome
      type :arboria, -> { Things::Tree.all }, 'All trees'
      selector :minimis, -> (t) { t.where(size: :small) }, 'that are small'
      selector :medimal, -> (t) { t.where(size: :medium) }, 'that are medium sized'
      action :gorgal, -> (rs, o) { o.update_all(size: rs[:size]) if rs[:size] }, 'change size to'
      refinement :grandis, -> (rs) { rs[:size] = :large }, 'large'
    end
  end
end