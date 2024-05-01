# frozen_string_literal: true

module Decidim
  module Emitter
    module ParticipatoryProcessOverride
      extend ActiveSupport::Concern

      included do
        has_one_attached :emitter
        validates_upload :emitter, uploader: Decidim::Emitter::EmitterUploader
      end
    end
  end
end
