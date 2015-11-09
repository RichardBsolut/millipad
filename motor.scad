MOTOR_X = 12;
MOTOR_Y = 25;
MOTOR_Z = 10;

module motor() {
    color("Gainsboro")
        cube([MOTOR_X, MOTOR_Y-10,MOTOR_Z]);
    color("Goldenrod") //Gears
        translate([0,MOTOR_Y-10,0])
            cube([MOTOR_X, 10,MOTOR_Z]);
    translate([MOTOR_X/2, MOTOR_Y, MOTOR_Z/2])
        rotate([-90,0,0])
            color("DimGray") cylinder(r=1.5,h=5);
}

module motorCover() {
    difference() {    
        cube([15.2,18,11.5]);
        move(x=1.5,y=-1,z=-0.5)
        cube([15.2-3,20,11.5-1]);
    }
    //Grips
    move(x=13.15,y=9.1,z=5.9)
        cube([0.6,1.8,4.2]);
    move(x=10.15,y=9.1,z=9.5)
        cube([3,1.8,0.6]);
        
    move(x=1.5,y=8,z=7) motorCurve();
    move(x=13.8,y=8,z=7) xflip() motorCurve();

    %move(x=15.2/2,y=1,z=11.5)
        cylinder(d=2,h=2);
}

module motorCurve(h=5) {
    p0=[0,0];
    p1=[0.5, 2];
    p2=[2.4, 3.1];

    xrot(90) {
        //yrot(90) zrot(-90)yrot(-90)
        linear_extrude(height=8) {
            BezConic(p0,p1,p2,50);
            polygon(points=[p1,p2,[0,3.1]]);
            polygon(points=[p1,[0,0],[0,3.1]]);
        }
    }
}

module motorsCover() {
    color("AliceBlue")
    difference() {
        union() {
            move(x=25,y=-1+13.5)
            zrot(90)
            motorCover();

            move(x=11,y=7-0.5,z=6)
                    difference() {
                        cube([14,7,5.5]);
                        move(x=14/2,y=6/2, z=-1)
                        cylinder(d=2.5,h=10);
                    }
                    
            move(x=11,y=7-0.5+41,z=6)
                    difference() {
                        cube([14,6,5.5]);
                        move(x=14/2,y=6/2, z=-1)
                        cylinder(d=2.5,h=10);
                    }
            move(x=11,y=7-0.5+21,z=6)
                    difference() {
                        cube([14,6,5.5]);
                        move(x=14/2,y=2, z=-1)
                        cylinder(d=2.5,h=10);
                    }

            move(x=11,y=-1+13.5+35)
            zrot(-90)
            motorCover();
        }
        move(y=20)
            cube([40,20,6]);
    }
}