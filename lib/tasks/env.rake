namespace :rails do

  desc "Show RAILS_ENV"
  task env: :environment do
    puts "RAILS_ENV: #{ENV['RAILS_ENV']}"
    puts "Rails.env: #{Rails.env}"
  end

end
