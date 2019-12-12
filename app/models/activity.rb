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
  validates_with ActivityValidator

  private

  # Sort projects by latest activity.
  after_save { project.touch }
end

class ActivityValidator < ActiveModel::Validator
  def validate(activity)
    unless activity.client.user == activity.user
      activity.errors[:client] << 'activity.client.user != activity.user'
    end

    unless activity.project.client == activity.client
      activity.errors[:project] << 'activity.project.client != activity.client'
    end
  end
end
