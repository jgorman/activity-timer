class Project < ApplicationRecord
  belongs_to :user
  belongs_to :client
  has_many :activities, dependent: :destroy

  validates :user, presence: true
  validates :client, presence: true
  validates :name,
            uniqueness: { scope: :client, message: '"%{value}" has been used.' }

  def display_name
    name.empty? ? 'No Project' : name
  end

  def display_title
    "#{client.display_name} - #{display_name}"
  end

  def self.no_project(user)
    no_client = Client.no_client(user)
    no_project = no_client.projects.find_by_name('')
    unless no_project
      no_project = Project.new
      no_project.user = user
      no_project.client = no_client
      no_project.save!
    end
    no_project
  end
end
