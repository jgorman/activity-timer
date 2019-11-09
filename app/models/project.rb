class Project < ApplicationRecord
  belongs_to :user
  belongs_to :client
  has_many :activities, dependent: :destroy
end
