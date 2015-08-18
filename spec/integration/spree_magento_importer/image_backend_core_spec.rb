require 'integration/spec_helper'
require 'spree_magento_importer/image_backend_core'

module SpreeMagentoImporter
  describe ImageBackendCore do
    let(:existing_images) { spy('images association') }
    let(:product) { instance_double(Spree::Product, images: existing_images, sku: '1234', persisted?: true) }
    let(:image) { instance_spy(Spree::Image) }
    let(:image_path) { fixture_subpath('media/catalog/f/c/fcm825a.jpg') }

    describe '#import' do
      let(:backend) { ImageBackendCore.new }

      before do
        allow(File).to receive(:open).with(image_path, 'r').and_return(:file)
        allow(existing_images).to receive(:build).with(attachment: :file).and_return(image)
      end

      it 'imports' do
        expect(backend.import(product, image_path)).to eq true

        expect(existing_images).to have_received(:<<).with(image)
      end

      it 'ignores Paperclip::Errors::NotIdentifiedByImageMagickError errors' do
        allow(existing_images).to receive(:<<) { fail Paperclip::Errors::NotIdentifiedByImageMagickError }

        expect { backend.import(product, image_path) }.not_to raise_error
      end

      context 'with an unpersisted product' do
        before do
          allow(product).to receive(:persisted?).and_return(false)
        end

        it 'raises an ArgumentError' do
          expect { backend.import(product, image_path) }.to raise_error ArgumentError
        end
      end
    end
  end
end
