use <./bcad.scad>
include <cfg.scad>

module baseChassi() {
    difference() {
        cube([LEG_W, CHASSI_H, WALL]);
        move(x=WALL, y=WALL, z=-WALL/2)
            cube([LEG_W-WALL*2, CHASSI_H - WALL*2 -CRANK_D-WALL, WALL*2]);
    }
}

module baseChassiO() {
    difference() {
        union() {
            cube([LEG_W, CHASSI_H-WALL-CRANK_D, WALL]);
            move(x=LEG_W/2,y=CHASSI_H-WALL-CRANK_D) {
                cylinder(d=CRANK_D+R_PLAY+WALL*2,h=2);
            }
        }
        move(x=WALL, y=WALL, z=-WALL/2)
            cube([LEG_W-WALL*2, CHASSI_H - WALL*2 -CRANK_D-WALL*2, WALL*2]);

        move(x=LEG_W/2,y=CHASSI_H-WALL-CRANK_D,z=-WALL/2)
            cylinder(d=CRANK_D+R_PLAY,h=WALL*2);
    }
}

module chassiO(legs=LEG_COUNT) {
    for(i = [0:legs]) {
        back(i*LEG_W)
        zrot(90) xrot(90)
            baseChassiO();
    }

    for(i = NUT_POSITION) { //M3NutHolder
        back(i*10)
        left(10/2-2) zrot(90)
            m3NutHolder(cutted=false);
    }
}

module crankHold() {
    d = CRANK_D+R_PLAY+WALL*2;
    difference() {
        union() {
            cylinder(d=d,h=2);
            move(x=-d/2,y=-d/2-1)
                xflip() triangle([d/2,d/2+1,2]);
            move(x=d/2,y=-d/2-1)
                triangle([d/2,d/2+1,2]);
            move(x=-d/2,y=-d/2-1)
                cube([d,d/2+1,2]);
        }
        down(WALL/2)
            cylinder(d=CRANK_D+R_PLAY,h=WALL*2);
    }
}


module baseChassiI() {
    union(){
        difference() {
            union() {
                cube([LEG_W, CHASSI_H-WALL-7, WALL]);
            }
            move(x=WALL, y=WALL, z=-WALL/2)
                cube([LEG_W-WALL*2, CHASSI_H - WALL*2 -9, WALL*2]);
        }
        back(7)
            difference() {
                cube([10,2,18]);
                move(x=WALL,y=-1,z=WALL2)
                    cube([10-WALL2,4,18-WALL2-4-WALL2]);
                move(x=10/2,z=18-1-2,y=3)
                xrot(90)
                cylinder(r=2.1,h=4);
            }
    }
}

module chassiI(legs=LEG_COUNT) {

    zrot(90) xrot(90) {

        difference()
        {
            union() {
                for(i = [0:legs]) {
                    right(i*LEG_W)
                        baseChassiI();
                }
            }
            for(i = NUT_POSITION) {
                right(-LEG_W + LEG_W*i +WALL)
                    up(WALL2) {
                        cube([16,20,6]);
                    }
            }
        }

        for(i = NUT_POSITION) {
            right((i-1)*LEG_W)
            back(7) up(10) {
                right(2)
                    xrot(-90)
                    triangle([6,6,2]);

                right(12+6)
                    xflip() xrot(-90)
                    triangle([6,6,2]);
            }
        }
    }

    zrot(90) xrot(90) {
        for(i = INNER_CRANK_STOPS) {
            move(x=i*10,y= CHASSI_H-WALL-CRANK_R-1)
                crankHold();
        }
    }

    for(i = [0,2,3,4,6,7,8,9,10,11,13,14]) { //left triangles
        move(y=WALL+i*10, x=WALL, z=7)
            yrot(90)xrot(90)
                triangle([5,6,WALL]);
    }
    for(i = [1,2,3,5,6,7,8,9,10,12,13,15]) { //right triangles
        move(y=WALL+i*10+LEG_W-WALL, x=WALL, z=7)
            yrot(90)xrot(90)
                triangle([5,6,WALL]);
    }


    for(i = NUT_POSITION) {
        back(i*10)
            right(10/2)zrot(-90)
                m3NutHolder(cutted=false);
    }
}
