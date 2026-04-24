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

  test "times are in the team's time zone" do
    team = teams(:basic)

    assert_equal "Central Time (US & Canada)", team.end_of_day.time_zone.name
    assert_equal "Central Time (US & Canada)", team.notification_time.time_zone.name
  end

  test "notification_time honors daylight savings" do
    team = teams(:basic) # Central Time
    team.update!(notification_time: Time.utc(2000, 1, 1, 9, 30))

    travel_to Time.utc(2026, 7, 1, 12, 0) do
      assert_equal "14:30:00", team.notification_time.utc.strftime("%H:%M:%S")
    end

    travel_to Time.utc(2026, 1, 15, 12, 0) do
      assert_equal "15:30:00", team.notification_time.utc.strftime("%H:%M:%S")
    end
  end
end
