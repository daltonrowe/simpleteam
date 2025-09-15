class SlackUser < ApplicationRecord
  belongs_to :user
  belongs_to :slack_installation
end
