class Project < ApplicationRecord
  belongs_to :user
  belongs_to :client
  has_many :activities, dependent: :destroy

  validates :user, presence: true
  validates :client, presence: true
  validates :name,
            uniqueness: { scope: :client, message: '"%{value}" has been used.' }

  def display_name
    name.empty? ? '(No project)' : name
  end

  def display_title
    "#{client.display_name} - #{display_name}"
  end

end
