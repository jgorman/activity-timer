class TimerValidator < ActiveModel::Validator; end

class Timer < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :user
  belongs_to :project

  validates :user, presence: true
  validates :project, presence: true
  validates :start, presence: true
  validates_with TimerValidator
end

class TimerValidator < ActiveModel::Validator
  def validate(timer)
    unless timer.project.user == timer.user
      timer.errors[:project] << 'timer.project.user != timer.user'
    end
  end
end
