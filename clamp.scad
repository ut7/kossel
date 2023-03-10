include <configuration.scad>;

sticky_width = 20;
sticky_length = thickness;
sticky_offset = 8;  // Distance from screw center to glass edge.

// Make the round edge line up with the outside of OpenBeam.
screw_offset = sticky_width/2 - 7.5;
cube_length = sticky_length + sticky_offset - screw_offset;
arm_length = 60;
clamp_depth = 60;

module plate() {
    difference() {
        hull() {
            translate([-sticky_width/2, 0, 0])
            cube([sticky_width, thickness, arm_length - corner_radius]);
            corner_radius = 2;
            for(x=[-1, 1])
                translate([
                    x * (sticky_width/2 - corner_radius),
                    0,
                    arm_length - corner_radius
                ])
                rotate([-90, 0, 0])
                cylinder(r = corner_radius, h=thickness, $fn=32);
        }
        
        hull() {
            for(z=[10, arm_length - 5]) {
                translate([0, 5, z])
                rotate([90, 0, 0])
                cylinder(r = m3_wide_radius, h=10, $fn=32);
            }
        }
    }
}

module bottom_arm() {
    translate([0, -sticky_offset, 0]) {
        difference() {
            translate([0, screw_offset, thickness/2]) {
                difference() {
                    cylinder(r=sticky_width/2, h=thickness, center=true);
                    translate([-50, sticky_offset + thickness - screw_offset, -50])
                    cube([100,100,100], center=false);
                }
                translate([0, cube_length/2, 0])
                cube([sticky_width, cube_length, thickness], center=true);
            }
            cylinder(r=m3_wide_radius, h=20, center=true, $fn=12);
        }

    }

    plate();
}

module top_arm() {
    translate([0, -clamp_depth, 0]) hull() {
        cylinder(r=sticky_width/2, h=thickness, center=false);


        translate([-sticky_width/2, clamp_depth, 0])
        cube([sticky_width, thickness, thickness], center=false);
    }

    plate();
}

rotate([-90, 0, 0])
{
    bottom_arm();
    translate([30, 0, 0]) top_arm();
}