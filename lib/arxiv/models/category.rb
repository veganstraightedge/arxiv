module Arxiv
  class Category
    include HappyMapper

    # ArXiv categorizes articles by rather specific subject area using a system
    # of abbreviated subject codes. For example, "astro-ph.CO" is the code for
    # "Physics - Cosmology and Extragalactic Astrophysics". As you may expect
    # there are a lot of codes.
    #
    # While terse to the laymen, scientists are apparently very familiar with
    # the abbreviated codes for their discipline. Nevertheless, all things
    # considered, it would be better to also offer a more human readable
    # description.
    #
    # ArXiv publishes the official mapping at https://arxiv.org/category_taxonomy
    # but doesn't expose it via their API. We bundle a local copy at
    # `lib/arxiv/data/category_abbreviation_to_label_mapping.xml`, refreshable
    # via `rake categories:update`.
    #
    PATH_TO_CATEGORY_MAPPING_DATA = File.expand_path(File.dirname(__FILE__)) + "/../data/category_abbreviation_to_label_mapping.xml"

    @@category_mapping = {}

    def self.types
      return @@category_mapping unless @@category_mapping.empty?

      document = ::Nokogiri::XML(File.read(PATH_TO_CATEGORY_MAPPING_DATA))
      document.css("category").each do |node|
        @@category_mapping[node["id"]] = node["description"]
      end
      @@category_mapping
    end

    attribute :abbreviation, String, tag: 'term'

    def description
      Category.types[abbreviation]
    end

    def long_description
      description ? "#{abbreviation} (#{description})" : abbreviation
    end

  end
end
