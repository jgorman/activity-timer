class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :client
  belongs_to :project

  validates :user, presence: true
  validates :client, presence: true
  validates :project, presence: true
  validates :start, presence: true

  private

  # Sort projects by latest activity.
  after_save do
    project.touch
  end
end
