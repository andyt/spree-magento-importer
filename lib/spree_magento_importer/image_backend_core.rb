require 'spree_magento_importer/logger'

module SpreeMagentoImporter
  class ImageBackendCore
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def import(product, image_path)
      fail ArgumentError, "Expected Pathname, got #{image.inspect}" unless image_path.is_a?(Pathname)
      fail ArgumentError, "Product #{product} has not been persisted" unless product.persisted?

      file = File.open(image_path, 'r')
      image = product.images.build(attachment: file)

      if product.images << image
        Logger.info "#{product.sku}: attached #{image.attachment_file_name}."
      else
        Logger.warn "#{product.sku}: image errors: #{image.errors.full_messages}."
      end
    rescue Errno::ENOENT, Errno::EISDIR
      Logger.warn "#{product.sku}: missing #{image_path}."
    rescue Paperclip::Errors::NotIdentifiedByImageMagickError
      Logger.warn "#{product.sku}: empty/corrupted #{image_path}."
    end
  end
end
