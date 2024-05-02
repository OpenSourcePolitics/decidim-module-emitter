# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/emitter/version"

Gem::Specification.new do |s|
  s.version = Decidim::Emitter::VERSION
  s.authors = ["quentinchampenois"]
  s.email = ["26109239+Quentinchampenois@users.noreply.github.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://decidim.org"
  s.metadata = {
    "bug_tracker_uri" => "https://github.com/OpenSourcePolitics/decidim-module-emitter/issues",
    "documentation_uri" => "https://docs.decidim.org/",
    "funding_uri" => "https://opencollective.com/decidim",
    "homepage_uri" => "https://decidim.org",
    "source_code_uri" => "https://github.com/OpenSourcePolitics/decidim-module-emitter",
    "rubygems_mfa_required" => "true"
  }
  s.required_ruby_version = "~> 3.0"

  s.name = "decidim-emitter"
  s.summary = "Decidim module for adding new emitters to participatory processes"
  s.description = "A Decidim module for adding new emitters to participatory processes directly from the backoffice, and visible in the frontoffice."

  s.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").select do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w(app/ config/ db/ lib/ LICENSE-AGPLv3.txt Rakefile README.md))
    end
  end

  s.add_dependency "decidim-core", "~> #{Decidim::Emitter::DECIDIM_VERSION}"
  s.add_dependency "decidim-participatory_processes", "~> #{Decidim::Emitter::DECIDIM_VERSION}"

  s.add_development_dependency "decidim-dev", "~> #{Decidim::Emitter::DECIDIM_VERSION}"
end
