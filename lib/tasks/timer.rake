namespace :timer do

  desc "Rebuild the guest user history"
  task refresh_guest: :environment do
    puts 'Begin timer:refresh_guest'
    User.guest_history
    puts 'Completed timer:refresh_guest'
  end

end
