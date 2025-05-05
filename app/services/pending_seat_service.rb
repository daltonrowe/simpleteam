class PendingSeatService
  def initialize(emails:)
    @emails = emails
  end

  attr_accessor :emails

  def create
    prepared_addresses
  end

  private

  def prepared_addresses
    emails.gsub(/\s+/, "").split(",")
  end
end
