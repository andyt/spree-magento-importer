require 'spree_magento_importer/logger'

module SpreeMagentoImporter
  class ImageBackendCore
    def import(product, image)
      file = File.open(image, 'r')
      image = product.images.build(attachment: file)

      if image.save
        Logger.info "#{product.sku}: created #{image.attachment_file_name}."
      else
        Logger.warn "#{product.sku}: image errors: #{image.errors.full_messages}."
      end
    rescue Errno::ENOENT, Errno::EISDIR
      Logger.warn "#{product.sku}: missing #{image}."
    end
  end
end
