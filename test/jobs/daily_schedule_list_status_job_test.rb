require "test_helper"

class DailyScheduleListStatusJobTest < ActiveJob::TestCase
  setup do
    @slack_installation = slack_installations(:default)
    @slack_team = teams(:slack_team)
  end

  test "schedules list status job for each slack installation" do
    travel_to Time.utc(2026, 4, 27, 0, 0) do
      DailyScheduleListStatusJob.perform_now
      assert_enqueued_with(job: SlackListStatusJob, args: [ @slack_team.id ], at: Time.utc(2026, 4, 27, 9, 0))
    end
  end
end
