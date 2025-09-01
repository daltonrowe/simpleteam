class TeamUpdateService
  def initialize(team, update)
    @team = team
    # TODO: Symbolize keys so we can pass normal colon assigned hashes in
    @update = update.to_h
  end

  attr_accessor :team, :update

  def call
    sections = collect_sections
    end_of_day = collect_time("end_of_day")
    notifaction_time = collect_time("notifaction_time")
    metadata = collect_metadata

    valid_updates = { sections:, end_of_day:, notifaction_time:, metadata: }.compact

    @team.update(**valid_updates)
  end

  private

  def collect_sections
    incoming_sections = update.select { |key| key.include? "section_" }
    return unless incoming_sections

    sections = []

    incoming_sections.each_pair do |k, v|
      _, indexString, type = k.split("_")
      next if v.nil? || v.blank?

      index = indexString.to_i

      sections << {} if sections.length <= index

      case type.to_sym
      when :name
        sections[index][:name] = v
      when :description
        sections[index][:description] = v
      end
    end

    sections
  end

  def collect_time(key)
    return unless update["#{key}(4i)"] && update["#{key}(5i)"]

    hour = update["#{key}(4i)"]
    min = update["#{key}(5i)"]
    tz = update[:time_zone] || team.time_zone

    new_time = Time.zone.now.in_time_zone(tz).change({ hour:, min: })

    new_time
  end

  def collect_metadata
    incoming_metadata = update.select { |key| Team::METADATA_ATTRIBUTES.include?(key) }
    incoming_metadata = incoming_metadata.transform_values { |value| value.blank? ? nil : value }

    incoming_metadata.any? ? team.metadata.merge(incoming_metadata) : nil
  end
end
