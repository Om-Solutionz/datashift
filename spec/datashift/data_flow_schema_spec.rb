require File.dirname(__FILE__) + '/../spec_helper'

module DataShift

  RSpec.describe DataFlowSchema, type: :model do

    let(:data_flow_schema) { subject }

    let(:yaml_text) {
      x=<<-EOS
      data_flow_schema:
        nodes:
          - project_title:
              heading:
                source: "title"
                destination: "Title"
              operator: title
          - value_as_string:
              heading:
                destination: "Value:"
              operator: value_as_string
          - project_owner_budget:
              heading:
                destination: "Budget"
              operator: owner.budget
      EOS
      x
    }

    let(:node_tags) { %w{ project_title value_as_string project_owner_budget } }

    context "DataFlowSchema" do

      context("YAML (LOCALE) DSL") do

        before(:each) do
          @collection = data_flow_schema.prepare_from_string(yaml_text)
        end

        it "build node collection from a locale based DSL" do
          expect(@collection).to be_instance_of NodeCollection
          expect(@collection.size).to eq node_tags.size
        end

        it "each section is an instance of Node" do
          @collection = data_flow_schema.prepare_from_string(yaml_text)
          expect(@collection.first).to be_instance_of DataShift::Node
        end

      it "should preserve order of the nodes" do
         @collection.each_with_index {|n, i| expect(n.tag).to eq node_tags[i] }

         tags = @collection.collect(&:tag)

         expect(tags).to eq node_tags
      end
=begin
      it "each row contains columns required to build view" do
        review_data_column = review_data_sections.first.rows.first

        expect(review_data_column).to be_instance_of Struct::ReviewDataRow

        expect(review_data_column.title).to be_instance_of String
        expect(review_data_column.link_state).to be_instance_of String
      end

      context("Specific YAML") do
        include_examples "clear_and_after_reload_yaml"

        it "can access methods directly on the model" do
          I18n.backend.store_translations(:en, YAML.load(simple_review_farming_yaml))

          expect(I18n.exists?("enrollment_review")).to eq true

          review_data_list = enrollment_review.prepare_from_locale(enrollment)

          expect(review_data_list.size).to eq 1

          review_data_section = review_data_list.first

          expect(review_data_section.heading).to eq "Farming data"
          expect(review_data_section.rows.size).to eq 2

          row = review_data_section.rows.first

          expect(row).to be_instance_of Struct::ReviewDataRow
          expect(row.data).to eq enrollment.on_a_farm?
        end

        it "can access methods on an association of the model", fail: true do
          I18n.backend.store_translations(:en, YAML.load(direct_and_association_review_yaml))

          expect(I18n.exists?("enrollment_review")).to eq true

          review_data_list = enrollment_review.prepare_review_data_list

          expect(review_data_list.size).to eq 2 # 2 sections
          review_data_section = review_data_list.last

          expect(review_data_section.heading).to eq "Waste Exemption Codes"
          expect(review_data_section.rows.size).to eq enrollment.exemptions.count

          row = review_data_section.rows.first

          expect(row).to be_instance_of Struct::ReviewDataRow

          expect(row.data).to eq enrollment.exemptions.first.code
          expect(row.link_state).to eq "bad_link"

          expect(row.target(enrollment)).to include "/reviews/"
          expect(row.target(enrollment)).to include "/bad_link/"
          expect(row.target(enrollment)).to include enrollment.id.to_s
        end

        context("association and method chaining") do
          before(:each) do
            I18n.backend.store_translations(:en, YAML.load(chained_review_yaml))
          end

          let(:review_data_list) { enrollment_review.prepare_review_data_list }

          it "can access associated object down the whole association chain on model" do
            expect(review_data_list.size).to eq 2
            organisation_address_section = review_data_list.first

            row = organisation_address_section.rows.first

            expect(row.data).to eq enrollment.organisation.contact.email_address
          end

          it "can access methods down the whole association chain on model" do
            expect(review_data_list.size).to eq 2
            applicant_contact_section = review_data_list.last

            row = applicant_contact_section.rows.first

            expect(row.data).to eq enrollment.applicant_contact.business_number.tel_number
          end
        end
      end
    end
=end
      end
    end
  end
end
