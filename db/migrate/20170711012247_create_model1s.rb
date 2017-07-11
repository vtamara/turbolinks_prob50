class CreateModel1s < ActiveRecord::Migration[5.0]
  def change
    create_table :model1s do |t|
      t.string :field1
      t.string :field2
      t.string :field3

      t.timestamps
    end
  end
end
