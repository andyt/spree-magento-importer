require 'integration/spec_helper'
require 'spree_magento_importer/image_backend_core'

module SpreeMagentoImporter
  describe ImageBackendCore do
    let(:existing_images) { spy('images association') }
    let(:product) { instance_double(Spree::Product, images: existing_images, sku: '1234') }
    let(:image) { instance_spy(Spree::Image) }
    let(:image_path) { Pathname(__dir__).parent.parent + 'fixtures/media/catalog/f/c/fcm825a.jpg' }

    describe '#import' do
      it 'imports' do
        backend = ImageBackendCore.new
        expect(File).to receive(:open).with(image_path, 'r').and_return(:file)
        expect(existing_images).to receive(:build).with(attachment: :file).and_return(image)

        expect(backend.import(product, image_path)).to eq true

        expect(existing_images).to have_received(:<<).with(image)
      end
    end
  end
end
