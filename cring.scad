include <./bcad.scad>
include <cfg.scad>

module cring() {
    difference() {
        cylinder(d=CRANK_D+WALL2+R_PLAY,h=1.5);
        down(1) {
            cylinder(r=CRANK_R+R_PLAY,h=10);
            zrot(-45-90)
                cube([CRANK_D+WALL2,CRANK_D+WALL2,10]);
        }
    }
}
