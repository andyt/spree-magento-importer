module SpreeMagentoImporter
  # Models a MagentoProduct from a CSV hash and imports into Spree.
  class MagentoProduct
    attr_reader :hash, :sku

    class << self
      attr_reader :image_path

      def image_path=(path)
        fail ArgumentError, "Path not found or not a directory: #{path}" unless Pathname(path).directory?

        @image_path = Pathname(path)
      end
    end

    def initialize(hash)
      @hash = hash

      @hash.each do |k, v|
        instance_variable_set("@#{k}", v)
      end

      fail ArgumentError, "#{@sku}: unhandled type #{@type.inspect}" unless @type == 'simple'
      fail ArgumentError, "#{@sku}: unhandled visibility #{@visibility.inspect}" unless @visibility == 'Catalog, Search'
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

    def image_paths
      return [] unless @image && !@image.empty?
      fail 'Set MagentoProduct.image_path to the folder containing images from Magento.' unless self.class.image_path

      [self.class.image_path + @image.gsub(%r{^/}, '')]
    end

    private

    # Spree doesn't have a short_description field.
    def merged_description
      [@short_description, @description].join("\n\n")
    end
  end
end
