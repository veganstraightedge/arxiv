module Arxiv
  # Value object for an arXiv document identifier, built from any of the forms
  # users paste:
  #
  #   Identifier.new('1202.0819')                           # bare id
  #   Identifier.new('1202.0819v1')                         # versioned id
  #   Identifier.new('math/0510097')                        # legacy id
  #   Identifier.new('math.DG/0510097')                     # legacy id with subject class
  #   Identifier.new('https://arxiv.org/abs/1202.0819v1')   # abs URL
  #   Identifier.new('https://arxiv.org/pdf/1202.0819.pdf') # pdf URL
  #
  # Raises Arxiv::Error::MalformedId when the input cannot be parsed.
  class Identifier
    attr_reader :id, :version

    def initialize(input)
      normalized = normalize(input)

      unless normalized =~ Arxiv::ID_FORMAT || normalized =~ Arxiv::LEGACY_ID_FORMAT
        raise Arxiv::Error::MalformedId, "Manuscript ID format is invalid"
      end

      if normalized =~ /\A(.+)v(\d+)\z/
        @id = $1
        @version = $2.to_i
      else
        @id = normalized
        @version = nil
      end
    end

    # The identifier as arXiv's API expects it: normalized, and versioned
    # when a version is present.
    def to_s
      version ? "#{id}v#{version}" : id
    end

    private

    def normalize(input)
      input = input.sub(/\.pdf\z/, '')

      id = if valid_id?(input)
        input
      elsif valid_url?(input)
        format = legacy_url?(input) ? Arxiv::LEGACY_URL_FORMAT : Arxiv::CURRENT_URL_FORMAT
        input.match(/(#{format})/)[1]
      else
        input # probably an error; caught by the format check above
      end

      normalize_legacy_id(id)
    end

    # In April 2007, arxiv dropped the subject-class suffix from legacy identifiers
    # (e.g. `math.DG/0510097` became `math/0510097`). The website still 301-redirects
    # the old form, but the API at /api/query?id_list=math.DG/0510097 silently returns
    # no results. Normalize so callers can pass either form.
    def normalize_legacy_id(id)
      id.sub(/\A([^.\/]+)\.[^\/]+\//, '\1/')
    end

    def valid_id?(input)
      input =~ Arxiv::ID_FORMAT || input =~ Arxiv::LEGACY_ID_FORMAT
    end

    def valid_url?(input)
      input =~ Arxiv::LEGACY_URL_FORMAT || input =~ Arxiv::CURRENT_URL_FORMAT
    end

    def legacy_url?(input)
      input =~ Arxiv::LEGACY_URL_FORMAT
    end
  end
end
