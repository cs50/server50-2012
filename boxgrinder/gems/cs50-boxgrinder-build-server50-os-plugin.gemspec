Gem::Specification.new do |s|
  s.name = %q{cs50-boxgrinder-build-server50-os-plugin}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marek Goldmann"]
  s.date = %q{2010-07-26}
  s.description = %q{BoxGrinder Build CS50 Server OS Plugin}
  s.email = %q{info@boxgrinder.org}
  s.extra_rdoc_files = ["CHANGELOG", "lib/cs50-boxgrinder-build-server50-os-plugin.rb", "lib/cs50-boxgrinder-build-server50-os-plugin/src/README", "lib/cs50-boxgrinder-build-server50-os-plugin/server50-plugin.rb"]
  s.files = ["CHANGELOG", "Manifest", "Rakefile", "lib/cs50-boxgrinder-build-server50-os-plugin.rb", "lib/cs50-boxgrinder-build-server50-os-plugin/src/README", "lib/cs50-boxgrinder-build-server50-os-plugin/server50-plugin.rb", "spec/server50-plugin-spec.rb", "cs50-boxgrinder-build-server50-os-plugin.gemspec"]
  s.homepage = %q{http://CS50.tv/}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "cs50-boxgrinder-build-server50-os-plugin"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{BoxGrinder Build}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{CS50 Server OS Plugin}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<boxgrinder-build>, [">= 0.5.0"])
    else
      s.add_dependency(%q<boxgrinder-build>, [">= 0.5.0"])
    end
  else
    s.add_dependency(%q<boxgrinder-build>, [">= 0.5.0"])
  end
end
