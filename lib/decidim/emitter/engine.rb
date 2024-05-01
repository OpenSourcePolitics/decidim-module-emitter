# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Emitter
    # This is the engine that runs on the public interface of emitter.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Emitter

      routes do
        # Add engine routes here
        # resources :emitter
        # root to: "emitter#index"
      end

      config.to_prepare do
        ActionView::Base.include(Decidim::Emitter::EmitterHelper)
        Decidim::ViewModel.include(Decidim::Emitter::EmitterHelper)
      end

      initializer "decidim.emitter.add_cells_view_paths" do
        Cell::ViewModel.view_paths.prepend File.expand_path("#{Decidim::Emitter::Engine.root}/app/views")
        Cell::ViewModel.view_paths.prepend File.expand_path("#{Decidim::Emitter::Engine.root}/app/cells")
      end

      initializer "Emitter.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim.emitter.overrides" do
        config.to_prepare do
          Decidim::ParticipatoryProcess.include Decidim::Emitter::ParticipatoryProcessOverride
          Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessForm.include Decidim::Emitter::Admin::ParticipatoryProcessFormOverride
          Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcess.include Decidim::Emitter::ParticipatoryProcesses::Admin::CreateParticipatoryProcessOverride
          Decidim::ParticipatoryProcesses::Admin::CopyParticipatoryProcess.include Decidim::Emitter::ParticipatoryProcesses::Admin::CopyParticipatoryProcessOverride
          Decidim::ParticipatoryProcesses::Admin::UpdateParticipatoryProcess.include Decidim::Emitter::ParticipatoryProcesses::Admin::UpdateParticipatoryProcessOverride
        end
      end
    end
  end
end
