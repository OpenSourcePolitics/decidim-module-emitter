# frozen_string_literal: true

require "spec_helper"
module Decidim
  module Emitter
    describe EmitterHelper do
      describe "#emitter_options" do
        subject { helper.emitter_options }
        let(:organization) { create(:organization) }
        let(:emitter_names) { %w(Abidjan London Tokyo) }
        let(:emitter) { upload_test_file(Decidim::Dev.test_file("city.jpeg", "image/jpeg")) }
        let!(:participatory_process) { create(:participatory_process, emitter_name: "Berlin", emitter: emitter, organization: organization) }

        before do
          emitter_names.each do |emitter_name|
            create(:participatory_process, emitter_name: emitter_name, emitter: emitter, organization: organization)
          end
          allow_any_instance_of(ActionView::Base).to receive(:current_organization).and_return(organization)
        end

        it "returns an array with the emitter name, id and image path" do
          expect(subject.count).to eq 4
          expect(subject.first).to eq ["Berlin", participatory_process.id, { "data-image": "/rails/active_storage/blobs/redirect/#{emitter}/city.jpeg" }]
        end
      end
    end
  end
end
