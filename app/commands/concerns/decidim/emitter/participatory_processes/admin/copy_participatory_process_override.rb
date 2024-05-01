# frozen_string_literal: true

module Decidim
  module Emitter
    module ParticipatoryProcesses
      module Admin
        module CopyParticipatoryProcessOverride
          extend ActiveSupport::Concern

          included do
            def copy_participatory_process
              @copied_process = ParticipatoryProcess.create!(
                organization: @participatory_process.organization,
                title: form.title,
                subtitle: @participatory_process.subtitle,
                slug: form.slug,
                hashtag: @participatory_process.hashtag,
                description: @participatory_process.description,
                short_description: @participatory_process.short_description,
                promoted: @participatory_process.promoted,
                scope: @participatory_process.scope,
                developer_group: @participatory_process.developer_group,
                local_area: @participatory_process.local_area,
                area: @participatory_process.area,
                target: @participatory_process.target,
                participatory_scope: @participatory_process.participatory_scope,
                participatory_structure: @participatory_process.participatory_structure,
                meta_scope: @participatory_process.meta_scope,
                start_date: @participatory_process.start_date,
                end_date: @participatory_process.end_date,
                participatory_process_group: @participatory_process.participatory_process_group,
                private_space: @participatory_process.private_space,
                emitter_name: @participatory_process.emitter_name
              )
            end

            def copy_participatory_process_attachments
              [:hero_image, :banner_image, :emitter].each do |attribute|
                next unless @participatory_process.attached_uploader(attribute).attached?

                @copied_process.send(attribute).attach(@participatory_process.send(attribute).blob)
              end
            end
          end
        end
      end
    end
  end
end
