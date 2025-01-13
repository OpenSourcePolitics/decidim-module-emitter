# frozen_string_literal: true

module Decidim
  module Emitter
    module ParticipatoryProcesses
      module Admin
        module CreateParticipatoryProcessOverride
          extend ActiveSupport::Concern

          included do
            include ::Decidim::AttachmentAttributesMethods

            fetch_file_attributes :hero_image, :emitter

            fetch_form_attributes :organization, :title, :subtitle, :weight, :slug, :hashtag, :description,
                                  :short_description, :promoted, :scopes_enabled, :scope, :announcement,
                                  :scope_type_max_depth, :private_space, :developer_group, :local_area, :area, :target,
                                  :participatory_scope, :participatory_structure, :meta_scope, :start_date, :end_date,
                                  :participatory_process_group, :participatory_process_type, :emitter_name
          end
        end
      end
    end
  end
end
