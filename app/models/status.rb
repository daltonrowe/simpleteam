class Status < ApplicationRecord
  belongs_to :user
  belongs_to :team
  # TODO: use guids
end
