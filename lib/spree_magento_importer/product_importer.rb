require 'csv'

require 'spree_magento_importer/magento_product'
require 'spree_magento_importer/logger'

module SpreeMagentoImporter
  # Iterates over a Magento product export and uses a Backend class to import MagentoProduct instances into Spree.
  class ProductImporter
    def initialize(file, backend)
      @file = file
      @backend = backend
    end

    def import
      CSV.foreach(@file, headers: true).with_index do |row, _index|
        begin
          magento_product = MagentoProduct.new(row.to_h)
        rescue ArgumentError => e
          Logger.warn e.message
        else
          @backend.import(magento_product.spree_product_params, magento_product.spree_product_options, magento_product.image_paths)
        end
      end
    end
  end
end
