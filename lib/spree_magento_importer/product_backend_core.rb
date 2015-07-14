require 'spree/core/importer'

require 'spree_magento_importer/logger'

module SpreeMagentoImporter
  class ProductBackendCore
    def import(product_params, product_options)
      product = Spree::Core::Importer::Product.new(nil, product_params, product_options).create

      if product.persisted?
        Logger.info "#{product.sku}: imported."
      else
        Logger.info "#{product.sku}: not persisted: #{product.errors.full_messages}"
      end

      product
    end
  end
end
