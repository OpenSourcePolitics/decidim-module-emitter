# frozen_string_literal: true

module Decidim
  module Emitter
    module ParticipatoryProcesses
      module Admin
        module DuplicateParticipatoryProcessOverride
          extend ActiveSupport::Concern

          included do
            def duplicate_participatory_process
              @duplicated_process = ParticipatoryProcess.create!(
                organization: @participatory_process.organization,
                title: form.title,
                subtitle: @participatory_process.subtitle,
                slug: form.slug,
                description: @participatory_process.description,
                short_description: @participatory_process.short_description,
                promoted: @participatory_process.promoted,
                developer_group: @participatory_process.developer_group,
                local_area: @participatory_process.local_area,
                target: @participatory_process.target,
                participatory_scope: @participatory_process.participatory_scope,
                participatory_structure: @participatory_process.participatory_structure,
                meta_scope: @participatory_process.meta_scope,
                start_date: @participatory_process.start_date,
                end_date: @participatory_process.end_date,
                participatory_process_group: @participatory_process.participatory_process_group,
                private_space: @participatory_process.private_space,
                taxonomies: @participatory_process.taxonomies,
                emitter_name: @participatory_process.emitter_name
              )
            end

            def duplicate_participatory_process_attachments
              return unless @participatory_process.attached_uploader(:hero_image).attached?

              @duplicated_process.send(:hero_image).attach(@participatory_process.send(:hero_image).blob)

              return unless @participatory_process.attached_uploader(:emitter).attached?

              @duplicated_process.emitter.attach(@participatory_process.emitter.blob)
            end
          end
        end
      end
    end
  end
end
