# frozen_string_literal: true

require "spec_helper"

module Decidim::ParticipatoryProcesses
  describe Admin::DuplicateParticipatoryProcess do
    subject { described_class.new(form, participatory_process) }

    let(:organization) { create(:organization) }
    let(:current_user) { create(:user, organization:) }
    let(:participatory_process_group) { create(:participatory_process_group, organization:) }
    let(:taxonomy) { create(:taxonomy, with_parent, organization:) }
    let(:errors) { double.as_null_object }
    let!(:participatory_process) { create(:participatory_process, :with_steps) }
    let!(:component) { create(:component, manifest_name: :dummy, participatory_space: participatory_process) }
    let(:form) do
      instance_double(
        Admin::ParticipatoryProcessDuplicateForm,
        invalid?: invalid,
        title: { en: "title" },
        slug: "copied-slug",
        duplicate_steps?: duplicate_steps,
        duplicate_categories?: duplicate_categories,
        duplicate_components?: duplicate_components,
        current_user:
      )
    end
    let!(:category) do
      create(
        :category,
        participatory_space: participatory_process
      )
    end

    let(:invalid) { false }
    let(:duplicate_steps) { false }
    let(:duplicate_categories) { false }
    let(:duplicate_components) { false }

    context "when the form is not valid" do
      let(:invalid) { true }

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when everything is ok" do
      it "duplicates a participatory process" do
        expect { subject.call }.to change(Decidim::ParticipatoryProcess, :count).by(1)

        old_participatory_process = Decidim::ParticipatoryProcess.first
        new_participatory_process = Decidim::ParticipatoryProcess.last

        expect(new_participatory_process.slug).to eq("copied-slug")
        expect(new_participatory_process.title["en"]).to eq("title")
        expect(new_participatory_process).not_to be_published
        expect(new_participatory_process.organization).to eq(old_participatory_process.organization)
        expect(new_participatory_process.subtitle).to eq(old_participatory_process.subtitle)
        expect(new_participatory_process.description).to eq(old_participatory_process.description)
        expect(new_participatory_process.short_description).to eq(old_participatory_process.short_description)
        expect(new_participatory_process.promoted).to eq(old_participatory_process.promoted)
        expect(new_participatory_process.scope).to eq(old_participatory_process.scope)
        expect(new_participatory_process.developer_group).to eq(old_participatory_process.developer_group)
        expect(new_participatory_process.local_area).to eq(old_participatory_process.local_area)
        expect(new_participatory_process.target).to eq(old_participatory_process.target)
        expect(new_participatory_process.participatory_scope).to eq(old_participatory_process.participatory_scope)
        expect(new_participatory_process.meta_scope).to eq(old_participatory_process.meta_scope)
        expect(new_participatory_process.end_date).to eq(old_participatory_process.end_date)
        expect(new_participatory_process.participatory_process_group).to eq(old_participatory_process.participatory_process_group)
        expect(new_participatory_process.private_space).to eq(old_participatory_process.private_space)
        expect(new_participatory_process.emitter_name).to eq(old_participatory_process.emitter_name)
        expect(new_participatory_process.taxonomies).to eq(old_participatory_process.taxonomies)
      end

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "traces the action", :versioning do
        expect(Decidim.traceability)
          .to receive(:perform_action!)
          .with("duplicate", Decidim::ParticipatoryProcess, current_user)
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)
        action_log = Decidim::ActionLog.last
        expect(action_log.action).to eq("duplicate")
        expect(action_log.version).to be_present
      end
    end

    context "when duplicate_steps exists" do
      let(:duplicate_steps) { true }

      it "duplicates a participatory process and the steps" do
        expect { subject.call }.to change(Decidim::ParticipatoryProcessStep, :count).by(1)
        expect(Decidim::ParticipatoryProcessStep.distinct.pluck(:decidim_participatory_process_id).count).to eq 2

        old_participatory_process_step = Decidim::ParticipatoryProcessStep.first
        new_participatory_process_step = Decidim::ParticipatoryProcessStep.last

        expect(new_participatory_process_step.title).to eq(old_participatory_process_step.title)
        expect(new_participatory_process_step.description).to eq(old_participatory_process_step.description)
        expect(new_participatory_process_step.end_date).to eq(old_participatory_process_step.end_date)
        expect(new_participatory_process_step.start_date).to eq(old_participatory_process_step.start_date)
      end
    end

    context "when duplicate_categories exists" do
      let(:duplicate_categories) { true }

      it "duplicates a participatory process and the categories" do
        expect { subject.call }.to change(Decidim::Category, :count).by(1)
        expect(Decidim::Category.unscoped.distinct.pluck(:decidim_participatory_space_id).count).to eq 2

        old_participatory_process_category = Decidim::Category.unscoped.first
        new_participatory_process_category = Decidim::Category.unscoped.last

        expect(new_participatory_process_category.name).to eq(old_participatory_process_category.name)
        expect(new_participatory_process_category.description).to eq(old_participatory_process_category.description)
        expect(new_participatory_process_category.participatory_space).not_to eq(participatory_process)
      end

      context "with subcategories" do
        let!(:subcategory) { create(:category, parent: category, participatory_space: participatory_process) }

        it "duplicates the parent and its children" do
          expect { subject.call }.to change(Decidim::Category, :count).by(2)
          new_participatory_process = Decidim::ParticipatoryProcess.last

          expect(participatory_process.categories.count).to eq(2)
          expect(new_participatory_process.categories.count).to eq(2)
        end
      end
    end

    context "when duplicate_components exists" do
      let(:duplicate_components) { true }

      it "duplicates a participatory process and the components" do
        dummy_hook = proc {}
        component.manifest.on :duplicate, &dummy_hook
        expect(dummy_hook).to receive(:call).with({ new_component: an_instance_of(Decidim::Component), old_component: component })

        expect { subject.call }.to change(Decidim::Component, :count).by(1)

        last_participatory_process = Decidim::ParticipatoryProcess.last
        last_component = Decidim::Component.reorder(:id).last

        expect(last_component.participatory_space).to eq(last_participatory_process)
        expect(last_component.name).to eq(component.name)
        expect(last_component.settings.attributes.except("dummy_global_translatable_text")).to eq(component.settings.attributes.except("dummy_global_translatable_text"))
        expect(last_component.settings.attributes["dummy_global_translatable_text"]).to include(component.settings.attributes["dummy_global_translatable_text"])
        expect(last_component.step_settings.keys).not_to eq(component.step_settings.keys)
        expect(last_component.step_settings.values).not_to eq(component.step_settings.values)
      end
    end
  end
end
