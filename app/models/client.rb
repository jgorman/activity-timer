class Client < ApplicationRecord
  belongs_to :user
  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy

  validates :user, presence: true
  validates :name,
            presence: true,
            uniqueness: { scope: :user, message: '%{value} has been used.' }
end
