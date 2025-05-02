module Team
  def self.table_name_prefix
    "team_"
  end

  belongs_to :user
  has_many :users, through: :team_seats
end
