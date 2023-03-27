include <configuration.scad>;
use <frame_top.scad>;

glass_radius = 170.5/2;

module beam(length) {
    scale([length,1,1])
    rotate([0,90,0])
    import("openbeam.stl");
}


module corner_and_beam() {
    translate([0, -151.559, -7.5])
    union() {
        frame_top();

        rotate([0,0,120])
        translate([11.25,16,0])
        beam(240);
    }
}

module hotbed() {
    bed_inner_radius = 180.4;
    d = bed_inner_radius/cos(30)/2 - 7.501;
    color("purple")
    linear_extrude(2)
    difference() {
        hull() {
            for(a=[0:60:360])
            rotate([0,0,a])
            translate([d,0,0])
            circle(r=6.5, $fn=64);
        }
        for(a=[0:60:360])
        rotate([0,0,a])
        translate([d,0,0])
        circle(d=4, $fn=16);
    }
    
    for(a=[0:60:360])
    rotate([0,0,a])
    translate([-12,d*sqrt(3)/2+4, 2.5])
    color("black")
    cube([3,1.5,1], center=true);
}

module glass() {
    color("grey", alpha=0.5)
    linear_extrude(3)
    circle(r=glass_radius, $fn=128);
}

module printer_bottom() {
    color("grey")
    for(a=[0,120,240])
    rotate([0,0,a])
    corner_and_beam();

    hotbed();

    translate([0,0,2.01])
    glass();
}

module glass_tab() {
  rotate([0,0,90])
  difference() {
    linear_extrude(6) {
        difference() {
      
            hull() {
                for(x=[-1,1])
                translate([x*10,-6,0])
                circle(d=3, $fn=32);

                for(x=[-1,1])
                translate([x*30,10,0])
                circle(d=3, $fn=32);
            }
            
            
            translate([0, glass_radius + 6.555, 0])
            circle(r=glass_radius+0.1, $fn=128);

            hull() {
                  for(y=[0,-2])
                  translate([0,y])
                  circle(r=m3_wide_radius, $fn=32);
              }
        }
    }
      
    translate([0,11,0])
    cube([80,20,4], center=true);
      
    translate([14,1.5,5.5])
    rotate([0,0,38.7])
    scale(.5)
    scale([1,1,10])
         import("logo_ut7_fixed.stl");

      
  } 
}

module glass_tabs() {
    for(a=[0:120:360])
    rotate([0,0,a+90])
    translate([91.8,0,0])
    glass_tab();
}

printer_bottom();
%glass_tabs();

*rotate([180,0,0])
glass_tab();
