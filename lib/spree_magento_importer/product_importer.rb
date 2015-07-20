require 'csv'

require 'spree_magento_importer/magento_product'
require 'spree_magento_importer/logger'

module SpreeMagentoImporter
  # Iterates over a Magento product export and uses backend instances to import MagentoProduct data and images into Spree.
  class ProductImporter
    def initialize(file, product_backend, image_backend)
      @file = file
      @product_backend = product_backend
      @image_backend = image_backend
    end

    def import
      CSV.foreach(@file, headers: true) do |row|
        magento_product = magento_product_from_row(row)
        next unless magento_product

        spree_product = @product_backend.import(magento_product.spree_product_params, magento_product.spree_product_options)

        magento_product.image_paths.each do |image|
          @image_backend.import(spree_product, image)
        end
      end
    end

    private

    def magento_product_from_row(row)
      MagentoProduct.new(row.to_h)
    rescue ArgumentError => e
      Logger.warn e.message
      nil
    end
  end
end
