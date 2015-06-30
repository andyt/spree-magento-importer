namespace :spree_magento_importer do
  desc 'Import from tmp/import/export_all_products.csv'
  task :import do
    require 'spree_magento_importer'

    file = File.join(Dir.pwd, 'tmp', 'import', 'export_all_products.csv')
    backend = SpreeMagentoImporter::SpreeCoreBackend.new
    importer = SpreeMagentoImporter::ProductImporter.new(file, backend)

    importer.import
  end
end
