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
x1r2 = 1 - 0.18453 + 0.10158 * math.exp(-11 * (1-1) - math.exp(-11))
print(x0r1)
print(x0r2)
print(x1r2)


# 创建曲线
p1_list = []
p2_list = []
p11_list = []
p22_list = []
first_r1_zero=0
first_r1_index=0
save_first_r1=True
for index, z in enumerate(np.linspace(0, L, 100, dtype=np.float64)):
    z = z / L
    r1 = max(0, 0.64212 - (0.04777 + 0.98234 * z**2) ** 0.5)
    if r1==0 and save_first_r1:
        first_r1_zero=z
        save_first_r1=False
        first_r1_index=index
        # gmsh.model.geo.addPoint(z * L, r1, 0, 0.05, 1000 + index)
        # gmsh.model.geo.addPoint(-z * L, r1, 0, 0.05, 3000 + index)
        # p1_list.append(1000 + index)
        # p11_list.append(3000 + index)
    r2 = 1 - 0.18453 * z**2 + 0.10158 * math.exp(-11 * (1 - z**2) - math.exp(-11))
    # print("r1: ",r1)
    # print("r1: ",r2)
    
    print(f'x2 x: {z*L}, y: {r2}')
    
    gmsh.model.geo.addPoint(z * L, r2, 0, 0.05, 2000 + index)
    gmsh.model.geo.addPoint(z * L, -r2, 0, 0.05, 4000 + index)
    if save_first_r1 :
        gmsh.model.geo.addPoint(z * L, r1, 0, 0.05, 1000 + index)
        gmsh.model.geo.addPoint(z * L, -r1, 0, 0.05, 3000 + index)
        p1_list.append(1000 + index)
        p11_list.append(3000 + index)
        print(f'x1 x: {z*L}, y: {r1}')
    p2_list.append(2000 + index)
    p22_list.append(4000 + index)
    # gmsh.model.geo.addLine(p1, p2)
print("r1 first zero: ",first_r1_zero*L)
# 创建线
gmsh.model.geo.addLine(p2_list[0], p1_list[0], 1)
gmsh.model.geo.addLine(p11_list[0], p22_list[0], 2)
gmsh.model.geo.addLine(p22_list[-1], p2_list[-1], 3)
# gmsh.model.geo.addLine(p1_list[-1], p11_list[-1], 4)
p11_list.reverse()
spl1 = gmsh.model.geo.addSpline(p1_list+p11_list)
spl2 = gmsh.model.geo.addSpline(p2_list)
spl22 = gmsh.model.geo.addSpline(p22_list)

# # 创建表面
# gmsh.model.geo.addCurveLoop([1, spl1,4,-spl11,2,spl22, 3, -spl2])
gmsh.model.geo.addCurveLoop([1, spl1,2,spl22, 3, -spl2])
gmsh.model.geo.addPlaneSurface([1])

# 生成网格
gmsh.model.geo.synchronize()
gmsh.model.mesh.generate(2)

# 保存几何
gmsh.write("CFM56_model.msh")

# 绘制几何
# gmsh.fltk.run()

# 最终化Gmsh
gmsh.finalize()