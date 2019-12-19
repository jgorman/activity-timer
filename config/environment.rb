# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

#%w{render_template render_partial render_collection}.each do |event|
%w{render_partial}.each do |event|
  ActiveSupport::Notifications.unsubscribe "#{event}.action_view"
end

