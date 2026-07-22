require 'arxiv'
require 'webmock'

# Specs run offline by default: every arxiv API request is stubbed with a
# recorded response from spec/fixtures/. Fixture filenames are the requested
# id_list value, with `/` replaced by `_` (e.g. math_0510097.xml stubs
# id_list=math/0510097).
#
# To run against the live arxiv API instead (e.g. to check for upstream
# API drift):
#
#     ARXIV_LIVE=1 rspec .
#
RSpec.configure do |config|
  config.before(:suite) do
    next if ENV['ARXIV_LIVE']

    WebMock.enable!
    WebMock.disable_net_connect!

    Dir[File.join(__dir__, 'fixtures', '*.xml')].sort.each do |fixture|
      id = File.basename(fixture, '.xml').tr('_', '/')

      # Stub both schemes so this doesn't depend on whether the gem queries
      # http:// (and open-uri follows arxiv's 301) or https:// directly.
      %w[http https].each do |scheme|
        WebMock::API.stub_request(:get, "#{scheme}://export.arxiv.org/api/query?id_list=#{id}")
          .to_return(body: File.read(fixture), headers: { 'Content-Type' => 'application/atom+xml' })
      end
    end
  end
end
