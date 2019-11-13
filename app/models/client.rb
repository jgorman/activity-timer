class Client < ApplicationRecord
  belongs_to :user
  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy

  validates :user, :presence: true
  validates :name, :presence: true
end
