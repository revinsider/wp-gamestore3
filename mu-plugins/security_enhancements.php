<?php
/**
 * Plugin Name:
 */

# Author Slug Hardening
add_action('init', function(){
	if (get_option('_nicename_hardened')) return; // run once
	wp_update_user(['ID' => 1, 'user_nicename' => 'gamestoreadmin']);
	update_option('_nicename_hardened', 1);
});

add_action('template_redirect', function(){
	if (is_author() && preg_match('/author=([0-9]+)/', $_SERVER['QUERY_STRING'] ?? '')) {
		wp_redirect(home_url(), 301);
		exit;
	}
});