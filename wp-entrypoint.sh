#!/bin/bash
set -e

./wait-for-it.sh $WP_DB_HOST:$WP_DB_PORT -- mysql -h $WP_DB_HOST -u $WP_DB_USER -p$WP_DB_PASS $WP_DB_NAME < db_dump/penkit-wp-$WP_VERSION.sql
source /etc/apache2/envvars
apache2 -DFOREGROUND
