class Datum < ApplicationRecord
  belongs_to :team

  def content_keys
    self.content.keys
  end
end
