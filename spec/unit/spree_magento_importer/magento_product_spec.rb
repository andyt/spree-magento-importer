require 'spec_helper'
require 'spree_magento_importer/magento_product'

module SpreeMagentoImporter
  describe MagentoProduct do
    before(:all) { MagentoProduct.image_path = Pathname(__dir__).parent.parent + 'fixtures' }

    let(:magento_product) { MagentoProduct.new(attributes) }

    context 'with a simple product' do
      let(:attributes) do
        {
          name: 'Name',
          type: 'simple',
          visibility: 'Catalog, Search',
          short_description: 'Short description',
          description: 'Description',
          sku: '1234',
          price: '15.9900',
          special_price: '10.9900',
          image: '/media/catalog/f/c/fcm825a.jpg'
        }
      end

      describe '#spree_product_params' do
        let(:available_on) { Time.now }

        it 'returns a hash of params' do
          allow(Time).to receive(:now).and_return available_on

          expect(magento_product.spree_product_params).to eq(
            available_on: available_on,
            name: 'Name',
            description: "Short description\n\nDescription",
            sku: '1234',
            msrp: '15.9900',
            price: '10.9900',
            shipping_category_id: 1
          )
        end
      end

      describe '#image_filepaths' do
        it 'returns an array of image filepaths' do
          expect(magento_product.image_paths.first.to_s).to end_with '/spec/fixtures/media/catalog/f/c/fcm825a.jpg'
        end
      end

      context 'that is part of a grouped product' do
        let(:attributes) do
          {
            type: 'simple',
            visibility: 'Not Visible Individually'
          }
        end

        describe '.new' do
          it 'raises an ArgumentError' do
            expect { magento_product }.to raise_error(ArgumentError)
          end
        end
      end
    end

    context 'with a grouped product' do
      let(:attributes) do
        {
          type: 'grouped'
        }
      end

      describe '.new' do
        it 'raises an ArgumentError' do
          expect { magento_product }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
