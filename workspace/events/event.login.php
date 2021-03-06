<?php

if(!defined('__IN_SYMPHONY__')) die('<h2>Error</h2><p>You cannot directly access this file</p>');

class eventLogin extends Event
{
	public static function about()
	{
		return array(
			'name' => 'Login Info',
			'author' => array(
				'name' => 'Alistair Kearney',
				'website' => 'http://www.pointybeard.com',
				'email' => 'alistair@pointybeard.com',
			),
			'version' => '1.5.0',
			'release-date' => '2010-01-10',
			'trigger-condition' => 'action[login] field or an already valid Symphony cookie',
			'recognised-fields' => array(
				array('username', true),
				array('password', true),
			)
		);
	}

	public static function getSource()
	{
		return 'Symphony';
	}

	public function load()
	{
		return $this->__trigger();
	}

	public static function documentation()
	{
		return new XMLElement('p', 'This is an event that displays basic login details (such as their real name, username and author type) if the person viewing the site have been authenticated by logging in to Symphony. It is useful if you want to do something special with the site if the person viewing it is an authenticated member.');
	}

	protected function __trigger()
	{
		// Cookies only show up on page refresh.
		// This flag helps in making sure the correct XML is being set
		$loggedin = false;

		if (isset($_REQUEST['action']['login'])){
			$username = $_REQUEST['username'];
			$password = $_REQUEST['password'];
			$loggedin = Frontend::instance()->login($username, $password);
		}

		else {
			$loggedin = Frontend::instance()->isLoggedIn();
		}
		
		if ($loggedin){
			$result = new XMLElement('login-info');
			$result->setAttribute('logged-in', 'true');

			$author = null;
			if (is_callable(array('Symphony', 'Author'))) {
				$author = Symphony::Author();
			} else {
				$author = Frontend::instance()->Author;
			}

			$result->setAttributeArray(array(
				'id' => $author->get('id'),
				'user-type' => $author->get('user_type'),
				'primary-account' => $author->get('primary')
			));

			$fields = array(
				'name' => new XMLElement('name', $author->getFullName()),
				'username' => new XMLElement('username', $author->get('username')),
				'email' => new XMLElement('email', $author->get('email'))
			);

			if ($author->isTokenActive()) {
				$fields['author-token'] = new XMLElement('author-token', $author->createAuthToken());
			}

			// Section
			if ($section = Symphony::Database()->fetchRow(0, "SELECT `id`, `handle`, `name` FROM `tbl_sections` WHERE `id` = '".$author->get('default_area')."' LIMIT 1")){
				$default_area = new XMLElement('default-area', $section['name']);
				$default_area->setAttributeArray(array('id' => $section['id'], 'handle' => $section['handle'], 'type' => 'section'));
				$fields['default-area'] = $default_area;
			}
			// Pages
			else {
				$default_area = new XMLElement('default-area', $author->get('default_area'));
				$default_area->setAttribute('type', 'page');
				$fields['default-area'] = $default_area;
			}

			foreach($fields as $f) {
				$result->appendChild($f);
			}
		}

		else {
			$result = new XMLElement('user');
			$result->setAttribute('logged-in', 'false');
		}
		
		// param output
		Frontend::Page()->_param['login'] =  $loggedin ? 'yes' : 'no';
		Frontend::Page()->_param['login-filter'] = $loggedin ? 'yes,no' : 'yes';
		
		return $result;

	}
}
