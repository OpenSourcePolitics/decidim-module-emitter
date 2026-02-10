# frozen_string_literal: true

module Decidim
  module Emitter
    module ParticipatoryProcesses
      module Admin
        module UpdateParticipatoryProcessOverride
          extend ActiveSupport::Concern

          included do
            fetch_file_attributes :hero_image, :emitter

            fetch_form_attributes :title, :subtitle, :weight, :slug, :promoted,
                                  :taxonomizations, :private_space, :developer_group, :local_area,
                                  :target, :participatory_scope, :participatory_structure,
                                  :meta_scope, :start_date, :end_date, :participatory_process_group,
                                  :announcement, :emitter_name
          end
        end
      end
    end
  end
end
