/************************************************************************
* Copyright 2017-2018 IBM Corp. All Rights Reserved.
*
* Watson Maker Kits - OpenSCAD design
*
* This project is licensed under the Apache License 2.0, see LICENSE.*
*
************************************************************************
*
* This Open SCAD file can be used to generate the STL files for the
* TJBot physical enclosure
*
************************************************************************
* Version history
*
* Date 			Author				Description
* 2017-10-20	Philippe Gregoire	Initial design for the TJ Bot Head
* 2018-04-26	Philippe Gregoire	Optional SenseHat aperture
*/

//// The various parts of the robot are each coded in their own module
// using the same naming convention as the robot's individual STL
// files.

/**********************************************************************/
/* Robot dimensional parameters                                       */
_thickness=2;

// Head dimensions
_headSide=_thickness*2 + 100;
_headHeight=_thickness + 75;

// LED Hole. Placed at the center of the head's top
_LEDHoleDiam=9.98;

// Hat will be placed so that the LED array is at the center, connector to the back. Replaces LED
// SenseHat apertures constants
_SENSE_W=65;
_SENSE_L=56;
_SLEDS_X=6;
_SLEDS_W=33;
_SLEDS_Y=10.5;
_SLEDS_L=36;
_SCON_X=6;
_SCON_W=52;
_SCON_Y=1;
_SCON_L=6;
_SJOY_X=52.5;
_SJOY_Y=49.5;
_SJOY_D=10;
_SHOLES=[[3,4],[61,4],[3,53],[61,53]];

// SenseHat pods dimensions
_SensePodsDiam=6;
_SensePodsHole=1;
_SensePodsHeight=2;

// Select style, LED or SenseHat
//_Style='LED';
_style="SenseHat";

// Eyes dimensions
_eyeDiam=12;
_eyeSpacing=_eyeDiam+34;
_eyeZ=62;

// Speaker
_speakerDiam=55;
_speakerZ=41.6;

// Side slit for arm
_armSlitWidth=14;
_armSlitHeight=49.3;
_armSlitOffset=30.3;

/* Helper module to place SenseHat components */
module _tjbot_13_head_Sense(style) {
	if(style=="SenseHat") {
		rotate([0,0,180]) {
			// Center LED array
			translate([-_SLEDS_X-_SLEDS_W/2,-_SLEDS_Y-_SLEDS_L/2]) {
				children();
			}
		}
	}
}

/*  Main module to build the head - Part #13
*/
module tjbot_13_head(
	th=_thickness,
	w=_headSide,l=_headSide,lh=_LEDHoleDiam,
	h=_headHeight,
	ed=_eyeDiam,es=_eyeSpacing,ez=_eyeZ,
	sd=_speakerDiam,sZ=_speakerZ,
	aw=_armSlitWidth,ah=_armSlitHeight,ao=_armSlitOffset,
	style=_style,
	spd=_SensePodsDiam,sph=_SensePodsHole,spt=_SensePodsHeight) {
		
	// head top plate, removing LED hole
	difference() {
		union() {
			// Top Plate
			translate([-w/2,-l/2,0]) cube([w,l,th]);
			// Mounting pods
			_tjbot_13_head_Sense(style) {
				$fn=24;
				// screws
				for(h=_SHOLES) {
					translate([h[0],h[1],th+spt/2])
						difference() {
							cylinder(d=spd,h=spt,center=true);
							cylinder(d=sph,h=spt,center=true);
						}
				}
			}
		}
		union() {
			// LED Hole
			if(style=="LED") {
				cylinder(d=lh,h=th);
			}
			// SenseHat Aperture
			_tjbot_13_head_Sense(style) {
				// LED array aperture
				translate([_SLEDS_X,_SLEDS_Y])
					cube([_SLEDS_W,_SLEDS_L,th]);
				// Connector aperture
				translate([_SCON_X,_SCON_Y])
					cube([_SCON_W,_SCON_L,th]);
				// Joystick hole
				translate([_SJOY_X,_SJOY_Y,th/2])
					cylinder(d=_SJOY_D,h=th,center=true,$fn=24);
			}
		}		
	}
	
	// build 4x head sides
	for(a=[0:1:3]) {
		rotate([90,0,a*90]) translate([-w/2,0,w/2-th]) {
			difference() {
				cube([w,h,th]);
				
				// Now take into account sides singular characteristics
				if(a==0) { // Front side, holes for eyes
					for(x=[-es/2,es/2])
						translate([w/2+x,ez])
							cylinder(d=ed,h=th);
				} else if(a==1) { // right side, slit for arm
					translate([ao-aw/2,h-ah])
						cube([aw,ah,th]);
					translate([ao,h-ah])
						cylinder(d=aw,h=th);	
				} else if(a==2) { // Back side, speaker hole
					translate([w/2,sZ])
						cylinder(d=sd,h=th,$fa=1);
				}
			}
		}
	}	
}

/* To generate and individual part, uncomment the corresponding line */
tjbot_13_head();