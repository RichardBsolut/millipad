
module pin() {
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

    //Base
    translate([-4.25,1.25,0]) 
        rotate([90,0,0]) 
            doubleCube([4.25*2, 4], [1.8*2,2.5], 2);
    translate([-4.25,0,0]) 
        cube([4.25*2,1.25,4]);


    module gripper(){
        cube([2,4,4]);
        translate([0,4-0.25,2])
            rotate([0,90,0])
                cylinder(r=2,h=2);	
        translate([0,4-0.25,2])
            rotate([0,270,0])
                cylinder(r2=0.625, r=1.16, h=1.04);

    }
    translate([2.3,0,0])
        gripper();
    translate([-2.3,0,0])
        scale([-1,1,1])
            gripper();




    L=5.8;
    L2=1.8;


    difference() {
        translate([0,-L,1.85])
            rotate([-90,0,0])
                cylinder(r=1.85,h=L);

    translate([0,-3,1.85])
        rotate([90,0,0]) {
            difference() {
                cylinder(r=2.1,h=L2);
                cylinder(r=1.2,h=L2);
            }
        }

    }
}
