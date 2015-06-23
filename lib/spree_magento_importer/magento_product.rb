require 'spree/core/importer'

module SpreeMagentoImporter
  # Models a MagentoProduct from a CSV hash and imports into Spree.
  class MagentoProduct
    attr_accessor :name, :sku, :price, :shipping_category_id

    def initialize(hash)
      @hash = hash

      @hash.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end

    def import!
      @product = Spree::Core::Importer::Product.new(nil, product_params, product_options).create

      @product.persisted?
    end

    private

    def product_params
      {
        available_on: Time.now,
        name: name,
        description: description,
        sku: sku,
        price: price,
        shipping_category_id: shipping_category_id || 1
      }
    end

    # Spree doesn't have a short_description field.
    def description
      [@short_description, @description].join("\n\n")
    end

    def product_options
      {
        variants_attrs: [],
        options_attrs: []
      }
    end
  end
end
