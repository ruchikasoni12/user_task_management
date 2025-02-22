class Task < ApplicationRecord
  belongs_to :user
  enum status: {pending: 0, in_progress: 1, completed: 2}

  validates :title, presence: true
  validates :status, inclusion: {in: statuses.keys}
  validates :due_date, presence: true
  before_validation :valid_due_date

  private
  
  def valid_due_date
    begin
      parsed_due_date = Date.parse(due_date.to_s)  # Ensure it's converted to Date
    rescue ArgumentError
      errors.add(:due_date, "must be a valid date")
      return
    end
    if parsed_due_date < Date.today
      errors.add(:due_date, "cannot be in the past")
    end
  end
end
