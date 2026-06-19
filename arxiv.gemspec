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

  spec.files         = `git ls-files`.split("\n")
  spec.bindir        = "exe"
  spec.executables   = `git ls-files -- exe/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # specify any dependencies here; for example:
  spec.add_runtime_dependency "happymapper", '~> 0.4', '>= 0.4.1'
  spec.add_runtime_dependency "nokogiri",    '~> 1.6', '>= 1.6.6.2'
  spec.add_runtime_dependency "full-name-splitter", '~> 0.1.2'

  spec.add_development_dependency "rspec", '~> 3.3', '>= 3.3.0'
  spec.add_development_dependency "pry",   '~> 0.10.2'
end
