//////////////////////////////////////////////////////////////////////
// Basic cad supports
//////////////////////////////////////////////////////////////////////

//--- copy from gdmutils

//////////////////////////////////////////////////////////////////////
// Transformations.
//////////////////////////////////////////////////////////////////////


// Moves/translates children.
//   x = X axis translation.
//   y = Y axis translation.
//   z = Z axis translation.
// Example:
//   move([10,20,30]) sphere(r=1);
//   move(y=10) sphere(r=1);
//   move(x=10, z=20) sphere(r=1);
module move(a=[0,0,0], x=0, y=0, z=0) {
    translate(a) translate([x,y,z]) children();
}


// Moves/translates children the given amount along the X axis.
// Example:
//   xmove(10) sphere(r=1);
module xmove(x=0) { translate([x,0,0]) children(); }


// Moves/translates children the given amount along the Y axis.
// Example:
//   ymove(10) sphere(r=1);
module ymove(y=0) { translate([0,y,0]) children(); }


// Moves/translates children the given amount along the Z axis.
// Example:
//   zmove(10) sphere(r=1);
module zmove(z=0) { translate([0,0,z]) children(); }


// Moves children left by the given amount in the -X direction.
// Example:
//   left(10) sphere(r=1);
module left(x=0) { translate([-x,0,0]) children(); }


// Moves children right by the given amount in the +X direction.
// Example:
//   right(10) sphere(r=1);
module right(x=0) { translate([x,0,0]) children(); }


// Moves children forward by x amount in the -Y direction.
// Example:
//   forward(10) sphere(r=1);
module forward(y=0) { translate([0,-y,0]) children(); }
module fwd(y=0) { translate([0,-y,0]) children(); }


// Moves children back by the given amount in the +Y direction.
// Example:
//   back(10) sphere(r=1);
module back(y=0) { translate([0,y,0]) children(); }


// Moves children down by the given amount in the -Z direction.
// Example:
//   down(10) sphere(r=1);
module down(z=0) { translate([0,0,-z]) children(); }


// Moves children up by the given amount in the +Z direction.
// Example:
//   up(10) sphere(r=1);
module up(z=0) { translate([0,0,z]) children(); }


// Rotates children around the Z axis by the given number of degrees.
// Example:
//   xrot(90) cylinder(h=10, r=2, center=true);
module xrot(a=0) { rotate([a, 0, 0]) children(); }


// Rotates children around the Y axis by the given number of degrees.
// Example:
//   yrot(90) cylinder(h=10, r=2, center=true);
module yrot(a=0) { rotate([0, a, 0]) children(); }


// Rotates children around the Z axis by the given number of degrees.
// Example:
//   zrot(90) cube(size=[9,1,4], center=true);
module zrot(a=0) { rotate([0, 0, a]) children(); }


// Scales children by the given factor in the X axis.
// Example:
//   xscale(3) sphere(r=100, center=true);
module xscale(x) {scale([x,0,0]) children();}


// Scales children by the given factor in the Y axis.
// Example:
//   yscale(3) sphere(r=100, center=true);
module yscale(y) {scale([0,y,0]) children();}


// Scales children by the given factor in the Z axis.
// Example:
//   zscale(3) sphere(r=100, center=true);
module zscale(z) {scale([0,0,z]) children();}


// Mirrors the children along the X axis, kind of like xscale(-1)
module xflip() mirror([1,0,0]) children();


// Mirrors the children along the Y axis, kind of like yscale(-1)
module yflip() mirror([0,1,0]) children();


// Mirrors the children along the Z axis, kind of like zscale(-1)
module zflip() mirror([0,0,1]) children();


//////////////////////////////////////////////////////////////////////
// Mutators.
//////////////////////////////////////////////////////////////////////


// Performs hull operations between consecutive pairs of children,
// then unions all of the hull results.
module chain_hull() {
    union() {
        if ($children == 1) {
            children();
        } else if ($children > 1) {
            for (i =[1:$children-1]) {
                hull() {
                    children(i-1);
                    children(i);
                }
            }
        }
    }
}



//////////////////////////////////////////////////////////////////////
// Duplicators and Distributers.
//////////////////////////////////////////////////////////////////////

module xring(n=2,r=0,rot=true) {if (n>0) for (i=[0:n-1]) {a=i*360/n; xrot(a) back(r) xrot(rot?0:-a) children();}}
module yring(n=2,r=0,rot=true) {if (n>0) for (i=[0:n-1]) {a=i*360/n; yrot(a) right(r) yrot(rot?0:-a) children();}}
module zring(n=2,r=0,rot=true) {if (n>0) for (i=[0:n-1]) {a=i*360/n; zrot(a) right(r) zrot(rot?0:-a) children();}}



module BezConic(p0,p1,p2,steps=5) {

    stepsize1 = (p1-p0)/steps;
    stepsize2 = (p2-p1)/steps;

    for (i=[1:steps-1]) {
        point1 = p0+stepsize1*i; 
        point2 = p1+stepsize2*i; 
        point3 = p0+stepsize1*(i+1);
        point4 = p1+stepsize2*(i+1);  
        
        bpoint1 = point1+(point2-point1)*(i/steps);
        bpoint2 = point3+(point4-point3)*((i+1)/steps);
        
        polygon(points=[bpoint1,bpoint2,p1]);
    }
}


//////////////////////////////////////////////////////////////////////
// Basic shapes
//////////////////////////////////////////////////////////////////////

module cylinderSupport(r=5,h=2) {
    rotate_extrude() {
        right(r)
        difference() {
            square(h);
            move(x=h,y=h)
            circle(r = h); 
        }
    }
}

