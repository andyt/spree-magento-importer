require 'integration/spec_helper'
require 'spree_magento_importer/product_importer'
require 'spree_magento_importer/spree_core_backend'

module SpreeMagentoImporter
  describe 'ProductImporter with SpreeCoreBackend', :dummy_app, db: :isolate  do
    let(:backend) { SpreeMagentoImporter::SpreeCoreBackend.new }
    let(:importer) { ProductImporter.new(fixture, backend) }

    def products(force = false)
      @products = nil if force
      @products ||= Spree::Product.all
    end

    let(:product) { products.first }

    describe '#import' do
      context 'for a simple product' do
        let(:fixture) { File.expand_path('../../../fixtures/one_simple_product.csv', __FILE__) }

        it 'creates a Spree product with the correct name, MSRP and price' do
          importer.import

          expect(products.count).to eq 1

          expect(product.name).to eq 'Shimano Saint M820 / M825 Single Crank Arms'
          expect(product.msrp).to eq BigDecimal.new('189.99')
          expect(product.price).to eq BigDecimal.new('151.99')
        end

        it 'has duplicate detection' do
          importer.import
          importer.import

          expect(products.count).to eq 1
        end
      end
    end
  end
end
