module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      puts "$$$$$ Connection.connect current_user(#{current_user.inspect})"
      logger.add_tags 'ActionCable', current_user.id
    end

    protected

    def find_verified_user
      verified_user = User.find_by(id: cookies.signed['user.id'])
      if verified_user && cookies.signed['user.expires_at'] > Time.now
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def find_verified_user_from_warden
      if warden = request.env['warden']
        if user = warden.user
          return user
        end
      end
      reject_unauthorized_connection
    end
  end
end
