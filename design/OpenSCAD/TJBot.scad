/************************************************************************
* Copyright 2016 IBM Corp. All Rights Reserved.
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
*/

//// The various parts of the robot are each coded in their own module
// using the same naming convention as the robot's individual STL
// files.

/**********************************************************************/
/* Robot dimentional parameters                                       */
_thickness=2;

// Head
_headSide=_thickness*2 + 100;
_LEDHoleDiam=9.98;
_headHeight=_thickness + 75;

// Eyes
_eyeDiam=12;
_eyeSpacing=34;
_eyeZ=62;

// Speaker
_speakerDiam=55;
_speakerZ=41.6;

// Side slit for arm
_armSlitWidth=14;
_armSlitHeight=49.3;
_armSlitOffset=30.3;

module tjbot_13_head(th=_thickness,
	w=_headSide,l=_headSide,lh=_LEDHoleDiam,
	h=_headHeight,
	ed=_eyeDiam,es=_eyeSpacing,ez=_eyeZ,
	sd=_speakerDiam,sZ=_speakerZ,
	aw=_armSlitWidth,ah=_armSlitHeight,ao=_armSlitOffset) {
	// head top plate, removing LED hole
	difference() {
		translate([-w/2,-l/2,0]) cube([w,l,th]);
		cylinder(d=lh,h=th);
	}
	
	// build head sides
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
						cylinder(d=sd,h=th);
				}
			}
		}
	}	
}

/* To generate and individual part, uncomment the corresponding line */
tjbot_13_head();