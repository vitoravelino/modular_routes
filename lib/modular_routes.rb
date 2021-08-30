# frozen_string_literal: true

require "action_dispatch"

require_relative "modular_routes/builder"
require_relative "modular_routes/extension"
require_relative "modular_routes/routable"
require_relative "modular_routes/routable/concerns"
require_relative "modular_routes/routable/non_restful"
require_relative "modular_routes/routable/restful"
require_relative "modular_routes/routable/standalone"
require_relative "modular_routes/scopable"
require_relative "modular_routes/scopable/concern"
require_relative "modular_routes/scopable/namespace"
require_relative "modular_routes/scopable/resource"
require_relative "modular_routes/scopable/scope"
require_relative "modular_routes/scopable/single_resource"
require_relative "modular_routes/version"

module ModularRoutes
  ActionDispatch::Routing::Mapper.include(Extension)
end
