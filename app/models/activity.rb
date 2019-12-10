class ActivityValidator < ActiveModel::Validator; end

class Activity < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :user
  belongs_to :client
  belongs_to :project

  validates :user, presence: true
  validates :client, presence: true
  validates :project, presence: true
  validates :start, presence: true
  validates :finish, presence: true
  validates_with ActivityValidator

  before_validation :fix_length

  private

  def fix_length
    self.finish = start + length if start and !finish and length
    self.length = finish - start if start and finish
  end

  # Sort projects by latest activity.
  after_save { project.touch }
end

class ActivityValidator < ActiveModel::Validator
  def validate(activity)
    if activity.finish < activity.start
      activity.errors[:activity] << 'finish time is before start time.'
    end

    unless activity.client.user == activity.user
      activity.errors[:client] << 'activity.client.user != activity.user'
    end

    unless activity.project.client == activity.client
      activity.errors[:project] << 'activity.project.client != activity.client'
    end
  end
end
