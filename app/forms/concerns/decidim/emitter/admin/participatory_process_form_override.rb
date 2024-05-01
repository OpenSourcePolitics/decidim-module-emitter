# frozen_string_literal: true

module Decidim
  module Emitter
    module Admin
      module ParticipatoryProcessFormOverride
        extend ActiveSupport::Concern

        included do
          include Decidim::Emitter::EmitterHelper

          attribute :emitter
          attribute :emitter_name
          attribute :emitter_image
          attribute :emitter_select
          attribute :emitter_name_image
          attribute :emitter_name_select
          attribute :emitter_read_name
          attribute :remove_emitter, Decidim::AttributeObject::TypeMap::Boolean, default: false
          attribute :remove_emitter_image, Decidim::AttributeObject::TypeMap::Boolean, default: false

          validates :emitter, passthru: { to: Decidim::ParticipatoryProcess }

          def remove_emitter_image=(value)
            self.remove_emitter = ActiveModel::Type::Boolean.new.cast(value) if value
            prepare_emitter_name!
          end

          def emitter_name_image=(value)
            @emitter_name_image = value if value
            prepare_emitter_name!
            prepare_emitter!
          end

          def emitter_name_select=(value)
            @emitter_name_select = value if value
            prepare_emitter_name!
          end

          def emitter_image=(value)
            @emitter_image = value if value
            prepare_emitter!
          end

          def emitter_select=(value)
            if value.present?
              target_pp = Decidim::ParticipatoryProcess.find(value)
              blob = target_pp.emitter.attachment.blob
              @emitter_select = blob
              @emitter_name_select = target_pp.emitter_name
            end
            prepare_emitter!
            prepare_emitter_name!
          end

          def emitter_image
            @emitter_image || emitter
          end

          def emitter_select
            @emitter_select || emitter
          end

          attr_reader :emitter_name_image

          def emitter_name_select
            @emitter_name_select || emitter_name
          end

          def emitter_read_name
            @emitter_read_name || emitter_name
          end

          def emitter_read_name=(value)
            @emitter_read_name = value if value
            prepare_emitter_name!
          end

          private

          def prepare_emitter_name!
            self.emitter_name = emitter_read_name
            self.emitter_name = emitter_name_select if emitter_name_select.present?
            self.emitter_name = emitter_name_image if emitter_name_image.present?
            self.emitter_name = nil if remove_emitter
          end

          def prepare_emitter!
            self.emitter = emitter_select if emitter_select
            self.emitter = emitter_image if emitter_image
          end
        end
      end
    end
  end
end
