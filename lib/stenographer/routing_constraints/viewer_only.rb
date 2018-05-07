# frozen_string_literal: true

module Stenographer
  module RoutingConstraints
    class ViewerOnly
      def matches?(request)
        request.session[:init] = true

        if Stenographer.viewer.respond_to?(:call)
          Stenographer.viewer.call(request.session)
        else
          Stenographer.viewer
        end
      end
    end
  end
end
