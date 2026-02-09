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

            fetch_form_attributes :organization, :title, :subtitle, :weight, :slug, :description,
                                  :short_description, :promoted, :taxonomizations, :announcement,
                                  :private_space, :developer_group, :local_area, :target,
                                  :participatory_scope, :participatory_structure, :meta_scope, :start_date, :end_date,
                                  :participatory_process_group, :emitter_name
          end
        end
      end
    end
  end
end
