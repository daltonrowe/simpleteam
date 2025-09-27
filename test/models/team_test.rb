require "test_helper"

class TeamTest < ActiveSupport::TestCase
  test "converts to team time zone" do
    team = teams(:basic)
    central_time = DateTime.new(2000, 1, 1, 15, 0, 0, "-5:00")

    travel_to central_time do
      time_til_eod = team.end_of_day - Time.current
      time_til_notify = team.notification_time - Time.current

      assert_equal(time_til_eod, 44.minutes + 15.seconds)
      assert_equal(time_til_notify, 2.hours + 30.minutes)
    end
  end

  test "eod is in utc" do
    team = teams(:basic)

    assert(team.end_of_day.time_zone, "(GMT+00:00) UTC")
    assert(team.notification_time.time_zone, "(GMT+00:00) UTC")
  end
end
