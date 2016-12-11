<?php

require 'ImagePath.php';

class ImagePathTest extends PHPUnit_Framework_TestCase
{

	public function testIsSanitizedAtInstance()
	{
		$url = 'https://www.google.es/search?q=aquiles+y+la+tortuga&espv=2&biw=1920&bih=1126&source=lnms&tbm=isch&sa=X&sqi=2&ved=0ahUKEwjdmvHu5ObQAhVJXBoKHYfbBUgQ_AUIBigB#tbm=isch&q=aquiles+y+la+tortuga+computer&imgrc=-4wuN0kTpLw5FM%3A';
		$expected = 'https://www.google.es/search?q=aquiles y la tortuga&espv=2&biw=1920&bih=1126&source=lnms&tbm=isch&sa=X&sqi=2&ved=0ahUKEwjdmvHu5ObQAhVJXBoKHYfbBUgQ_AUIBigB#tbm=isch&q=aquiles y la tortuga computer&imgrc=-4wuN0kTpLw5FM:';

		$imagePath = new ImagePath($url); 
		$this->assertEquals($expected,$imagePath->sanitizedPath());
	}

	public function testIsHttpProtocol()
	{

		$imagePath = new ImagePath('https://example.com'); 

		$this->assertTrue($imagePath->isHttpProtocol());

		$imagePath = new ImagePath('ftp://example.com'); 

		$this->assertFalse($imagePath->isHttpProtocol());

		$imagePath = new ImagePath(null); 

		$this->assertFalse($imagePath->isHttpProtocol());
	}	

	public function testObtainFilename()
	{

		$url = 'http://martinfowler.com/mf-ade-home.jpg';
		$expected = 'mf-ade-home.jpg';

		$imagePath = new ImagePath($url); 
		$this->assertEquals($expected,$imagePath->ObtainFilename());

	}	
}
?>