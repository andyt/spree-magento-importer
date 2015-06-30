require 'integration/spec_helper'
require 'spree_magento_importer/product_importer'

module SpreeMagentoImporter
  describe ProductImporter do
    let(:importer) do
      ProductImporter.new(fixture)
    end

    describe '#import' do
      context 'for a simple product' do
        let(:fixture) { File.expand_path('../../../fixtures/one_simple_product.csv', __FILE__) }

        it 'creates a Spree product with the correct name, MSRP and price' do
          importer.import

          products = Spree::Product.all
          expect(products.count).to eq 1

          product = products.first
          expect(product.name).to eq 'Shimano Saint M820 / M825 Single Crank Arms'

          # require 'pry'; binding.pry

          expect(product.msrp).to eq BigDecimal.new('189.99')
          expect(product.price).to eq BigDecimal.new('151.99')
        end
      end
    end
  end
end
