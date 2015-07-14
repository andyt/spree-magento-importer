require 'spree/core/importer'

module SpreeMagentoImporter
  class ProductBackendCore
    def import(product_params, product_options)
      product = Spree::Core::Importer::Product.new(nil, product_params, product_options).create
      product.persisted?
    end
  end
end
