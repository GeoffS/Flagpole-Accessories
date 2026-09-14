include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

makeTopRing = false;
makeBottomSleeve = false;

topPerimiterWidth = 0.42;

// 3" PVC Schedule 40 pipe from: https://pvcfittingsdirect.com/pvc-pipe-sizes-chart/
tubeOD = 90; // Measured
tubeID = 77; // Measured

mastBaseOD = 53; // Approximate measurement of blue flagpole mast 9/10/2026
mastRingOD = 53; // Approximate measurement of blue flagpole mast 9/12/2026

firstLayerHeight = 0.2;
layerHeight = 0.2;

baseRingAboveTubeZ = 20;
baseRingInsideTubeZ = 30;
baseRingCZ = 3;

 // 10-24'ish:
screwThreadDia = 5.1;
screwHeadDia = 9.8;
screwHeadRecess = 2;
nutDia = 10.75;
nutRecess = 3.7;

module baseRing()
{
	difference()
    {
        // Exterior:
        union()
        {
            // Above tube:
            simpleChamferedCylinder(d=tubeOD, h=baseRingAboveTubeZ, cz=baseRingCZ);
            // Sleave:
            translate([0,0,-baseRingInsideTubeZ]) simpleChamferedCylinder(d=tubeID, h=baseRingInsideTubeZ, cz=6, flip=true);
        }

        // Interior:
        tcy([0,0,-200], d=mastRingOD, h=400);

        // Screw holes:
        translate([0,0,(baseRingAboveTubeZ-baseRingCZ)/2]) 
            for(a=[0, 120, 240]) rotate([0,0,a-90]) rotate([-90,0,0]) 
            {
                // Threads hole:
                cylinder(d=screwThreadDia, h=100);
                // Pan-head recess:
                tcy([0,0,tubeOD/2-screwHeadRecess], d=screwHeadDia, h=100);
                // Nut recess:
                rotate([0,0,-30]) cylinder(d=nutDia, h=mastRingOD/2+nutRecess, $fn=6);
            }
    }
}

bottomSleeveZ = 50;

module bottomSleeve()
{
	difference()
    {
        // Exterior:
        cylinder(d=tubeID, h=bottomSleeveZ);

        // Interior:
        tcy([0,0,-200], d=mastBaseOD, h=400);

        // Top chamfer:
        translate([0,0,bottomSleeveZ-tubeID/2+2*topPerimiterWidth]) cylinder(d2=100, d1=0, h=50);

        // Bottom chamfer:
        translate([0,0,-50+mastBaseOD/2+2]) cylinder(d1=100, d2=0, h=50);
    }
}

module clip(d=0)
{
	tc([-200, -400-d, -200], 400);
}

if(developmentRender)
{
	//display() translate([-100,0,0]) baseRing();
    //display() bottomSleeve();

    display() baseRing();
    display() translate([-100,0,0]) bottomSleeve();
}
else
{
	if(makeTopRing) mirror([0,0,1]) baseRing();
    if(makeBottomSleeve) bottomSleeve();
}
