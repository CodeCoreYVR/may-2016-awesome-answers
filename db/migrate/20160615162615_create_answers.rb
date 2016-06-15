class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body
      # this will generate an integer field named `question_id`
      # the `index: true,` option will automatically add an index on the
      # `question_id` field because we're likely going to use it in queries
      # The `foreign_key: true` option will automatically add a foreign key
      # contraint on the `question_id` field referencing the `id` field in the
      # questions table.
      t.references :question, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
