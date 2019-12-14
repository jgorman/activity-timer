class ProjectValidator < ActiveModel::Validator; end

class Project < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :user
  belongs_to :client
  has_many :activities, dependent: :destroy

  validates :user, presence: true
  validates :client, presence: true
  validates :name,
            uniqueness: { scope: :client, message: '"%{value}" has been used.' }
  validates_with ProjectValidator

  # Bootstrap 4 colors.
  ColorMap = {
    blue: 0x007bff,
    indigo: 0x6610f2,
    purple: 0x6f42c1,
    pink: 0xe83e8c,
    red: 0xdc3545,
    orange: 0xfd7e14,
    yellow: 0xffc107,
    green: 0x28a745,
    teal: 0x20c997,
    cyan: 0x17a2b8,
    grey: 0x6c757d,
    grey_dark: 0x343a40,
    black: 0x000000
  }
  Colors = ColorMap.values

  def display_name
    name.empty? ? 'No Project' : name
  end

  def display_title
    "#{client.display_name} - #{display_name}"
  end

  def self.random_color
    Colors[rand(Colors.length)]
  end

  def hex_color
    sprintf('#%06x', color)
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

class ProjectValidator < ActiveModel::Validator
  def validate(project)
    unless project.client.user == project.user
      project.errors[:client] << 'project.client.user != project.user'
    end
  end
end
