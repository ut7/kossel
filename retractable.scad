include <configuration.scad>;

use <microswitch.scad>;

height = 36;
tunnel = 3.3;
face_offset = 4;

epsilon = 0.0001;

module foot(thickness) {
  difference() {
    translate([12.5, 0, 0]) rotate([0, 0, -60])
      translate([-12.5, 0, thickness/2]) rotate([0, 0, -60]) union() {
        cylinder(r=5, h=thickness, center=true, $fn=24);
        translate([10, 0, 0])
          cube([20, 10, thickness], center=true);
    }
    // epsilon below to create slight overlap between feet
    // avoids "not a 2-manifold" error.
    translate([0, -10-epsilon, 0])
      cube([40, 20, 20], center=true);
    translate([12.5, 0, 0]) {
      // Space for bowden push fit connector.
      cylinder(r=6.49, h=2*thickness, center=true, $fn=32);
      for (a = [60:120:359]) {
          rotate([0, 0, a]) translate([-12.5, 0, 0])
          cylinder(r=m3_wide_radius, h=20, center=true, $fn=12);
      }
    }
  }
}
module retractable(height,tunnel,foot_thickness) {
  difference() {
    union() {
      translate([0, 0, height/2])
        cylinder(r=6, h=height, center=true, $fn=32);
      translate([0, -3, height/2])
        cube([12, 6, height], center=true);
      // Lower part on the left.
      translate([-6, 0, height/2])
        cylinder(r=6, h=height, center=true, $fn=32);
      translate([-3, 0, height/2])
        cube([6, 12, height], center=true);
      translate([-3, -3, height/2])
        cube([18, 6, height], center=true);
      // Feet for vertical M3 screw attachment.
      translate([0,5,0]) {
        rotate([0, 0, 90]) {
          foot(foot_thickness);
          scale([1, -1, 1]) foot(foot_thickness);
        }
      }
    }
    translate([-19, 0, height/2+6]) rotate([0, 15, 0])
      cube([20, 20, height], center=true);
    cylinder(r=tunnel/2+extra_radius, h=3*height, center=true, $fn=12);
    translate([0, -6, height-1])
      cube([tunnel-0.5, 12, height], center=true);
    rotate([0, 0, 30]) translate([0, -6, 3*height/2-4])
      cube([tunnel, 12, height], center=true);
    // Safety needle M2.5 screw hole
    translate([-4.5, 0, height-11]) rotate([90, 0, 0])
      cylinder(r=2.5/2, h=40, center=true, $fn=12);
    // Safety needle pinhole
    translate([-4, -face_offset, height-2]) rotate([90, 0, 0])
      cylinder(r=1/2, h=10, center=true, $fn=12);
    // Hole for strain relief M3 screw
    translate([-4.5, 6-8, foot_thickness+5]) rotate([-90, 0, 0])
      cylinder(r=1.5, h=40, center=false, $fn=12);
    // Effector screw heads.
    //rotate([0, 0, 330]) translate([-12.5, 0, 2])
    //  cylinder(r=4, h=30, $fn=24);
    // Flat front face.
    translate([0, -face_offset-10, height/2]) difference() {
      cube([30, 20, 2*height], center=true);
    }
    // Sub-miniature micro switch.
    translate([-2.5, -face_offset-3, height-21]) {
      % microswitch();
      for (x = [-9.5/2, 9.5/2]) {
        translate([x, 0, 0]) rotate([90, 0, 0])
          cylinder(r=2.5/2, h=40, center=true, $fn=12);
      }
    }
  }
}

retractable(height,tunnel,4);
