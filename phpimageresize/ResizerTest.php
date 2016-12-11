<?php

require 'Resizer.php';

class FunctionResizeTest extends PHPUnit_Framework_TestCase
{

    /**
     * @expectedException InvalidArgumentException
     */
	public function testNecessaryCollaboration()
	{
		$resizer = new Resizer('anyNonPathObject');
	}

    /**
     * @expectedException InvalidArgumentException
     */
	public function testOptionalCollaboration()
	{
		$resizer = new Resizer(new ImagePath(''),'nonConfigurationObject');
	}


	public function testInstantiation()
	{
		$this->assertInstanceOf('Resizer',new Resizer(new ImagePath(''),new Configuration()));
		$this->assertInstanceOf('Resizer',new Resizer(new ImagePath('')));
	}

	public function testObtainLocallyCachedFilePath()
	{
		$resizer = new Resizer(new ImagePath('http://martinfowler.com/mf-ade-home.jpg'));
		$stub = $this->getMockBuilder('FileSystem')
		    ->getMock();
		$stub->method('file_get_contents')
		    ->willReturn('foo');

		$resizer->injectFileSystem($stub);


		$this->assertEquals('./cache/remote/mf-ade-home.jpg',$resizer->obtainFilePath());
	}
} 
?>