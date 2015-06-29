require 'integration/spec_helper'
require 'spree_magento_importer/magento_product'

module SpreeMagentoImporter
  describe MagentoProduct, :dummy_app, db: :isolate do
    let(:magento_product) do
      MagentoProduct.new(
        name: 'Name',
        short_description: 'Short description',
        sku: '1234',
        price: '10.9900'
      )
    end

    describe '#import!' do
      it 'saves a Spree product' do
        expect(magento_product.import!).to eq true
      end

      it 'fails with duplicate products' do
        expect(magento_product.import!).to eq true
        expect(magento_product.import!).to eq false
      end
    end
  end
end
