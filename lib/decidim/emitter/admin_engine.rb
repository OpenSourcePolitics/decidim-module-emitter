# frozen_string_literal: true

module Decidim
  module Emitter
    # This is the engine that runs on the public interface of `Emitter`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Emitter::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :emitter do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "emitter#index"
      end

      def load_seed
        nil
      end
    end
  end
end
