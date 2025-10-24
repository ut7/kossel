include <configuration.scad>
use <retainer.scad>

separation = 40;  // Distance between ball joint mounting faces.
offset = 20;  // Same as DELTA_EFFECTOR_OFFSET in Marlin.
mount_radius = 12.5;  // Hotend mounting screws, standard would be 25mm.
hotend_radius = 8;  // Hole for the hotend (J-Head diameter is 16mm).
push_fit_height = 4;  // Length of brass threaded into printed plastic.
push_fit_radius = 5;
height = 8;
cone_r1 = 2.5;
cone_r2 = 14;

probe_angle = 60; // angle where the Z-probe goes through effector

hotend_top_shelf_height = 3.7;


module effector() {
  difference() {
    union() {
      cylinder(r=offset-3, h=height, center=true, $fn=60);
      for (a = [60:120:359]) rotate([0, 0, a]) {
        rotate([0, 0, 30]) translate([offset-2, 0, 0])
          cube([10, 13, height], center=true);
        for (s = [-1, 1]) scale([s, 1, 1]) {
          translate([0, offset, 0]) difference() {
            intersection() {
              cube([separation, 40, height], center=true);
              translate([0, -4, 0]) rotate([0, 90, 0])
                cylinder(r=10, h=separation, center=true);
              translate([separation/2-7, 0, 0]) rotate([0, 90, 0])
                cylinder(r1=cone_r2, r2=cone_r1, h=14, center=true, $fn=24);
            }
            rotate([0, 90, 0])
              cylinder(r=m3_radius, h=separation+1, center=true, $fn=12);
            rotate([90, 0, 90])
              cylinder(r=m3_nut_radius, h=separation-24, center=true, $fn=6);
          }
        }
      }
    }
    translate([0, 0, height/2 - hotend_top_shelf_height])
      cylinder(r=hotend_radius + 2*extra_radius, h=height, $fn=36);
    translate([0, 0, -6]) cylinder(r=push_fit_radius, h=height);
    for (a = [0:60:359]) rotate([0, 0, a]) {
      if (a != probe_angle)
        translate([0, mount_radius, 0])
          cylinder(r=m3_wide_radius, h=2*height, center=true, $fn=12);
    }
    rotate([0, 0, probe_angle]) {
      translate([0, mount_radius+probe_excentricity, 0])
        cylinder(r=probe_tunnel_radius+0.1, h=2*height, center=true, $fn=12);
    }
  }
}

module e3dv6() {
    translate([0, 0, -17.66])
    rotate([90, 0, 0])
    color("lightgrey")
    import("reference/E3D_V6_1.75mm_Universal_HotEnd_Mockup.stl");

    // silicone sock
    color("blue", alpha=0.5)
    translate([-16,-8.5,-53.2])
    cube([21,17,12.5]);
}


%translate([0, 0, 8])
rotate([180, 0, 0]) {
    e3dv6();
    translate([0, 0, -2.6])
    retainer();
}

translate([0, 0, height/2]) effector();