class Task < ApplicationRecord
  enum status: { todo: 0, in_progress: 1, done: 2 }
  validates :title, presence: true, uniqueness: true
  validate :check_todo_limit, on: :create, if: :todo_status?

  def todo_status?
    status == 'todo'
  end

  def check_todo_limit
    total_tasks = Task.count
    todo_tasks = Task.where(status: :todo).count
    if todo_tasks > 0 && todo_tasks >= total_tasks.to_f / 2.0
      errors.add(:base, "Cannot create new 'To Do' task, as existing 'To Do' tasks are >= 50% of total tasks")
    end
  end
end
