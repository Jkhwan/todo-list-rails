class Todo < ActiveRecord::Base

  # Assocations
  belongs_to :user

  # Validations
  validates :name, presence: true
  validate :due_date_cannot_be_in_the_past
  validates :user, presence: true

  # Scopes
  scope :overdue, lambda { where("due_date < ?", Date.today) }
  scope :on_time, lambda { where("due_date >= ?", Date.today) }
  scope :completed, lambda { where("completed == ?", true) }
  scope :in_progress, lambda { where("completed == ?", false) }

  protected
  def due_date_cannot_be_in_the_past
    if due_date.present? && due_date < Date.today
      errors.add(:due_date, "can't be in the past")
    end
  end
end
