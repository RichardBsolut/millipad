use <./bcad.scad>
include <./cfg.scad>
include <./motor.scad>
use <./crank.scad>


module baseRib() {
    difference() {
        cuttedCube([70,LEG_W,WALL],2.5,2.5);
        //Screws
        move(x=5,y=5,z=-1) cylinder(d=3,h=10);
        move(x=5+WALL2*4+WELLE_PLAY,y=5,z=-1) cylinder(d=3,h=10);        
        move(x=70-5,y=5,z=-1) cylinder(d=3,h=10);
        move(x=70-5-WALL2*4-WELLE_PLAY,y=5,z=-1) 
            cylinder(d=3,h=10);       
    }
}

module wallGrip() {
    right(8+WALL+R_PLAY)
        back(LEG_W)
            xrot(90)
                triangle([5,5,LEG_W]);
    right(8+WALL*4+WALL-R_PLAY-1)
        back(LEG_W)
            xflip() xrot(90)
                triangle([5,5,LEG_W]);    
}

module smallRib() {
    baseRib();
    wallGrip();
    right(42)
    wallGrip();    
}


module motorWithCrank(crankAngle=0) {
    motor();
    move(x=MOTOR_X/2,y=MOTOR_Y+1,z=MOTOR_Z/2)
        yrot(crankAngle) xrot(-90)
            crankMotor();
}

module middleRib() {
    baseRib();
    back(70)
        baseRib();
    
    
    back(10) right(8 + WALL*4+WELLE_PLAY) {
        difference() {
            union() {
                hexPlate([36,60,2],shell=3);
                
                move(x=3,y=13-WALL)
                    cube([6,14+WALL2,2]);
                move(x=29-WALL,y=13+20-WALL)
                    cube([6,14+WALL2,2]);
            }
            //Crank cut out
            move(x=3,y=13,z=-1) {
                cube([4,14,10]);
            }
            move(x=29,y=13+20,z=-1) {
                cube([4,14,10]);
            }
            
            //Srew Holds
            move(x=11,y=7-0.5) {
                move(x=14/2,y=6/2, z=-1)
                cylinder(d=2.5,h=10);
            }
            move(x=11,y=26+.5,z=0)
                    move(x=14/2,y=6/2, z=-1)
                    cylinder(d=2.5,h=10);
            move(x=11,y=47.5)
                    move(x=14/2,y=6/2, z=-1)
                    cylinder(d=2.5,h=10);
        }

        
        up(2) {
            {
            move(x=25+7, y=-6 + 20) //x=25 motor_z+7 crank_h
                zrot(90)                 //y=-6 motor_y/2 + 2*LEG_W
                    %motorWithCrank(90);

            move(x=36-25-7, y=+6 + 40) //x=36 platewidth-  25 motor_z-7 crank_h
                zrot(-90)                 //y=-6 motor_y/2 + 2*LEG_W
                    %motorWithCrank(-90);
            }


            
            back(10) down(2)
            difference() {
                cube([3,20,9]);                
                move(x=5,y=5.5,z=2)
                yrot(-90)
                cylinderHull([9+10,9,9]);//d=9,h=5);
            }
            
            back(10+20) right(36-3) down(2)
            difference() {
                cube([3,20,9]);                
                move(x=5,y=5.5,z=2)
                yrot(-90)
                cylinderHull([9+10,9,9]);//d=9,h=5);
            }

            //--Bases
            down(2) {
                move(x=11,y=7-1) {
                    difference() {
                        cube([14,7-1,6+2]);
                        move(x=14/2,y=6/2+0.5, z=-1)
                        cylinder(d=2.5,h=10);
                    }
                }
                move(x=11,y=26+.5,z=0)
                    difference() {
                        cube([14,7-1,6+2]);
                        move(x=14/2,y=6/2, z=-1)
                        cylinder(d=2.5,h=10);
                    }
                move(x=11,y=48)
                    difference() {
                        cube([14,7-1,6+2]);
                        move(x=14/2,y=6/2-0.5, z=-1)
                        cylinder(d=2.5,h=10);
                    }
            }

            //Motor Cover
            move(z=1) %motorsCover();
        }
    }   
}