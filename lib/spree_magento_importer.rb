require 'spree/core'

begin
  require 'spree_msrp'
rescue LoadError
  raise %(spree_magento_importer requires spree_msrp. Add "gem 'spree_msrp', github: 'moholtzberg/spree_msrp', ref: '3-0-stable'" to your gemfile.)
end

require 'spree_magento_importer/product_importer'
require 'spree_magento_importer/spree_core_backend'
