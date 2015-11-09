use <./bcad.scad>
include <cfg.scad>

module cylinderCube(size) {
	x = size[0];
	y = size[1];
	h = size[2];
	translate([x/2,x/2,0]) {
		cylinder(r=x/2,h=h);
		translate([-x/2,0,0])
		cube([x, y-x, h]);
		translate([0,y-x,0])
			cylinder(r=x/2,h=h);
	}
}

module crank(h=0) {
    left(WALL+h)
        yrot(90) cylinder(r=CRANK_R,h=WALL*2+h);
    fwd(5) {
        down(CRANK_R)
            cube([2,5,CRANK_R*2]);
        yrot(90) cylinder(r=CRANK_R,h=WALL*2);
    }   
}

module crankHandel() {
    w = CRANK_R+WALL2;
    difference() {
        move(x=-w/2,y=-2.5)
            cylinderHull([w,8.7,2]);
        down(WALL/2)
            cylinder(r=CRANK_R+R_PLAY/2,h=WALL*2);
    }
    move(y=5,z=WALL-.25)
    xrot(-11)
        cylinder(r=1.2,h=4.25);
}


module motorShaft(r, h) {
	difference() {
		cylinder(r=r,h=h);
		translate([r+r/1.5,0,0])
		cube([r*2,r*2,h*2+1], center=true);
	}
}

module crankMotor(){
    h= 7;
    difference() {
        union() {
            cylinder(r=6,h=2);
            cylinder(r=4,h=h);
            translate([-4,-4,h])
                cylinderCube([8,12,2]);
        }
        down(1)
            rotate([0,0,-90]) motorShaft(1.8,h*2);

        /*up(h/2+1)   //I like the idea to srew the shaft down 
            xrot(90) //but my printer cant handle that :/
                cylinder(d=2,h=10);        */
    }
    
    up(h+2) back(5) {
        cylinder(r=CRANK_R,h=WALL2);
        cylinderBaseMask(d=CRANK_R,r=1);
    }
}

module cylinderBaseMask(d=2,r=1) {
    rotate_extrude()
    right(d) difference() {
        square([r,r]);        
        move(x=r,y=r)
            circle(r=r);        
    }    
}

module baseWelle() {
    down(1+CRANK_R) {
        difference() {
            down(1)
            cube([WALL,10,CRANK_R*2+WALL2]);
            move(x=-WALL/2,y=LEG_W/2,z=CRANK_R+1)
            yrot(90)
                cylinder(r=CRANK_R+R_PLAY, h=WALL2);
        }
    }    
}

module welle(legCnt=LEG_COUNT,holderPos = 6) {

    difference() {
        union() {
            for(i = [0:legCnt]) {
                back(i*LEG_W)
                    baseWelle();
            }
        }
        
        for(i = INNER_CRANK_STOPS) { //Cut the 
            back(i*10)
            left(WALL/2)yrot(90)
                cylinder(r=CRANK_R+R_PLAY, h=WALL2);
        }
    }
    //Motor Crank Holder
    move(y=holderPos*10, z=1+CRANK_R) {
        difference() {
            union() {
                back(1.5)
                cube([WALL,CRANK_D+WALL2,CHASSI_H]);
                move(y=5,z=CHASSI_H-0.5) {
                    yrot(90) 
                        cylinder(d=CRANK_D+WALL2,h=WALL);
                }
                back(1.5)
                    zrot(-90)
                        BezConicHolder(h=CHASSI_H);
                move(y=CRANK_D+WALL2+1.5,x=2)zrot(90)
                    BezConicHolder(h=CHASSI_H);
            }
            
            move(x=-WALL/2,y=5,z=CHASSI_H-0.5)
                yrot(90)
                    cylinder(r=CRANK_R+R_PLAY,h=WALL2);

            //Save a little bit of plastic
            move(x=-WALL/2,y=5,z=CHASSI_H/3) 
            yrot(90)
                cylinder(d=CHASSI_H/2.5,h=WALL2);
        }
    }
}

module BezConicHolder(h=CHASSI_H+WALL2) {
    p0=[0,0];
    p1=[0, h/1.5];
    p2=[20, h];
    
    up(h)
        yrot(90) zrot(-90)yrot(-90)
        linear_extrude(height=2) {
            BezConic(p0,p1,p2,50);
            polygon(points=[p1,p2,[0,h]]);
        }
}
