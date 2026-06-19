require 'spec_helper'

module Arxiv
  describe Category do
    describe ".types" do
      it "parses the bundled abbreviation-to-description mapping (no network)" do
        expect(Category.types).not_to be_empty
      end

      it "maps a long-standing abbreviation to its description" do
        expect(Category.types["astro-ph.IM"]).to eql("Physics - Instrumentation and Methods for Astrophysics")
      end

      it "maps a recently added abbreviation to its description" do
        expect(Category.types["eess.SP"]).to eql("Electrical Engineering and Systems Science - Signal Processing")
      end
    end

    before(:all) do
      @category = Arxiv.get('1202.0819').primary_category
    end

    describe "abbreviation" do
      it "should fetch the category's abbreviation" do
        expect(@category.abbreviation).to eql("astro-ph.IM")
      end
    end

    describe "description" do
      it "should fetch the category's description" do
        expect(@category.description).to eql("Physics - Instrumentation and Methods for Astrophysics")
      end
    end

    describe "long_description" do
      it "should fetch the category's abbreviation and description"do
        expect(@category.long_description).to eql("astro-ph.IM (Physics - Instrumentation and Methods for Astrophysics)")
      end

      it "should return only the abbreviation when a description cannot be found (e.g. MSC classes)"do
        category = Category.new
        category.abbreviation = "58D15 (Primary); 58B10 (Secondary)"
        expect(category.long_description).to eql("58D15 (Primary); 58B10 (Secondary)")
      end
    end

  end
end
