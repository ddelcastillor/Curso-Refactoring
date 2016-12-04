
use <pin_headers.scad>;

ARRAY_BASE_CORRECTION = -1;

WIDTH = 56;
LENGTH = 85;
HEIGHT = 1.5;

FINE = .5;
FINEST = .1;

METALLIC = "silver";
CHROME = [.9,.9,.9];
BLUE = [.4,.4,.95];
BLACK = [0,0,0];
DARK_BLUE = [.2,.2,.7];
DARK_GREEN = [0.2,0.5,0];
RED = [0.9,0.1,0,0.6];

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

POWER_CONNECTOR_LENGTH = 5.6;
POWER_CONNECTOR_WIDTH = 8;
POWER_CONNECTOR_HEIGHT = 2.9;
POWER_CONNECTOR_DIMENSIONS = [POWER_CONNECTOR_LENGTH,POWER_CONNECTOR_WIDTH,POWER_CONNECTOR_HEIGHT];

SLOT_SD_LENGTH = 16.8;
SLOT_SD_WIDTH = 28.5;
SLOT_SD_HEIGHT = 3.7;
SLOT_SD_DIMENSIONS = [SLOT_SD_LENGTH,SLOT_SD_WIDTH,SLOT_SD_HEIGHT];

SD_CARD_DIMENSIONS = [32, 24, 2];

SPACE_ACT = 11.5;
SPACE_PWR = 9.45;
SPACE_FDX = 6.55;
SPACE_LNK = 4.5;
SPACE_100 = 2.45;
SPACE_OFFSETX_LEDS = [SPACE_ACT,SPACE_PWR,SPACE_FDX,SPACE_LNK,SPACE_100];
LED_DIMENSIONS = [1.0,1.6,0.7];

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
    translate([5,19,8])
        rotate(RIGHT)
            color(CHROME)
                cylinder(h = 9.3, r = 4.15, $fs=FINE);    
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
    
module power_connector ()
	{
    offset_x = -0.8;
    offset_y = 3.8;
    offset = [offset_x,offset_y,HEIGHT];
        
	color(METALLIC)
        translate (offset)
            cube (POWER_CONNECTOR_DIMENSIONS);
	}

module slot_sd ()
	{
    offset_x = 0.9;
    offset_y = 15.2;
    offset_z = -5.2+HEIGHT;
    offset = [offset_x, offset_y, offset_z];  
        
	color (BLACK)
        translate (offset)
            cube (SLOT_SD_DIMENSIONS);
	}
    
module card_sd ()
	{  
    offset = [-17.3,17.7,-2.9];    
	color (DARK_BLUE)
        translate (offset)
            cube (SD_CARD_DIMENSIONS);
	}

module sd ()
	{
    slot_sd ();
    card_sd ();
	}

module mhole ()
	{
    diameter = 3;
    radius = radius(diameter);
	cylinder (r=radius, h=HEIGHT+.2, $fs=FINEST);
	}

module integrate_circuit ()
	{
    color(DARK_GREEN)
        linear_extrude(height = HEIGHT)
            square([LENGTH,WIDTH]); 
	}
    
module holes ()
	{
     positions = [[25.5, 18,-0.1],[LENGTH-5, WIDTH-12.5, -0.1]];  
     number_of_holes = len(positions);   
     for (i = [0:number_of_holes + ARRAY_BASE_CORRECTION]){
        translate (positions[i]) 
            mhole ();   
     }      
	}
module pcb ()
	{
		difference ()
		{
            integrate_circuit ();
            holes();
		}
	}

module leds()
	{
     offset_y = 48.45;
     number_of_leds = len(SPACE_OFFSETX_LEDS);   
     for (i = [0:number_of_leds + ARRAY_BASE_CORRECTION])
         {
            offset_x = LENGTH-SPACE_OFFSETX_LEDS[i];
            color(RED)
                translate([offset_x,offset_y,HEIGHT]) 
                    led();  
        }      
	}
module led()
	{
		cube(LED_DIMENSIONS);
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
		power_connector ();
		sd ();
		leds ();
	}

rpi (); 
