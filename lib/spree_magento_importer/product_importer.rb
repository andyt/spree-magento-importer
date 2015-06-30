require 'csv'
require 'logger'

require 'spree_magento_importer/magento_product'

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
          logger.warn e.message
        else
          @backend.import(magento_product.spree_product_params, magento_product.spree_product_options)
        end
      end
    end

    private

    def logger
      @logger ||= Logger.new(STDOUT).tap { |l| l.formatter = formatter }
    end

    def formatter
      proc { |_severity, _datetime, _progname, msg| msg }
    end
  end
end
