require_relative "lib/arxiv/version"

Gem::Specification.new do |spec|
  spec.name        = "arxiv"
  spec.version     = Arxiv::VERSION
  spec.authors     = ["Scholastica"]
  spec.email       = ["coryschires@gmail.com"]
  spec.homepage    = "https://github.com/scholastica/arxiv"
  spec.metadata    = {
    "bug_tracker_uri" => "https://github.com/scholastica/arxiv/issues",
    "homepage_uri"    => "https://github.com/scholastica/arxiv",
    "source_code_uri" => "https://github.com/scholastica/arxiv"
  }
  spec.summary     = "Ruby wrapper accessing the arXiv API"
  spec.description = "Easily access arXiv article info – including authors, categories, links, etc."
  spec.licenses    = ['MIT']

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # specify any dependencies here; for example:
  spec.add_dependency "happymapper", '~> 0.4', '>= 0.4.1'
  spec.add_dependency "nokogiri",    '~> 1.6', '>= 1.6.6.2'
  spec.add_dependency "full-name-splitter", '~> 0.1.2'
end
