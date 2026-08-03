require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "all_teams lists a team once when the owner also holds a seat on it" do
    user = users(:owner)
    team = teams(:basic)
    Seat.create!(user:, team:)

    assert_equal 1, user.all_teams.count { |t| t == team }
    assert_equal user.all_teams.length, user.all_teams.uniq.length
  end
end
