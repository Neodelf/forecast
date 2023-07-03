# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  scope module: :web do
    root 'forecasts#index'
    resources :forecasts, only: %i[index create]
  end

  Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(
      Digest::SHA256.hexdigest(username),
      Digest::SHA256.hexdigest(Rails.application.credentials.dig(:sidekiqweb, :username))
    ) &
      ActiveSupport::SecurityUtils.secure_compare(
        Digest::SHA256.hexdigest(password),
        Digest::SHA256.hexdigest(Rails.application.credentials.dig(:sidekiqweb, :password))
      )
  end

  mount(Sidekiq::Web => '/sidekiq')
  mount ActionCable.server => '/cable'
end
