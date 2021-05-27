# frozen_string_literal: true

require "action_dispatch"

require_relative "modular_routes/builder"
require_relative "modular_routes/extension"
require_relative "modular_routes/mapper"
require_relative "modular_routes/route/inner"
require_relative "modular_routes/route/resource"
require_relative "modular_routes/scope_options"
require_relative "modular_routes/version"

module ModularRoutes
  ActionDispatch::Routing::Mapper.include(Extension)
end