module cuttedCube(cSize, cutx, cuty) {
	cX = cSize[0];
	cY = cSize[1];
	linear_extrude(height=cSize[2])
	polygon([
		[cutx,0],
		[cX-cutx,0], [cX,cuty],
		[cX,cY-cuty], [cX-cutx, cY],
		[cutx, cY], [0, cY-cuty],
		[0, cuty]
	]);
}

module cylinderHull(size) {
	x = size[0];
	y = size[1];
	h = size[2];
    r = (x<y) ? (x/2) : (y/2);

    hull() {
        translate([r,r,0])
            cylinder(r=r,h=h);
        translate([x-r,y-r,0])
            cylinder(r=r,h=h);
    }
}


module doubleCube(s1, s2, z) {
	x1=s1[0];
	y1=s1[1];
	x2=s2[0];
	y2=s2[1];
	offx = (x1-x2)/2;
	offy = (y1-y2)/2;

	hull() {
		cube([x1,y1,0.00001]);
		translate([offx,offy,z-0.00001])
			cube([x2,y2,0.00001]);
	}
}

module triangle(size){
    x = size[0];
    y = size[1];
    
    linear_extrude(height=size[2])
    polygon([
        [x, 0],
        [0, y],
        [0, 0]
    ]);
}


module hexPlate(size=[10,10,10], shell=2, india=5, spacing = 2) {
    hoff = india + spacing;
    voff = sqrt(pow(hoff,2)-pow(hoff/2,2));
    
    cols = size[0] / hoff;
    rows = size[1] / voff;

    difference() {
        cube(size);
        for (i=[0:rows+1]) {
            for (j=[0:cols+1]){
                translate([j*hoff+i%2*(hoff/2),i*voff, -1])
                cylinder(h=size[2]+2,r=india/2,$fn=6);
            }
        }    
    }
    
    difference() {
        cube(size);
        translate([shell,shell,-1])
            cube([ size[0]-shell*2, size[1]-shell*2, size[2]+2 ]);
    }
}




//////////////////////////////////////////////////////////////////////
// Screws, Bolts, and Nuts.
//////////////////////////////////////////////////////////////////////

function get_metric_bolt_head_size(size) = lookup(size, [
		[ 4.0,  7.0],
		[ 5.0,  8.0],
		[ 6.0, 10.0],
		[ 7.0, 11.0],
		[ 8.0, 13.0],
		[10.0, 16.0],
		[12.0, 18.0],
		[14.0, 21.0],
		[16.0, 24.0],
		[18.0, 27.0],
		[20.0, 30.0]
	]);


function get_metric_nut_size(size) = lookup(size, [
		[ 2.0,  4.0],
		[ 2.5,  5.0],
		[ 3.0,  5.5],
		[ 4.0,  7.0],
		[ 5.0,  8.0],
		[ 6.0, 10.0],
		[ 7.0, 11.0],
		[ 8.0, 13.0],
		[10.0, 17.0],
		[12.0, 19.0],
		[14.0, 22.0],
		[16.0, 24.0],
		[18.0, 27.0],
		[20.0, 30.0],
	]);


function get_metric_nut_thickness(size) = lookup(size, [
		[ 2.0,  1.6],
		[ 2.5,  2.0],
		[ 3.0,  2.4],
		[ 4.0,  3.2],
		[ 5.0,  4.0],
		[ 6.0,  5.0],
		[ 7.0,  5.5],
		[ 8.0,  6.5],
		[10.0,  8.0],
		[12.0, 10.0],
		[14.0, 11.0],
		[16.0, 13.0],
		[18.0, 15.0],
		[20.0, 16.0]
	]);


// Makes a simple threadless screw, useful for making screwholes.
//   screwsize = diameter of threaded part of screw.
//   screwlen = length of threaded part of screw.
//   headsize = diameter of the screw head.
//   headlen = length of the screw head.
// Example:
//   screw(screwsize=3,screwlen=10,headsize=6,headlen=3);
module screw(screwsize=3,screwlen=10,headsize=6,headlen=3,$fn=undef)
{
	$fn = ($fn==undef)?max(8,floor(180/asin(2/screwsize)/2)*2):$fn;
	translate([0,0,-(screwlen)/2])
		cylinder(r=screwsize/2, h=screwlen+0.05, center=true, $fn=$fn);
	translate([0,0,(headlen)/2])
		cylinder(r=headsize/2, h=headlen, center=true, $fn=$fn*2);
}


// Makes an unthreaded model of a standard nut for a standard metric screw.
//   size = standard metric screw size in mm. (Default: 3)
//   hole = include an unthreaded hole in the nut.  (Default: true)
// Example:
//   metric_nut(size=8, hole=true);
//   metric_nut(size=3, hole=false);
module metric_nut(size=3, hole=true, $fn=undef, center=false)
{
	$fn = ($fn==undef)?max(8,floor(180/asin(2/size)/2)*2):$fn;
	radius = get_metric_nut_size(size)/2/cos(30);
	thick = get_metric_nut_thickness(size);
	offset = (center == true)? 0 : thick/2;
	translate([0,0,offset]) difference() {
		cylinder(r=radius, h=thick, center=true, $fn=6);
		if (hole == true)
			cylinder(r=size/2, h=thick+0.5, center=true, $fn=$fn);
	}
}

module m3Screw(screwlen=10,headsize=6,headlen=3,$fn=undef) {
	screw(3, screwlen,headsize,headlen,$fn);
}

module m3Nut(hole=true, $fn=undef, center=false) {
	metric_nut(3, hole, $fn, center);
}