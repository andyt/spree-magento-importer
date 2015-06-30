module SpreeMagentoImporter
  # Models a MagentoProduct from a CSV hash and imports into Spree.
  class MagentoProduct
    attr_reader :hash

    def initialize(hash)
      @hash = hash

      @hash.each do |k, v|
        instance_variable_set("@#{k}", v)
      end

      fail ArgumentError, "Unhandled type: #{@type.inspect}" unless @type == 'simple'
    end

    def spree_product_params
      {
        available_on: Time.now,
        name: @name,
        description: merged_description,
        sku: @sku,
        msrp: @price,
        price: @special_price || @price,
        shipping_category_id: @shipping_category_id || 1
      }
    end

    def spree_product_options
      {
        variants_attrs: [],
        options_attrs: []
      }
    end

    private

    # Spree doesn't have a short_description field.
    def merged_description
      [@short_description, @description].join("\n\n")
    end
  end
end
