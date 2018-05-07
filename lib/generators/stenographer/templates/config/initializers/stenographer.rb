# frozen_string_literal: true

Stenographer.configure do |config|
  # The application name to use for the home link name if no icon is defined.
  # config.app_name = 'Stenography'

  # The string location of the icon to use for the header, based off your app/assets/images directory.
  # i.e. config.app_icon = 'logo' would serve app/assets/images/logo.png
  #
  # The max height is set to 20px so horizontal logos work best, if that doesn't work use the app_name instead.
  # config.app_icon = nil

  # This list of available options for change types.
  # config.change_types = %w[new improved fixed]

  # The viewer configuration specifies who is allowed to view changes. By default both viewing and managing are both set
  # to true.
  #
  # This can be either a boolean or a Proc that takes a session returns a boolean.
  #
  # Example:
  # config.viewer = Proc.new { |session|
  #   User.select(:id, :viewer).find_by(id: session[:user_id]).try(:viewer?) if session.present?
  # }
  # config.viewer = true

  # The viewer configuration specifies who is allowed to manage changes. By default both viewing and managing are both set
  # to true.
  #
  # This can be either a boolean or a Proc that takes a session returns a boolean.
  #
  # Example:
  # config.manager = Proc.new { |session|
  #   User.select(:id, :manager).find_by(id: session[:user_id]).try(:manager?) if session.present?
  # }
  # config.manager = true
end
