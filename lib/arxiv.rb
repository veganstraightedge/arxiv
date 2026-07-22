require 'open-uri'
require 'nokogiri'
require 'happymapper'
require 'full-name-splitter'

require 'arxiv/version'
require 'arxiv/string_scrubber'
require 'arxiv/identifier'

require 'arxiv/models/author'
require 'arxiv/models/link'
require 'arxiv/models/category'
require 'arxiv/models/manuscript'

module Arxiv

  module Error
    class ManuscriptNotFound < StandardError ; end
    class MalformedId < StandardError ; end
  end

  # In 2007, the ArXiv API changed document ID formats:
  #
  #    https://arxiv.org/abs/math/0510097v1  (legacy)
  #    https://arxiv.org/abs/1202.0819v1     (current)
  #
  # These constants help us deal with both use cases.
  #
  LEGACY_URL_FORMAT = /[^\/]+\/\d+(?:v\d+)?$/
  CURRENT_URL_FORMAT = /\d{4,}\.\d{4,}(?:v\d+)?$/

  LEGACY_ID_FORMAT = /^#{LEGACY_URL_FORMAT}/
  ID_FORMAT = /^#{CURRENT_URL_FORMAT}/

  def self.get(identifier)
    id = Identifier.new(identifier).to_s

    url = ::URI.parse("http://export.arxiv.org/api/query?id_list=#{id}")
    response = ::Nokogiri::XML(URI.open(url)).remove_namespaces!
    manuscript = Arxiv::Manuscript.parse(response.to_s, single: id)

    raise Arxiv::Error::ManuscriptNotFound, "Manuscript #{id} doesn't exist on arXiv" if manuscript&.title.nil?
    manuscript
  end

end
