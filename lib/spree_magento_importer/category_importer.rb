require 'csv'
require 'tree'

require 'spree_magento_importer/logger'

module SpreeMagentoImporter
  MagentoCategory = Struct.new(:id, :name, :parent_id) do
    def to_node
      Tree::TreeNode.new("cat#{id}", self)
    end
  end

  # Iterates over a Magento category export to build a tree and uses a backend instance to import the tree into Spree.
  class CategoryImporter
    def initialize(file, taxonomy_backend)
      @file = file
      @taxonomy_backend = taxonomy_backend
    end

    def import
      @taxonomy_backend.import(tree)
    end

    private

    def tree
      return @tree if @tree

      nodes.each do |node|
        add_to_parent_node(node)
      end

      nodes.first
    end

    def add_to_parent_node(node)
      parent = nodes.detect { |n| n.content.id == node.content.parent_id }

      parent << node && return if parent

      # fail("Parent category #{node.content.parent_id} not found for node #{node.content.id}!") unless parent
      Logger.warn "Parent category #{node.content.parent_id} not found for node #{node.content.id}"
    end

    def nodes
      @nodes ||= magento_categories.map(&:to_node)
    end

    def magento_categories
      return @magento_categories if @magento_categories

      @magento_categories =
        CSV.foreach(@file, headers: true).with_object([]) do |row, categories|
          categories << magento_category_from_row(row)
        end
    end

    def magento_category_from_row(row)
      MagentoCategory.new(row['id'], row['name'], row['parent_id'])
    end
  end
end
