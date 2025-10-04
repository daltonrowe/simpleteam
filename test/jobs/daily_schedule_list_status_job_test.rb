require "test_helper"

class DailyScheduleListStatusJobTest < ActiveJob::TestCase
  setup do
    @slack_installation = slack_installations(:default)
    @slack_team = teams(:slack_team)
  end

  test "schedules list status job for each slack installation" do
    DailyScheduleListStatusJob.perform_now
    assert_enqueued_with(job: SlackListStatusJob, args: [ @slack_team.id ], at: Time.parse("09:00 UTC"))
  end
end
