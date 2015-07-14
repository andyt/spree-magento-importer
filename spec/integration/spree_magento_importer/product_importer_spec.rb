require 'integration/spec_helper'
require 'spree_magento_importer/product_importer'
require 'spree_magento_importer/product_backend_core'

module SpreeMagentoImporter
  describe 'ProductImporter with ProductBackendCore', :dummy_app, db: :isolate  do
    before(:all) { MagentoProduct.image_path = Pathname(__dir__).parent.parent + 'fixtures/media/catalog' }

    let(:backend) { SpreeMagentoImporter::ProductBackendCore.new }
    let(:importer) { ProductImporter.new(fixture, backend) }

    def products(force = false)
      @products = nil if force
      @products ||= Spree::Product.all
    end

    let(:product) { products.first }
    let(:image) { product.images.first }

    describe '#import' do
      context 'for a simple product' do
        let(:fixture) { Pathname(__dir__) + '../../fixtures/one_simple_product.csv' }

        it 'creates a Spree product with the correct name, MSRP, price and image' do
          importer.import

          expect(products.count).to eq 1

          expect(product.name).to eq 'Shimano Saint M820 / M825 Single Crank Arms'
          expect(product.msrp).to eq BigDecimal.new('189.99')
          expect(product.price).to eq BigDecimal.new('151.99')

          expect(product.images.count).to eq 1
          expect(Pathname(image.attachment.path).exist?).to eq true
        end

        it 'has duplicate detection' do
          importer.import
          importer.import

          expect(products.count).to eq 1
        end
      end

      context 'for a grouped product' do
        let(:fixture) { File.expand_path('../../../fixtures/one_grouped_product.csv', __FILE__) }

        it 'handles exceptions and imports no products' do
          importer.import

          expect(products.count).to eq 0
        end
      end
    end
  end
end
