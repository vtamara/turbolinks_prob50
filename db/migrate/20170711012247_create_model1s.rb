class CreateModel1s < ActiveRecord::Migration[5.1]
  def change
    create_table :model1s do |t|
      t.string :field1
      t.string :field2

      t.timestamps
    end
  end
end
