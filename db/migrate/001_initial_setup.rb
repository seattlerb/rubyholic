class InitialSetup < ActiveRecord::Migration
  def self.up
    create_table "contacts", :force => true do |t|
      t.column "name", :string, :limit => 50
      t.column "email", :string, :limit => 50
      t.column "group_id", :integer, :null => false
    end

    create_table "events", :force => true do |t|
      t.column "start", :datetime
      t.column "summary", :string
      t.column "location_id", :integer, :null => false
      t.column "group_id", :integer, :null => false
      t.column "duration", :integer
    end

    create_table "groups", :force => true do |t|
      t.column "name", :string, :limit => 100
      t.column "city", :string, :limit => 100
    end

    create_table "locations", :force => true do |t|
      t.column "name", :string
      t.column "address", :string
      t.column "group_id", :integer, :null => false
    end

    create_table "subjects", :force => true do |t|
      t.column "description", :string
      t.column "event_id", :integer, :null => false
    end

    create_table "urls", :force => true do |t|
      t.column "label", :string, :limit => 10
      t.column "url", :string
      t.column "group_id", :integer, :null => false
    end

    add_foreign_key_constraint "contacts", "group_id", "groups", "id", :name => "contacts_group_id_fkey", :on_update => nil, :on_delete => :cascade

    add_foreign_key_constraint "events", "group_id", "groups", "id", :name => "events_group_id_fkey", :on_update => nil, :on_delete => :cascade
    add_foreign_key_constraint "events", "location_id", "locations", "id", :name => "events_location_id_fkey", :on_update => nil, :on_delete => :cascade

    add_foreign_key_constraint "locations", "group_id", "groups", "id", :name => "locations_group_id_fkey", :on_update => nil, :on_delete => :cascade

    add_foreign_key_constraint "subjects", "event_id", "events", "id", :name => "subjects_event_id_fkey", :on_update => nil, :on_delete => :cascade

    add_foreign_key_constraint "urls", "group_id", "groups", "id", :name => "urls_group_id_fkey", :on_update => nil, :on_delete => :cascade
  end

  def self.down
    remove_foreign_key_constraint "contacts", :foreign_key => "group_id"
    remove_foreign_key_constraint "events", :foreign_key => "group_id"
    remove_foreign_key_constraint "events", :foreign_key => "location_id"
    remove_foreign_key_constraint "locations", :foreign_key => "group_id"
    remove_foreign_key_constraint "subjects", :foreign_key => "event_id"
    remove_foreign_key_constraint "urls", :foreign_key => "group_id"

    drop_table "contacts"
    drop_table "events"
    drop_table "groups"
    drop_table "locations"
    drop_table "subjects"
    drop_table "urls"
  end
end
