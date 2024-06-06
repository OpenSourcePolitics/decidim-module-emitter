# frozen_string_literal: true

require "decidim/emitter/admin"
require "decidim/emitter/engine"
require "decidim/emitter/admin_engine"
require "decidim/emitter/component"

module Decidim
  # This namespace holds the logic of the `Emitter` component. This component
  # allows users to create emitter in a participatory space.
  module Emitter
    include ActiveSupport::Configurable

    # Public: The configuration to exclude extends from the engine.
    # [:participatory_process, :participatory_process_form, :participatory_process_create, :participatory_process_copy, :participatory_process_update]
    config_accessor :exclude_extends do
      []
    end

    def self.skip_extend?(extend_sym)
      extend_sym.in?(exclude_extends)
    end
  end
end
