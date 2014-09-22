include <configuration.scad>;

offset = 20;  // Same as DELTA_EFFECTOR_OFFSET in Marlin.
mount_radius = 12.5;  // Hotend mounting screws, standard would be 25mm.
height = 5;

groove_radius = 6;
groove_height = 4.6;

probe_angle = 60;
probe_spring_radius = 2.5;


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
    for (a = [0:60:359]) rotate([0, 0, a]) {
      translate([0, mount_radius, 0])
        cylinder(r=m3_radius, h=2*height, center=true, $fn=12);
    }
    rotate([0, 0, probe_angle]) {
      translate([0, mount_radius+probe_excentricity, 0])
        union() {
          cylinder(r=probe_tunnel_radius, h=2*height, center=true, $fn=12);
          translate([0, 0, -height/2])
            cylinder(r=probe_spring_radius, h=1, center=true, $fn=12);
        }
    }
    // Groove mount insert slot.
    translate([0, 10, 0])
      cube([2*groove_radius, 20, 20], center=true);
  }
}

translate([0, 0, height/2])
  retainer();
