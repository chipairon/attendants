class CreateAttendants < ActiveRecord::Migration
  def change
    create_table :attendants do |t|
      t.string :full_name
      t.string :phone
      t.string :email
      t.string :will_come, default: "maybe"
      t.integer :comes_with, default: 0
      t.string :permalink
      t.string :title
      t.integer :user_id

      t.timestamps
    end

  end
end
