# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = User.new(request.cookies['user_id'].gsub(/\W+/, '')[0..50])
    end
  end
end
