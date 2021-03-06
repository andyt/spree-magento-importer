require 'integration/spec_helper'
require 'spree_magento_importer/product_importer'
require 'spree_magento_importer/product_backend_core'
require 'spree_magento_importer/image_backend_core'

module SpreeMagentoImporter
  describe 'ProductImporter with ProductBackendCore', :dummy_app, db: :isolate do
    before(:all) { MagentoProduct.image_path = fixture_subpath('media/catalog') }

    let(:product_backend) { SpreeMagentoImporter::ProductBackendCore.new }
    let(:image_backend) { SpreeMagentoImporter::ImageBackendCore.new }
    let(:importer) { ProductImporter.new(fixture, product_backend, image_backend) }

    def products(force = false)
      @products = nil if force
      @products ||= Spree::Product.all
    end

    def image
      products(true).first.images.first
    end

    let(:product) { products.first }

    describe '#import' do
      context 'for a simple product' do
        let(:fixture) { fixture_subpath('one_simple_product.csv') }

        it 'creates a Spree product with the correct name, MSRP, price and image' do
          importer.import

          expect(products.count).to eq 1

          expect(product.name).to eq 'Shimano Saint M820 / M825 Single Crank Arms'
          expect(product.msrp).to eq BigDecimal.new('189.99')
          expect(product.price).to eq BigDecimal.new('151.99')

          expect(product.images.count).to eq 1
          expect(Pathname(image.attachment.path).exist?).to eq true
        end

        it 'does not create duplicate products or images' do
          importer.import
          original_image = image

          importer.import

          expect(products.count).to eq 1
          expect(Spree::Image.all.count).to eq 1
          expect(image.attachment_updated_at).to eq original_image.attachment_updated_at
        end
      end

      context 'for a grouped product' do
        let(:fixture) { fixture_subpath('one_grouped_product.csv') }

        it 'handles exceptions and imports no products' do
          importer.import

          expect(products.count).to eq 0
        end
      end
    end
  end
end
