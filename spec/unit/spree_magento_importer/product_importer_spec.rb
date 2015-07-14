require 'spec_helper'
require 'spree_magento_importer/product_importer'
require 'spree_magento_importer/product_backend_core'
require 'spree_magento_importer/image_backend_core'

module SpreeMagentoImporter
  describe ProductImporter do
    let(:importer) do
      ProductImporter.new(fixture, product_backend, image_backend)
    end

    let(:product_backend) { instance_spy(ProductBackendCore) }
    let(:image_backend) { instance_spy(ImageBackendCore) }

    let(:magento_product) do
      instance_double(
        MagentoProduct,
        sku: '1234',
        spree_product_params: :product_params,
        spree_product_options: :product_options,
        image_paths: ['path/to/image.jpg']
      )
    end

    let(:spree_product) { double('Spree::Product', persisted?: true) }

    before do
      allow(product_backend).to receive(:import).and_return(spree_product)
    end

    describe '#import' do
      context 'for a simple product' do
        let(:fixture) { Pathname(__dir__).parent.parent + 'fixtures/one_simple_product.csv' }

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

          importer.import
        end

        it 'uses the backends to create a product and image' do
          allow(MagentoProduct).to receive(:new).and_return(magento_product)

          importer.import

          expect(product_backend).to have_received(:import).with(:product_params, :product_options)
          expect(image_backend).to have_received(:import).with(spree_product, 'path/to/image.jpg')
        end

        context 'for Spree products that were not persisted' do
          let(:spree_product) { double('Spree::Product', persisted?: false) }

          it 'does not add images' do
            allow(MagentoProduct).to receive(:new).and_return(magento_product)
            allow(product_backend).to receive(:import).and_return(spree_product)

            importer.import

            expect(product_backend).to have_received(:import).with(:product_params, :product_options)
            expect(image_backend).not_to have_received(:import)
          end
        end
      end
    end
  end
end
