class Client < ApplicationRecord
  belongs_to :user
  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy

  validates :user, presence: true
  validates :name,
            uniqueness: { scope: :user, message: '"%{value}" has been used.' }

  def display_name
    name.empty? ? '(No client)' : name
  end
end
