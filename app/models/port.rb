class Port < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_name,
    against: [ :name, :slug ],
    using: {
      tsearch: { prefix: true }
    }
end
