<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'plus_privacy');

/** MySQL database username */
define('DB_USER', 'root');

/** MySQL database password */
define('DB_PASSWORD', 'root');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8mb4');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'KKtF+InZ( m9b^? 5~d54VmhIqg`QPp!6ojyNqEr{>hSt3vdX8YN$YtbfrMALA(3');
define('SECURE_AUTH_KEY',  'J8x{5UBh`d~x}h;XFGGPjU}I^Cl0m-ayqtuX/,8Kck8L5<C(d}jyU6y;T3uyTyP/');
define('LOGGED_IN_KEY',    '8cH]Z?Z}v5M<D1(3&~0aSX%sZCcWtV(}uI=ZF(X?},~D}P&UDxz-kj[Bpj={fj_v');
define('NONCE_KEY',        ':Au:[eIt<Rc_<63n(&>&-,,ZTmJj@i[lIU+(D:p+Blk?A)4@:&` U`8:<(M&todh');
define('AUTH_SALT',        'zpDmFU[pT(3(t}lRWP;#& @qSasdlH}`^Kt81niskpNsH_,9%wUgvr<k|bQ:+CN5');
define('SECURE_AUTH_SALT', '=3]=d&FSBn=j0h7[Q!pl=LBx4x;k-j`} 4/0.DJ7;[O>.>zLFGdE<, mL;e 8=E2');
define('LOGGED_IN_SALT',   '9olQ<M>?vB:1I1fM!Rg?Vv3qJ=5.BSRP7&w/iHJ#Rj6)HJ_>m$mF8IK<dy3Y)y~e');
define('NONCE_SALT',       'V!?^w+/P1*(_b.W_oEg?2%/@.U3Cpi3VbM/N=TA:l|^/o`F>(RdD?R(aLK_bR7A.');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'pp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
