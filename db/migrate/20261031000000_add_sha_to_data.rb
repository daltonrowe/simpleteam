class AddShaToData < ActiveRecord::Migration[8.0]
  def change
    add_column :data, :sha, :string, limit: 64
    add_index :data, [ :team_id, :sha ]

    reversible do |dir|
      dir.up do
        # Backfill from a string `sha` property already stored in content.
        execute <<~SQL
          UPDATE data
          SET sha = json_extract(content, '$.sha')
          WHERE sha IS NULL
            AND json_valid(content)
            AND json_type(content, '$.sha') = 'text'
        SQL
      end
    end
  end
end
