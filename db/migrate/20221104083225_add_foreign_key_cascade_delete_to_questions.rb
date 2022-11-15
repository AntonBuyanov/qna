class AddForeignKeyCascadeDeleteToQuestions < ActiveRecord::Migration[6.1]
  def change
    remove_reference :questions, :best_answer
    add_reference :questions, :best_answer, column: :best_answer_id, on_delete: :cascade
  end
end
