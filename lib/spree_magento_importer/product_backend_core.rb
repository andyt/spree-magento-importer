require 'spree/core/importer'

module SpreeMagentoImporter
  class ProductBackendCore
    def import(product_params, product_options, image_paths = [])
      product = Spree::Core::Importer::Product.new(nil, product_params, product_options).create

      return false unless product.persisted?

      image_paths.each do |image|
        File.open(image, 'r') do |file|
          product.images << Spree::Image.new(attachment: file)
        end
      end

      true
    end
  end
end
