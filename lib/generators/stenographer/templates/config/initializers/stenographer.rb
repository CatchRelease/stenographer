# frozen_string_literal: true

Stenographer.configure do |config|
  # The application name to use for the home link name if no icon is defined.
  config.app_name = 'Stenographer'

  # The string location of the icon to use for the header, based off your app/assets/images directory.
  # i.e. config.app_icon = 'logo' would serve app/assets/images/logo.png
  #
  # The max height is set to 20px so horizontal logos work best, if that doesn't work use the app_name instead.
  config.app_icon = nil

  # This list of available options for change types. These will be the items that show on the index page
  # with a "general" bucket wrapping anything without a type. The ordering of the display will be
  # "general", followed by the order of the change_types array.
  #
  # In the default case this is: General, New, Improved, Fixed
  config.change_types = %w[new improved fixed]

  # The number of items shown per page on the index and admin index
  config.per_page = 100

  # The viewer configuration specifies who is allowed to view changes. By default both viewing and managing are both set
  # to true.
  #
  # This can be either a boolean or a Proc that takes a session returns a boolean.
  #
  # Example:
  # config.viewer = proc { |session|
  #   User.select(:id, :viewer).find_by(id: session[:user_id]).try(:viewer?) if session.present?
  # }
  config.viewer = true

  # The viewer configuration specifies who is allowed to manage changes. By default both viewing and managing are both set
  # to true.
  #
  # This can be either a boolean or a Proc that takes a session returns a boolean.
  #
  # Example:
  # config.manager = proc { |session|
  #   User.select(:id, :manager).find_by(id: session[:user_id]).try(:manager?) if session.present?
  # }
  config.manager = true

  # Determines if the changelog will look for messages that contain [changelog #{CHANGE_MESSAGE}] or not.
  # If this is set to true, items without a changelog message will not be stored. This also affects the displayed message
  # when false. If there is a changelog message, it will be shown, otherwise it will be the subject.
  config.use_changelog = true

  # Which input to use for the incoming change events. Currently only supports Github Webhooks.
  #
  # Example:
  # config.parser = 'Stenographer::Inputs::GithubInput'
  config.parser = 'Stenographer::Inputs::GithubInput'

  # Display name for the links section on the index
  #
  # Example:
  # config.link_section_name = 'Useful Links'
  config.link_section_name = 'Useful Links'

  # ====================================================================================================================
  #
  # GitHub Parser Configuration
  #
  # ====================================================================================================================

  # Determines which branches the changelog takes into account
  #
  # Example:
  # config.tracked_branches = %w[master work]
  config.tracked_branches = %w[master work]

  # Creates a human readable mapping of branch names
  #
  # Example
  # config.branch_mapping = { master: 'production', work: 'staging' }
  config.branch_mapping = { master: 'production', work: 'staging' }
end

# ======================================================================================================================
#
# Omniauth Provider Configuration
#
# ======================================================================================================================

# SLACK Provider
#
# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :slack, 'API_KEY', 'API_SECRET', scope: 'identity,bot'
# end
