class AddUserToAchievements < ActiveRecord::Migration[6.0]
  def change
    add_reference :achievements, :user, null: false, foreign_key: true
  end
end
