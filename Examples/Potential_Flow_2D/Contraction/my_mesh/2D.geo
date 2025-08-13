//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {0.5, 0, 0, 1.0};
//+
Point(3) = {2.5, 0, 0, 1.0};
//+
Point(4) = {3.0, 0, 0, 1.0};
//+
Point(5) = {0, 1, 0, 1.0};
//+
Point(6) = {0.5, 1, 0, 1.0};
//+
Point(7) = {2.5, 1, 0, 1.0};
//+
Point(8) = {3.0, 1, 0, 1.0};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 4};
//+
Line(4) = {4, 8};
//+
Line(5) = {8, 7};
//+
Line(6) = {7, 6};
//+
Line(7) = {6, 5};
//+
Line(8) = {5, 1};
//+
Curve Loop(1) = {1, 2, 3, 4, 5, 6, 7, 8};
//+
Plane Surface(1) = {1};
//+
Transfinite Curve {1, 7, 5, 3} = 10 Using Progression 1;
//+
Transfinite Curve {2, 6} = 20 Using Progression 1;
//+
Transfinite Curve {8, 4} = 15 Using Progression 1;
