require 'integration/spec_helper'
require 'spree_magento_importer/image_backend_core'

module SpreeMagentoImporter
  describe ImageBackendCore do
    let(:relation) { double('images association') }
    let(:product) { instance_double(Spree::Product, images: relation, sku: '1234') }
    let(:image) { instance_spy(Spree::Image) }
    let(:image_path) { Pathname(__dir__).parent.parent + 'fixtures/media/catalog/f/c/fcm825a.jpg' }

    describe '#import' do
      it 'imports' do
        backend = ImageBackendCore.new
        expect(File).to receive(:open).with(image_path, 'r').and_return(:file)
        expect(relation).to receive(:build).with(attachment: :file).and_return(image)

        expect(backend.import(product, image_path)).to eq true

        expect(image).to have_received(:save)
      end
    end
  end
end
