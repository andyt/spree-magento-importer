require 'spree_magento_importer/logger'

module SpreeMagentoImporter
  class TaxonomyBackendCore
    def import(tree)
      taxonomy_name = tree.root.content.name

      fail "Taxonomy #{taxonomy_name} exists!" if Spree::Taxonomy.find_by(name: taxonomy_name)

      Spree::Taxonomy.create!(name: taxonomy_name).tap do |taxonomy|
        recursively_add_children_to_taxon(taxonomy.root, tree.root.children)
      end
    end

    private

    def recursively_add_children_to_taxon(taxon, children)
      children.each do |node|
        child_taxon = Spree::Taxon.create!(name: node.content.name, taxonomy: taxon.taxonomy)
        taxon.children << child_taxon

        recursively_add_children_to_taxon(child_taxon, node.children) unless node.children.empty?
      end
    end
  end
end
