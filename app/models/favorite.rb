class Favorite < ApplicationRecord
  belongs_to :port
  belongs_to :user
end
