# frozen_string_literal: true

module Stenographer
  module RoutingConstraints
    class ManagerOnly
      def matches?(request)
        request.session[:init] = true

        if Stenographer.manager.respond_to?(:call)
          Stenographer.manager.call(request.session)
        else
          Stenographer.manager
        end
      end
    end
  end
end
