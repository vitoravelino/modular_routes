# frozen_string_literal: true

require "action_dispatch"

require_relative "modular_routes/builder"
require_relative "modular_routes/extension"
require_relative "modular_routes/options"
require_relative "modular_routes/route/non_restful"
require_relative "modular_routes/route/restful"
require_relative "modular_routes/version"

module ModularRoutes
  ActionDispatch::Routing::Mapper.include(Extension)
end
