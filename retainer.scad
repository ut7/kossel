include <configuration.scad>;

offset = 20;  // Same as DELTA_EFFECTOR_OFFSET in Marlin.
mount_radius = 12.5;  // Hotend mounting screws, standard would be 25mm.
height = 5;

groove_radius = 6;

probe_angle = 240;
probe_spring_radius = 2.5;
probe_spring_recess_depth = 2;

nut_slot_height = 2.7;
layer_height = 0.2;

module retainer() {
  difference() {
    union() {
      cylinder(r=offset-3, h=height, center=true, $fn=60);
      rotate([0, 0, probe_angle]) {
        translate([0, mount_radius+probe_excentricity, 0])
          cylinder(r=probe_tunnel_radius*3, h=height, center=true, $fn=12);
      }
    }
    cylinder(r=groove_radius + extra_radius, h=height+1, center=true);
    for (a = [0:60:359]) if (a != probe_angle) rotate([0, 0, a]) {
      translate([0, mount_radius, 0]) {
        translate([0,0,-height/2 - 0.01]) {
           nut_slot();
           cylinder(r=m3_wide_radius, h=2*height,$fn=12);
        }
      }
    }
    rotate([0, 0, probe_angle]) {
      translate([0, mount_radius+probe_excentricity, 0])
        union() {
          cylinder(r=probe_tunnel_radius, h=2*height, center=true, $fn=12);
          translate([0, 0, -height/2])
            cylinder(r=probe_spring_radius, h=probe_spring_recess_depth, center=true, $fn=12);
        }
    }
    // Groove mount insert slot.
    translate([0, 10, 0])
      cube([2*groove_radius, 20, 20], center=true);
  }
}

module nut_slot(radius=m3_nut_tight_radius,height=nut_slot_height) {
	rotate([0,0,30])
		cylinder(r=m3_nut_tight_radius, h=nut_slot_height, $fn=6);
}

translate([0, 0, height/2])
rotate([180,0,0])
  retainer();
