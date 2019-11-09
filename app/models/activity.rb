class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :client
  belongs_to :project
end
