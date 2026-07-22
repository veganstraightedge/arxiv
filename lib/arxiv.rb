require 'open-uri'
require 'nokogiri'
require 'happymapper'
require 'full-name-splitter'

require 'arxiv/version'
require 'arxiv/string_scrubber'

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
    id = parse_arxiv_identifier(identifier)

    unless id =~ ID_FORMAT || id =~ LEGACY_ID_FORMAT
      raise Arxiv::Error::MalformedId, "Manuscript ID format is invalid"
    end

    url = ::URI.parse("http://export.arxiv.org/api/query?id_list=#{id}")
    response = ::Nokogiri::XML(URI.open(url)).remove_namespaces!
    manuscript = Arxiv::Manuscript.parse(response.to_s, single: id)

    raise Arxiv::Error::ManuscriptNotFound, "Manuscript #{id} doesn't exist on arXiv" if manuscript&.title.nil?
    manuscript
  end

  def self.parse_arxiv_identifier(identifier)
    identifier = identifier.delete_suffix(".pdf")

    id = if valid_id?(identifier)
      identifier
    elsif valid_url?(identifier)
      format = legacy_url?(identifier) ? LEGACY_URL_FORMAT : CURRENT_URL_FORMAT
      identifier.match(/(#{format})/)[1]
    else
      identifier # probably an error
    end

    normalize_legacy_id(id)
  end
  private_class_method :parse_arxiv_identifier

  # In April 2007, arxiv dropped the subject-class suffix from legacy identifiers
  # (e.g. `math.DG/0510097` became `math/0510097`). The website still 301-redirects
  # the old form, but the API at /api/query?id_list=math.DG/0510097 silently returns
  # no results. Normalize so callers can pass either form.
  def self.normalize_legacy_id(id)
    id.sub(/\A([^.\/]+)\.[^\/]+\//, '\1/')
  end
  private_class_method :normalize_legacy_id

  def self.valid_id?(identifier)
    identifier =~ ID_FORMAT || identifier =~ LEGACY_ID_FORMAT
  end
  private_class_method :valid_id?

  def self.valid_url?(identifier)
    identifier =~ LEGACY_URL_FORMAT || identifier =~ CURRENT_URL_FORMAT
  end
  private_class_method :valid_url?

  def self.legacy_url?(identifier)
    identifier =~ LEGACY_URL_FORMAT
  end
  private_class_method :legacy_url?
end
