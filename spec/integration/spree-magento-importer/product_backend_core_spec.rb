require 'integration/spec_helper'
require 'spree_magento_importer/product_backend_core'

module SpreeMagentoImporter
  describe ProductBackendCore do
    let(:spree_core_importer_product) { instance_double(Spree::Core::Importer::Product) }
    let(:product) { instance_double(Spree::Product, persisted?: true) }

    describe '#import' do
      it 'imports using Spree::Core::Importer::Product' do
        backend = ProductBackendCore.new
        expect(Spree::Core::Importer::Product).to receive(:new).with(nil, {}, {}).and_return(spree_core_importer_product)
        expect(spree_core_importer_product).to receive(:create).and_return(product)

        expect(backend.import({}, {})).to eq true
      end
    end
  end
end
