<?php
/**
 * Plugin Name: Gamestore General
 * Description: Core Gamestore General Settings
 * Author: netblogger
 * Version: 1.0
 * Text Domain: gamestore
 */

function gamestore_remove_dashboard_widgets() {
    remove_meta_box( 'dashboard_right_now',   'dashboard', 'normal' );
    remove_meta_box( 'dashboard_activity',    'dashboard', 'normal' );
    remove_meta_box( 'dashboard_site_health', 'dashboard', 'normal' );
    remove_meta_box( 'dashboard_quick_press', 'dashboard', 'side'   );
    remove_meta_box( 'dashboard_primary',     'dashboard', 'side'   );
}
add_action( 'wp_dashboard_setup', 'gamestore_remove_dashboard_widgets', 999 );

remove_action( 'welcome_panel', 'wp_welcome_panel' );

