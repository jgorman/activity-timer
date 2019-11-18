class Project < ApplicationRecord
  belongs_to :user
  belongs_to :client
  has_many :activities, dependent: :destroy

  validates :user, presence: true
  validates :client, presence: true
  validates :name,
            presence: true,
            uniqueness: { scope: :client, message: '%{value} has been used.' }
end
