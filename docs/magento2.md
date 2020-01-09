## updating with composer
php bin/magento maintenance:enable
composer require magento/product-community-edition 2.3.2 --no-update
composer update
rm -rf var/di var/generation
php bin/magento cache:flush
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento indexer:reindex
php bin/magento maintenance:disable
php bin/magento --version
