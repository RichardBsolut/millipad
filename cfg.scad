R_PLAY = 0.25+0.125;

NUT_PLAY = 0.2; //User had problem to put the nut into chassi-inside, so with that play we dont have to use an hot iron
LEG_COUNT = 15; //We start at 0 and per side

WALL = 2;
WALL2 = WALL * 2;
WELLE_PLAY = 1;
CRANK_R = 1.5;
CRANK_D = CRANK_R * 2;

LEG_W = 10; //Space between legs
CHASSI_H = 18; //Chassi height

NUT_POSITION = [1, 5, 12, 15];


INNER_CRANK_STOPS = [1,2,8,9,14,15];


module m3NutHolder(s=10, cutted=true, play=0) {
    difference() {
        translate([-s/2,-s/2,0]) {
            union(){
                cuttedCube([s,s,4], 2.5, 2.5);
                if(cutted != true)
                    cube([s,2.5,4]);
            }
        }
        up(2) m3Nut(play=play);
        up(5) m3Screw();
    }
}
