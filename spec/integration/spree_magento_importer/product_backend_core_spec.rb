require 'integration/spec_helper'
require 'spree_magento_importer/product_backend_core'

module SpreeMagentoImporter
  describe ProductBackendCore do
    let(:spree_core_importer_product) { instance_double(Spree::Core::Importer::Product) }
    let(:product) { instance_double(Spree::Product, persisted?: true, images: []) }
    let(:image) { File.expand_path('../../../fixtures/media/catalog/f/c/fcm825a.jpg', __FILE__) }

    describe '#import' do
      it 'imports using Spree::Core::Importer::Product' do
        backend = ProductBackendCore.new
        expect(Spree::Core::Importer::Product).to receive(:new).with(nil, {}, {}).and_return(spree_core_importer_product)
        expect(spree_core_importer_product).to receive(:create).and_return(product)
        expect(Spree::Image).to receive(:new) { |attrs| attrs[:attachment].is_a? File }

        expect(backend.import({}, {}, [image])).to eq true
      end
    end
  end
end
