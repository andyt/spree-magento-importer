require 'tree'

require 'integration/spec_helper'
require 'spree_magento_importer/taxonomy_backend_core'

module SpreeMagentoImporter
  describe TaxonomyBackendCore do
    let(:magento_category) { double('MagentoCategory', id: 1, name: 'A category', parent_id: nil) }

    describe '#import' do
      def node_for(name)
        Tree::TreeNode.new(name, double(name, name: name))
      end

      let(:tree) do
        node_for('root').tap do |root|
          %w(child1 child2).each do |name|
            root << node_for(name) << node_for("grandchild of #{name}")
          end
        end
      end

      let(:backend) { TaxonomyBackendCore.new }

      it 'creates a taxonomy using the tree root name, and returns it' do
        result = backend.import(tree)

        expect(result).to be_a Spree::Taxonomy
        expect(result.name).to eq 'root'
      end

      it 'adds taxons to the taxonomy' do
        taxonomy = backend.import(tree)

        taxonomy.reload

        expect(taxonomy.root.name).to eq 'root'
        expect(Spree::Taxon.count).to eq 5
        expect(taxonomy.taxons.count).to eq 5

        expect(taxonomy.root.children.count).to eq 2
        expect(taxonomy.root.children[0].children.count).to eq 1
        expect(taxonomy.root.children[1].children.count).to eq 1
      end

      context 'when the taxonomy exists' do
        before do
          Spree::Taxonomy.create(name: tree.root.content.name)
        end

        it 'raises an error' do
          expect { backend.import(tree) }.to raise_error(RuntimeError)
        end
      end
    end
  end
end
