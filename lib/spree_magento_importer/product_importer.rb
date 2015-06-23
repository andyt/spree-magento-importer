require 'csv'
require 'spree_magento_importer/magento_product'

module SpreeMagentoImporter
  # Iterates over a Magento product export and creates Product instances in Spree.
  class ProductImporter
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def import
      CSV.foreach(file, headers: true).with_index do |row, _index|
        magento_product = MagentoProduct.new(row.to_h)
        magento_product.import!
      end
    end
  end
end
