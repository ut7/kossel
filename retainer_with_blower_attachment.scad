include <configuration.scad>;
use <retainer.scad>
use <effector.scad>

height = 8;

lateral_spacing = 18;
thickness=3;

module blower_with_duct() {
    import("reference/turbo_fan_40x40x10_noname_fan.stl");

    translate([0, 5,-23])
    difference() {
        intersection() {
            cube([40,10,6], center=true);
            
            translate([0,3.5,5])
            rotate([0, 90 ,0])
            cylinder(h=100, d=18, $fn=32, center=true);
        }
        translate([0,5,0])
        cube([38,8,5], center=true);
    }
}

module retainer_with_blower_holder() {
    retainer();
    
    difference() {
    
        for(a=[0,180])
        rotate([0,0,a])
        translate([lateral_spacing,0,0])
        {
            rotate([90,0,90])
            linear_extrude(thickness) {
                hull()
                for(x=[-1,1]) {
                    for(y=[-11,-46])
                    translate([x*17.5,y])
                    circle(d=6, $fn=16);

                    for(y=[0])
                    translate([x*9,y])
                    circle(d=5, $fn=16);
                }
            }
        }
        
        translate([0,0,-28.4])
        for(x=[-1,1],y=[-1,1])
        translate([0,x*17.5,y*17.5])
        rotate([90, 0, 90])
        cylinder(r=m3_radius, h=100, center=true, $fn=16);
        
        hull() {
            for(z=[-22,-32])
            translate([0, 0, z])
            rotate([90, 0, 90])
            cylinder(d=24, h=100, center=true, $fn=6);
        }
    }
}

module retainer_with_attachment_holes() {
    retainer();
    
    for(a=[0,180])
    rotate([0,0,a])
    translate([14.5,0,2.5])
    rotate([90,0,90])
    linear_extrude(4)
    difference() {
        translate([0, -3])
        {
            hull()
            for(x=[-1,1], y=[0,-5]) {
                translate([x*8, y])
                circle(d=6, $fn=16);
            }
        }

        for(x=[-1,1])
        translate([x*7,-7])
        circle(r=m3_radius, $fn=16);
    }
}

module blower_attachment() {
    rotate([90,0,90])
    linear_extrude(thickness)
    difference() {
        hull()
        for(x=[-1,1]) {
            for(y=[-11,-46])
            translate([x*17.5,y])
            circle(d=6, $fn=16);

            translate([x*9,-1])
            circle(d=5, $fn=16);
        }
    
        translate([0, -28.4])
        for(x=[-1,1],y=[-1,1])
        translate([x*17.5, y*17.5])
        circle(r=m3_radius, $fn=16);
        
        hull() {
            for(y=[-22,-32])
            translate([0, y])
            circle(d=24, $fn=6);
        }

        for(x=[-1,1])
        translate([x*7,-6])
        hull()
        for(y=[0,4])
        translate([0,y])
        circle(r=m3_wide_radius, $fn=16);
        
    
    }
}

%color("lightblue") translate([0, 0, height/2]) effector();

translate([0, 0, 8])
rotate([180, 0, 0]) {
    %translate([0, 0, 0])
    e3dv6();
    
    translate([0, 0, -2.6])
    retainer_with_attachment_holes();
    
    %
    for(a=[0, 180]) rotate([0, 0, a])
    translate([18.5, 0, (a>0 ? -4.2: -1.5)])
    {
        blower_attachment();
        translate([10 + thickness,0,-28.4])
        rotate([0,0,90])
        blower_with_duct();
    }
 
    *translate([0, 0, -2.5])
    retainer_with_blower_holder();
}

*
rotate([180,0,0])
retainer_with_attachment_holes();

!rotate([0,90,0])
blower_attachment();
