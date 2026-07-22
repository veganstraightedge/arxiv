require 'spec_helper'

module Arxiv
  describe Identifier do
    cases = {
      # current id format
      "1202.0819"    => ["1202.0819", nil],
      "1202.0819v1"  => ["1202.0819", 1],
      "1509.06369"   => ["1509.06369", nil],
      "1202.0819v12" => ["1202.0819", 12],

      # legacy id format, with and without a subject class
      "math/0510097"            => ["math/0510097", nil],
      "math/0510097v1"          => ["math/0510097", 1],
      "math.DG/0510097"         => ["math/0510097", nil],
      "math.DG/0510097v1"       => ["math/0510097", 1],
      "cs/0002001"              => ["cs/0002001", nil],
      "cond-mat.dis-nn/9912001" => ["cond-mat/9912001", nil],
      "cond-mat/9912001"        => ["cond-mat/9912001", nil],

      # URLs
      "http://arxiv.org/abs/1202.0819"              => ["1202.0819", nil],
      "https://arxiv.org/abs/1202.0819v1"           => ["1202.0819", 1],
      "https://arxiv.org/abs/math.DG/0510097"       => ["math/0510097", nil],
      "https://arxiv.org/pdf/1202.0819"             => ["1202.0819", nil],
      "https://arxiv.org/pdf/1202.0819.pdf"         => ["1202.0819", nil],
      "https://arxiv.org/pdf/math.DG/0510097v1.pdf" => ["math/0510097", 1],
    }

    cases.each do |input, (id, version)|
      describe input.inspect do
        it "should have id #{id.inspect}" do
          expect(Identifier.new(input).id).to eql(id)
        end

        it "should have version #{version.inspect}" do
          expect(Identifier.new(input).version).to eql(version)
        end
      end
    end

    describe "to_s" do
      it "should return the id when there is no version" do
        expect(Identifier.new('1202.0819').to_s).to eql('1202.0819')
      end

      it "should return the versioned id when there is a version" do
        expect(Identifier.new('https://arxiv.org/abs/1202.0819v1').to_s).to eql('1202.0819v1')
      end

      it "should return the normalized legacy id" do
        expect(Identifier.new('math.DG/0510097v1').to_s).to eql('math/0510097v1')
      end
    end

    describe "malformed input" do
      it "should raise an error when the id cannot be parsed" do
        expect { Identifier.new('cond-mat0709123') }.to raise_error(Arxiv::Error::MalformedId)
      end

      it "should raise an error for an unrelated URL" do
        expect { Identifier.new('https://example.com/nope') }.to raise_error(Arxiv::Error::MalformedId)
      end
    end
  end
end
