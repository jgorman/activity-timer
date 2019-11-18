class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :client
  belongs_to :project

  validates :user, presence: true
  validates :client, presence: true
  validates :project, presence: true
  validates :start, presence: true
end
