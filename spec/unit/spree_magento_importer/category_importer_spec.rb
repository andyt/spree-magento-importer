require 'spec_helper'
require 'spree_magento_importer/category_importer'
require 'spree_magento_importer/taxonomy_backend_core'

module SpreeMagentoImporter
  describe CategoryImporter do
    let(:importer) do
      CategoryImporter.new(fixture, taxonomy_backend)
    end

    let(:fixture) { fixture_subpath('categories.csv') }

    let(:taxonomy_backend) { instance_spy(TaxonomyBackendCore) }

    before do
      allow(taxonomy_backend).to receive(:import).and_return(true)
    end

    describe '#tree' do
      it 'creates a tree representing categories' do
        expect(importer.send(:tree)).to be_a Tree::TreeNode
      end
    end

    describe '#import' do
      it 'uses the backend to import the tree' do
        expect(importer).to receive(:tree).and_return(:the_tree)

        importer.import

        expect(taxonomy_backend).to have_received(:import).with(:the_tree)
      end
    end
  end
end
