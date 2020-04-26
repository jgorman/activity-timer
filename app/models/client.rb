# frozen_string_literal: true

class Client < ApplicationRecord
  belongs_to :user
  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy

  validates :user, presence: true
  validates :name,
            uniqueness: { scope: :user, message: '"%{value}" has been used.' }

  def display_name
    name.empty? ? "No Client" : name
  end

  def self.no_client(user)
    no_client = user.clients.find_by_name("")
    unless no_client
      no_client = Client.new
      no_client.user = user
      no_client.save!
    end
    no_client
  end
end
