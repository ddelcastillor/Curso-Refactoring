
use <pin_headers.scad>;

WIDTH = 56;
LENGTH = 85;
HEIGHT = 1.5;

METALLIC = "silver";
CHROME = [.9,.9,.9];
BLUE = [.4,.4,.95];

ETHERNET_LENGTH = 21.2;
ETHERNET_WIDTH = 16;
ETHERNET_HEIGHT = 13.3;
ETHERNET_DIMENSIONS = [ETHERNET_LENGTH,ETHERNET_WIDTH,ETHERNET_HEIGHT];

USB_LENGTH = 17.3;
USB_WIDTH = 13.3;
USB_HEIGHT = 16;
USB_DIMENSIONS = [USB_LENGTH,USB_WIDTH,USB_HEIGHT];

AUDIO_PORT_WIDTH = 11.5;
AUDIO_PORT_HEIGHT = 10.1;
AUDIO_PORT_LENGTH = 12.1;
AUDIO_PORT_DIMENSIONS = [AUDIO_PORT_LENGTH,AUDIO_PORT_WIDTH,AUDIO_PORT_HEIGHT];

HDMI_LENGTH = 15.1;
HDMI_WIDTH = 11.7;
HDMI_HEIGHT = 6.5;
HDMI_DIMENSIONS = [HDMI_LENGTH,HDMI_WIDTH,HDMI_HEIGHT];

RIGHT = [90,0,0];
LEFT = [-90,0,0];
TILT = [0,0,180];

function offset_x(ledge,port_length) = LENGTH - port_length + ledge;

module ethernet_port ()
	{
    
    ledge = 1.2;
    pcb_margin = 1.5;
    offset = [offset_x(ledge,ETHERNET_LENGTH),pcb_margin,HEIGHT];
        
	color(METALLIC)
        translate(offset) 
            cube(ETHERNET_DIMENSIONS); 
	}

module usb_port ()
	{
    ledge = 8.5;
    offset_y = 25; 
	color(METALLIC)
        translate([offset_x(ledge,USB_LENGTH),offset_y,HEIGHT]) 
            cube(USB_DIMENSIONS);
	}
module composite_block ()
    {
    color("yellow")
        cube([10,10,13]);    
    }
module composite_jack ()
    {
    fine = .5;
    translate([5,19,8])
        rotate(RIGHT)
            color(CHROME)
                cylinder(h = 9.3, r = 4.15, $fs=fine);    
    }
    
module composite_port ()
	{
    offset_x = 41.4;
    pcb_margin = 12;
    offset_y = WIDTH-pcb_margin;
	translate([offset_x,offset_y,HEIGHT])
		{
        composite_block();
        composite_jack();
		}
	}

module audio_block ()
    {
	color(BLUE)
        cube(AUDIO_PORT_DIMENSIONS);       
    }

function half(value) = value / 2;

function radius(diameter) = half(diameter);
    
module audio_jack ()
    {
    diameter = 6.7;
    radius = radius(diameter);
    offset = [half(AUDIO_PORT_LENGTH),AUDIO_PORT_WIDTH,AUDIO_PORT_HEIGHT-radius];
    translate(offset)
        rotate(LEFT)
            color(BLUE)
                cylinder(h = 3.5, r = radius, $fs=FINE);
    }   
module audio_port ()
	{
    offset_x = 59;   
	translate([offset_x,WIDTH-AUDIO_PORT_WIDTH,HEIGHT])
		{
		audio_block();
        audio_jack();    
		}
	}
    
module gpio ()
	{
    offset_x = -1;
    offset_y = -50;
    offset = [offset_x,offset_y,HEIGHT];
        
    num_pins_for_row = 13;   
    num_row_of_pins = 2; 
	rotate(TILT)     
        translate(offset)
            off_pin_header(
                            rows = num_pins_for_row,
                            cols = num_row_of_pins
                          );
	}

module hdmi ()
	{
    offset_x = 37.1;
    offset_y = -1;
    offset = [offset_x,offset_y,HEIGHT];
	color (METALLIC)
        translate ([37.1,-1,HEIGHT])
            cube(HDMI_DIMENSIONS);
	}

module power ()
	{
	color("silver")
	translate ([-0.8,3.8,HEIGHT])
	cube ([5.6, 8,4.4-HEIGHT]);
	}

module sd ()
	{
	color ([0,0,0])
	translate ([0.9, 15.2,-5.2+HEIGHT ])
	cube ([16.8, 28.5, 5.2-HEIGHT]);

	color ([.2,.2,.7])
	translate ([-17.3,17.7,-2.9])
	cube ([32, 24, 2] );
	}

module mhole ()
	{
	cylinder (r=3/2, h=HEIGHT+.2, $fs=0.1);
	}

module pcb ()
	{
		difference ()
		{
		color([0.2,0.5,0])
		linear_extrude(height = HEIGHT)
		square([LENGTH,WIDTH]); //pcb
		translate ([25.5, 18,-0.1]) mhole (); 
		translate ([LENGTH-5, WIDTH-12.5, -0.1]) mhole (); 
		}
	}

module leds()
	{
		// act
		color([0.9,0.1,0,0.6])
		translate([LENGTH-11.5,WIDTH-7.55,HEIGHT]) led();
		// pwr
		color([0.9,0.1,0,0.6])
		translate([LENGTH-9.45,WIDTH-7.55,HEIGHT]) led();

		// fdx
		color([0.9,0.1,0,0.6])
		translate([LENGTH-6.55,WIDTH-7.55,HEIGHT]) led();
		// lnk
		color([0.9,0.1,0,0.6])
		translate([LENGTH-4.5,WIDTH-7.55,HEIGHT]) led();
		// 100
		color([0.9,0.1,0,0.6])
		translate([LENGTH-2.45,WIDTH-7.55,HEIGHT]) led();
	}
module led()
	{
		cube([1.0,1.6,0.7]);
	}

module rpi ()
	{
		pcb ();
		ethernet_port ();
		usb_port (); 
		composite_port (); 
		audio_port (); 
		gpio (); 
		hdmi ();
		power ();
		sd ();
		leds ();
	}

rpi (); 
