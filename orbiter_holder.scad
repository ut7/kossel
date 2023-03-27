include <configuration.scad>;

module holes_profile() {
    difference() {
        hull() {
            for(x=[-24,22])
            for(y=[-6.4,20.2])
            translate([x,y])
            circle(r=2, $fn=16);
        }

        circle(d=9.76, $fn=32);

        translate([17.5,0,0])
        circle(r=m3_wide_radius, $fn=24);

        translate([-19.5,0,0])
        circle(r=m3_wide_radius, $fn=24);
    }
}

module holes_test() {
    union() {
        holes = [[-1,9.8]]; //,[0,9.9], [1, 10]];
        linear_extrude(3) {
            for(d=holes) {
                translate([d[0]*15,0,0]) {
                difference() {
                    square([20,16],true);
                    circle(d=d[1], $fn=32);
                    }
                }
            }
        }
        %for(d=holes) {
            translate([d[0]*15,0,0])
            translate([-6.2,-5.8,0])
            rotate([0,90,0])
            import("PC4-M10.STL");
        }
    }
}

*holes_test();

module holder() {

    difference() {
        union() {
            rotate([0,90,0])
                linear_extrude(15, center=true) {
                    hull()
                    for(x=[-6,-2])
                    for(y=[-24,22])
                    translate([x,y])
                    circle(r=2, $fn=16);
                }
            }

            for (y = [-14.5, 0, 14.5]) {
                translate([0, y, 0])
                cylinder(r=m3_wide_radius, h=20, center=true, $fn=12);

                translate([0, y, thickness])
                cylinder(r=3, h=10, $fn=24);
            }
    }

    translate([-5.5,0,22.2])
    rotate([0,-90,0])
    rotate([0,0,90])
    union() {
        linear_extrude(6) {
            holes_profile();
        }

        %
        translate([-1.345,-7.88,-10.3])
        rotate([180,0,0])
        import("Orbiter_V2.0_Mockup_50k.stl");
    }
    
    for(y=[-23.5,21.5])
    translate([-6,y,5])
    rotate([90,0,0])
    translate([0,0,-2.5])
    linear_extrude(5) {
        polygon([[0,0],[0,12],[13.5,0]]);
    }
    
}

holder();
