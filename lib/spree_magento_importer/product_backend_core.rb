require 'spree/core/importer'

require 'spree_magento_importer/logger'

module SpreeMagentoImporter
  class ProductBackendCore
    def import(product_params, product_options, image_paths = [])
      product = Spree::Core::Importer::Product.new(nil, product_params, product_options).create

      if product.persisted?
        Logger.info "#{product.sku}: imported."
      else
        Logger.info "#{product.sku}: not persisted: #{product.errors.full_messages}"
        return false
      end

      image_paths.each { |image| create_image(product, image) }

      true
    end

    private

    def create_image(product, image)
      File.open(image, 'r') do |file|
        image = product.images.build(attachment: file)

        if image.save
          Logger.info "#{product.sku}: created #{image.attachment_file_name}."
        else
          Logger.warn "#{product.sku}: image errors: #{image.errors.full_messages}."
        end
      end
    rescue Errno::ENOENT, Errno::EISDIR
      Logger.warn "#{product.sku}: missing #{image}."
    end
  end
end
