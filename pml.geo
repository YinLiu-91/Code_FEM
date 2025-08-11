//+
Point(1) = {-100, -100, 0, 1.0};
//+
Point(2) = {100, -100, 0, 1.0};
//+
Point(3) = {100, 100, 0, 1.0};
//+
Point(4) = {-100, 100, 0, 1.0};
//+
Point(5) = {-110, -110, 0, 1.0};
//+
Point(6) = {110, -110, 0, 1.0};
//+
Point(7) = {110, 110, 0, 1.0};
//+
Point(8) = {-110, 110, 0, 1.0};
//+
Point(9) = {-100, 110, 0, 1.0};
//+
Point(10) = {-110, 100, 0, 1.0};
//+
Point(11) = {100, 110, 0, 1.0};
//+
Point(12) = {110, 100, 0, 1.0};
//+
Point(13) = {110, -100, 0, 1.0};
//+
Point(14) = {100, -110, 0, 1.0};
//+
Point(15) = {-110, -100, 0, 1.0};
//+
Point(16) = {-100, -110, 0, 1.0};//+
Line(1) = {1, 4};
//+
Line(2) = {4, 3};
//+
Line(3) = {3, 2};
//+
Line(4) = {2, 1};
//+
Line(5) = {5, 15};
//+
Line(6) = {15, 1};
//+
Line(7) = {1, 16};
//+
Line(8) = {16, 5};
//+
Line(9) = {15, 10};
//+
Line(10) = {10, 4};
//+
Line(11) = {10, 8};
//+
Line(12) = {8, 9};
//+
Line(13) = {9, 4};
//+
Line(14) = {9, 11};
//+
Line(15) = {11, 3};
//+
Line(16) = {11, 7};
//+
Line(17) = {7, 12};
//+
Line(18) = {12, 3};
//+
Line(19) = {12, 13};
//+
Line(20) = {13, 2};
//+
Line(21) = {16, 14};
//+
Line(22) = {14, 2};
//+
Line(23) = {6, 13};
//+
Line(24) = {14, 6};
//+
Curve Loop(1) = {1, 2, 3, 4};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {5, 6, 7, 8};
//+
Plane Surface(2) = {2};
//+
Curve Loop(3) = {7, 21, 22, 4};
//+
Plane Surface(3) = {3};
//+
Curve Loop(4) = {22, -20, -23, -24};
//+
Plane Surface(4) = {4};
//+
Curve Loop(5) = {3, -20, -19, 18};
//+
Plane Surface(5) = {5};
//+
Curve Loop(6) = {15, -18, -17, -16};
//+
Plane Surface(6) = {6};
//+
Curve Loop(7) = {13, 2, -15, -14};
//+
Plane Surface(7) = {7};
//+
Curve Loop(8) = {11, 12, 13, -10};
//+
Plane Surface(8) = {8};
//+
Curve Loop(9) = {9, 10, -1, -6};
//+
Plane Surface(9) = {9};
//+
Physical Surface("computation_domain", 25) = {1};
//+
Physical Surface("pml_domain", 26) = {9, 8, 7, 6, 5, 4, 3, 2};
//+
Physical Curve("pml_left_interface", 27) = {1};
//+
Physical Curve("pml_up_interface", 28) = {2};
//+
Physical Curve("pml_right_interface", 29) = {3};
//+
Physical Curve("pml_down_interface", 30) = {4};
//+
Physical Curve("pml_down_outer_bound", 31) = {8, 21, 24};
//+
Physical Curve("pml_left_outer_bound", 32) = {5, 9, 11};
//+
Physical Curve("pml_up_outer_bound", 33) = {12, 14, 16};
//+
Physical Curve("pml_right_outer_bound", 34) = {17, 19, 23};
//+
Transfinite Curve {1, 2, 3, 4} = 3 Using Progression 1;
//+
Transfinite Curve {9, 21, 19, 14} = 3 Using Progression 1;
//+
Transfinite Curve {11, 13, 15, 17, 5, 7, 22, 23, 24, 20, 6, 8, 10, 12, 16, 18} = 2 Using Progression 1;
