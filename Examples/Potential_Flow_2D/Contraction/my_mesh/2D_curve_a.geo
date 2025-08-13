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
Point(9) = {1.5, 0.35, 0, 1.0};
//+
Point(10) = {1.5, 0.65, 0, 1.0};
//+
Line(1) = {1, 2};
//+
Spline(2) = {2, 9, 3};
//+
Line(3) = {3, 4};
//+
Line(4) = {4, 8};
//+
Line(5) = {8, 7};
//+
Spline(6) = {7, 10, 10, 6};
//+
 Delete {
  Curve{6}; 
}
//+
Spline(6) = {7, 10, 6};
//+
Line(7) = {6, 5};
//+
Line(8) = {5, 1};
//+
Curve Loop(1) = {8, 1, 2, 3, 4, 5, 6, 7};
//+
Plane Surface(1) = {1};
//+
Transfinite Curve {1, 7, 5, 3} = 11 Using Progression 1;
//+
Transfinite Curve {2, 6} = 41 Using Progression 1;
//+
Transfinite Curve {8, 4} = 21 Using Progression 1;
