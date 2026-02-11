# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Emitter do
    subject { described_class }

    it "has version" do
      expect(Decidim::Emitter::VERSION).to eq("2.0.0")
    end
  end
end
