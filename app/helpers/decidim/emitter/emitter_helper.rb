# frozen_string_literal: true

module Decidim
  module Emitter
    module EmitterHelper
      def display_emitter(process)
        return unless process.respond_to?(:emitter)
        return if process.attached_uploader(:emitter).path.nil?

        {
          picture: image_tag(process.attached_uploader(:emitter).path),
          text: t("emitter_text",
                  developer_group: translated_attribute(process.developer_group),
                  scope: "decidim.participatory_processes.emitter")
        }
      end

      # Retrieve emitter from ParticipatoryProcesses in database
      # TODO: Add cache entry to avoid multiple queries
      def emitter_options
        @emitter_options ||= Decidim::ParticipatoryProcess.where(organization: current_organization).where.not(emitter_name: [nil, ""]).uniq(&:emitter_name).map do |pp|
          [pp.emitter_name, pp.id, { "data-image": pp.attached_uploader(:emitter).path }]
        end
      end
    end
  end
end
