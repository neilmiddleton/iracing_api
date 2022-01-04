# frozen_string_literal: true

require_relative "lib/iracing_api/version"

Gem::Specification.new do |spec|
  spec.name          = "iracing_api"
  spec.version       = IRacingAPI::VERSION
  spec.authors       = ["Neil Middleton"]
  spec.email         = ["neil@neilmiddleton.com"]

  spec.summary       = "A Ruby Client for the IRacing API"
  spec.description   = "A Ruby Client for the IRacing API"
  spec.homepage      = "https://github.com/neilmiddleton/iracing_api"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/neilmiddleton/iracing_api"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "faraday", "~> 1.8"
  spec.add_dependency "faraday-cookie_jar", "~> 0.0.7"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
