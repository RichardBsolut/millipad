use <./bcad.scad>
include <cfg.scad>
use <./chassi.scad>
use <./leg.scad>
use <./pin.scad>
use <./cring.scad>
use <./crank.scad>
use <./rib.scad>

module bottomSide() {
    chassiO();
    right(WALL*4)
        chassiI();

    //Left cranks
    for(i = [0:LEG_COUNT]) {
        back(i*10)
            move(x=2.5,y=5,z=13) {
                color("RoyalBlue") crank(h=2.5);
                left(2.5)
                color("DodgerBlue")xrot(i*45) zrot(-90) xrot(90)
                    crankHandel();
            }
    }
    //Right cranks
    for(i = INNER_CRANK_STOPS) {
        move(x=8,y=10*i,z=13)
        xflip()
        color("RoyalBlue") crank(h=2.5);
    }
    
    LEG_ANGLE = [
        //yrot, zrot
        [0, -10],
        [8, -8],
        [11, 0],
        [8, 10],
        [0, 10],
        [-8, 10],
        [-10, 0],
        [-7, -7]
    ];
    
    //Legs
    for(i = [0:LEG_COUNT]) {
        move(x=23,y=2.5+i*LEG_W,z=13.5)
            xflip() xrot(-90) {
                move(x=-2,y=4,z=1.8)
                yflip() yrot(90) pin();
                legAngle = LEG_ANGLE[i%8];
                color("Cornsilk")
                    yrot(legAngle[0]) zrot(legAngle[1])
                        move(y=-16) leg();
            }        
    }
}

module fullBottom() {
    bottomSide();
    right(52) xflip()
    bottomSide();    
    move(x=2.5+2,y=-5,z=13)
        zflip()
            color("yellow") welle(holderPos=7);

    move(x=2.5+2+42,y=-5,z=13)
        zflip()
            color("yellow") welle(holderPos=9);    
}

module fullAssembly() {
    zflip()
    fullBottom();
    
    move(x=-8,y=5+10, z=2)
    xrot(180)
        smallRib();
    move(x=-8,y=5+150, z=2)
    xrot(180)
        smallRib();
    
    move(x=-8,y=45)
    middleRib();
}

fullAssembly();



module arrow(size=10, headpart=0.4) {
	color("orange")
	yrot(90) {
		down(size/2)
		union() {
			up(size*headpart/2) cylinder(d1=0, d2=size/2, h=size*headpart, center=true, $fn=18);
			up(size/2+size*headpart/2) cylinder(d=size/6, h=size*(1-headpart), center=true, $fn=18);
		}
	}
}


module final_assembly_1(explode=0, arrows=false)
{
    // view: [ 21.48, 23.30, -10.75 ]
    // desc: Put the pin on the leg, may be you should use a pliers. Repeat it 32 times :)
    leg();
    move(y=20+10,z=1.5)
        zrot(90)
            arrow();    
    move(y=20+30,x=-2,z=1.5)
    yflip()
        yrot(90)
            pin();
}
//final_assembly_1();


module final_assembly_2(explode=0, arrows=false)
{    
	// view: [ 18.71, 68.83, 14.45 ]
	// desc: Insert M3 Nuts into the holder and press it inside    
    color("white") chassiI();

    for(i = NUT_POSITION) {
        back(i*LEG_W) {
            move(x=5, z=15)
                yrot(-90)
                    arrow();
            move(x=30, z=5) {
                arrow();
                right(15)
                    color("DarkGray") m3Nut();            
                                
            }
        }
    }
}
//final_assembly_2();


module final_assembly_3(explode=0, arrows=false)
{    
	// view: [ 0.00, 0.00, 0.00 ]
	// desc: 
    color("white") chassiI();    
    
    move(x=15, y=7, z=-14)
    xflip() xrot(90) {
        leg();
        move(y=20,x=-2,z=1.8)
        yflip()
            yrot(90)
                pin();
        zrot(-90)
        arrow();
    }
    move(x=15+10,y=6,z=9)
    zrot(-90) {
        zrot(90) arrow();
        back(15)
            cring();
    }

}
//final_assembly_3();


module final_assembly_4() {
    welle(holderPos=6);
}
//final_assembly_4();