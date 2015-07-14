require 'spec_helper'
require 'spree_magento_importer/product_importer'

module SpreeMagentoImporter
  describe ProductImporter do
    let(:importer) do
      ProductImporter.new(fixture, backend)
    end

    let(:backend) do
      instance_double('ProductBackendCore')
    end

    let(:magento_product) { double(MagentoProduct, sku: '1234') }

    describe '#import' do
      context 'for a simple product' do
        let(:fixture) { File.expand_path('../../../fixtures/one_simple_product.csv', __FILE__) }

        it 'creates a MagentoProduct with an appropriate hash' do
          expect(MagentoProduct).to receive(:new).with(
            hash_including(
              'store' => 'freeborn',
              'websites' => 'base',
              'attribute_set' => 'Default',
              'type' => 'simple',
              'category_ids' => '5,32,151,189,380,382,886,893,922',
              'url' => 'http://dev.freeborn.co.uk/shimano-saint-m810-m815-single-crank-arms?___store=freeborn',
              'sku' => 'FCM820A',
              'has_options' => '1',
              'name' => 'Shimano Saint M820 / M825 Single Crank Arms',
              'price' => '189.9900',
              'special_price' => '151.9900'
            )
          ).and_return(magento_product)

          expect(magento_product).to receive(:spree_product_params).and_return(:product_params)
          expect(magento_product).to receive(:spree_product_options).and_return(:product_options)
          expect(magento_product).to receive(:image_paths).and_return(:image_paths)

          expect(backend).to receive(:import).with(:product_params, :product_options, :image_paths)

          importer.import
        end
      end
    end
  end
end
