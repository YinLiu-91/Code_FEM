import gmsh
import math
import numpy as np

# 初始化Gmsh
gmsh.initialize()
gmsh.model.add("CFM56 model")

# 定义管长度
L = 1.86393

# 创建几何
x0r1 = max(0, 0.64212 - (0.04777) ** 0.5)
x0r2 = 1 + 0.10158 * math.exp(-11 * (1) - math.exp(-11))
x1r2 = 1 - 0.18453 + 0.10158 * math.exp(-11 * (1) - math.exp(-11))
print(x0r1)
print(x0r2)
print(x1r2)
gmsh.model.geo.addPoint(x0r2, 0, 0, 0.1, 1)
gmsh.model.geo.addPoint(x0r1, 0, 0, 0.1, 2)
gmsh.model.geo.addPoint(L, 0, 0, 0.1, 3)
gmsh.model.geo.addPoint(L, x1r2, 0, 0.1, 4)

# 创建线
gmsh.model.geo.addLine(1, 2, 1)
gmsh.model.geo.addLine(3, 4, 2)

# 创建曲线
p1_list = []
p2_list = []
for index, z in enumerate(np.linspace(0, L, 50, dtype=np.float64)):
    z = z / L
    r1 = max(0, 0.64212 - (0.04777 + 0.98234 * z**2) ** 0.5)
    r2 = 1 - 0.18453 * z**2 + 0.10158 * math.exp(-11 * (1 - z**2) - math.exp(-11))
    # print("r1: ",r1)
    # print("r1: ",r2)
    gmsh.model.geo.addPoint(z * L, r1, 0, 0.05, 1000 + index)
    gmsh.model.geo.addPoint(z * L, r2, 0, 0.05, 2000 + index)
    p1_list.append(1000 + index)
    p2_list.append(2000 + index)
    # gmsh.model.geo.addLine(p1, p2)
# spl1 = gmsh.model.geo.addSpline(p1_list)
# spl2 = gmsh.model.geo.addSpline(p2_list)
# w1 = gmsh.model.geo.addWire([spl1])
# w2 = gmsh.model.geo.addWire([spl2])
# # 创建表面
gmsh.model.geo.addCurveLoop([1, -w1, 2, w2])
gmsh.model.geo.addPlaneSurface([1])

# 生成网格
gmsh.model.geo.synchronize()
gmsh.model.mesh.generate(2)

# 保存几何
gmsh.write("CFM56_model.msh")

# 绘制几何
gmsh.fltk.run()

# 最终化Gmsh
gmsh.finalize()
