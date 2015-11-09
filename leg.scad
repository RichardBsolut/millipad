use <./bcad.scad>

module roundMask(d=5) {
    rotate_extrude()
    difference() {
        square([d,d]);        
        circle(d=d);
    }
}

module legConnect(short=-2) {
    difference() {
        hull() {
            cylinder(d=4,h=0.1);
            up(7+short) back(2) xrot(90)
                cylinder(d=4,h=4-0.25);
        }
        up(7+short) back(4) xrot(90)
            cylinder(d=2,h=10);
        
    }
}

module leg(short=-2) {    
    back(11)
        xrot(-90) fwd(2) {
            legConnect(short);
        }

    difference() {
        hull() {
            move(x=27,y=16+2+short)
                up(5.5/2)
                    yrot(90)
                        cylinder(d=5.5,h=2);
            back(6) right(29)
                zrot(90)xrot(-90) fwd(2)
                cylinder(d=4,h=2);
        }
        move(x=27,y=16+2+short)
            up(5.5/2)
                yrot(90) down(1)
                    cylinder(d=3.2,h=4);        
    }
    
    chain_hull() {
        back(11)
            xrot(-90) fwd(2)
            cylinder(d=4,h=0.1);

        back(6) right(3)
            zrot(35)xrot(-90) fwd(2)
            cylinder(d=4,h=0.1);

        back(1) right(9)
            zrot(70)xrot(-90) fwd(2)
            cylinder(d=4,h=0.1);

        back(1) right(19)
            zrot(-70)xrot(-90) fwd(2)
            cylinder(d=4,h=0.1);
        
        back(6) right(28)
            zrot(90)xrot(-90) fwd(2)
            cylinder(d=4,h=0.1);

        back(1.2) right(55.8)
            zrot(90)xrot(-90) fwd(1)
            cylinder(d=2,h=0.1);

        back(2.4) right(59)
            zrot(115)xrot(-90) fwd(1.8/2)
            cylinder(d=1.8,h=0.1);

        back(6) right(60.5)
            zrot(160)xrot(-90) fwd(1.5/2)
            cylinder(d=1.5,h=0.1);
    }
}
