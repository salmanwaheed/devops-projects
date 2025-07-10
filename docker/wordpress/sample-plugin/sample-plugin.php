<?php
/**
 * Plugin Name: Sample Plugin
 * Description: A Sample plugin to confirm plugin loading and loopback.
 * Version: 1.0
 * Author: Salman Waheed
 */

add_action('init', function () {
  error_log('🧪 Sample Plugin Initialized!');
});

add_action('admin_notices', function () {
  echo '<div class="notice notice-success"><p><strong>Sample Plugin is active ✅</strong></p></div>';
});
