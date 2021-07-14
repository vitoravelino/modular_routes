# frozen_string_literal: true

require_relative "lib/modular_routes/version"

Gem::Specification.new do |spec|
  spec.name          = "modular_routes"
  spec.version       = ModularRoutes::VERSION
  spec.authors       = ["Vítor Avelino"]
  spec.email         = ["contact@vitoravelino.me"]

  spec.summary       = "A simple way of having dedicated controllers for each of your route actions"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/vitoravelino/modular_routes"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    %x(git ls-files -z).split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency("rails")

  spec.add_development_dependency("combustion")
  spec.add_development_dependency("rspec-rails")
  spec.add_development_dependency("rubocop-performance")
  spec.add_development_dependency("rubocop-rspec")
  spec.add_development_dependency("rubocop-shopify")
  spec.add_development_dependency("rubycritic")
  spec.add_development_dependency("sqlite3")

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
