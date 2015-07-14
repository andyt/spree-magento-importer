namespace :spree_magento_importer do
  desc 'Import from tmp/import/export_all_products.csv'
  task import: [:environment] do
    require 'spree_magento_importer'

    import_path = Pathname(Dir.pwd) + 'tmp' + 'import'
    file = import_path + 'export_all_products.csv'

    SpreeMagentoImporter::MagentoProduct.image_path = Pathname(import_path) + 'media/catalog/product'

    product_backend = SpreeMagentoImporter::ProductBackendCore.new
    image_backend = SpreeMagentoImporter::ImageBackendCore.new
    importer = SpreeMagentoImporter::ProductImporter.new(file, product_backend, image_backend)

    importer.import
  end
end
