class CreateExamWindows < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_windows do |t|
      t.datetime :start
      t.datetime :end
      t.references :exam, null: false, foreign_key: true

      t.timestamps
    end
  end
end
