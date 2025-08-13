# -----------------------------------------------------------------------------
#
#  Gmsh Python extended tutorial 1
#
#  Geometry and mesh data
#
# -----------------------------------------------------------------------------

# The Python API allows to do much more than what can be done in .geo
# files. These additional features are introduced gradually in the extended
# tutorials, starting with `x1.py'.

# In this first extended tutorial, we start by using the API to access basic
# geometrical and mesh data.

import gmsh
import sys
import numpy as np
from scipy.io import savemat

gmsh.initialize()

if len(sys.argv) > 1 and sys.argv[1][0] != '-':
    # If an argument is provided, handle it as a file that Gmsh can read, e.g. a
    # mesh file in the MSH format (`python x1.py file.msh')
    gmsh.open(sys.argv[1])
else:
    # Otherwise, create and mesh a simple geometry
    gmsh.model.occ.addCone(1, 0, 0, 1, 0, 0, 0.5, 0.1)
    gmsh.model.occ.synchronize()
    gmsh.model.mesh.generate()


# 获取所有节点
node_tags, coords, _ = gmsh.model.mesh.getNodes()
# 获取mat文件中的node数据
node_mat = coords.reshape((-1, 3))[:,0:2]  # 节点坐标只需要前2维

# 获取所有三角形单元（类型2）
element_types, element_tags, node_tags_per_element = gmsh.model.mesh.getElements(dim=2)
# 获取mat文件中的element数据
element_mat=np.hstack((node_tags_per_element[0].reshape((-1,3)),np.ones((len(node_tags_per_element[0])//3,1),dtype=np.uint64))) # 只取三角形单元

# 获取几何entities
# 获取边界信息
entities = gmsh.model.getEntities(dim=1)
assert(len(entities)==8)
edge_mat_34_split=[]
edge_mat_12_split=[]
edge_mat_5_split=[]
for e in entities:
    dim =e[0]
    tag=e[1]
    gmsh.model.mesh.getElements(dim,tag)
    elemTypes, elemTags, elemNodeTags = gmsh.model.mesh.getElements(dim, tag)
    assert(len(elemTags)==1)
    #  计算每个边界的总长度
    edge_length_total=0.0
    elemNodeTags=elemNodeTags[0].reshape((-1,2))
    edge_mat_12_split.append(elemNodeTags.transpose())
    edge_one=np.zeros((2,elemNodeTags.shape[0]),dtype=np.float64)
    edge_bound_one=tag*np.ones((1,elemNodeTags.shape[0]),dtype=np.uint64)
    edge_mat_5_split.append(edge_bound_one)
    for et in elemNodeTags:
        x1=node_mat[et[0]-1][0] # node下标从1开始，需要-1，
        y1=node_mat[et[0]-1][1]
        x2 = node_mat[et[1] - 1][0]
        y2 = node_mat[et[1] - 1][1]
        edge_length_total+=np.sqrt((x1-x2)**2+(y1-y2)**2)
    # 下面根据edge累计边长计算相对值
    edge_length = 0.0
    for index,et in enumerate(elemNodeTags):
        x1 = node_mat[et[0] - 1][0]  # node下标从1开始，需要-1，
        y1 = node_mat[et[0] - 1][1]
        x2 = node_mat[et[1] - 1][0]
        y2 = node_mat[et[1] - 1][1]

        edge_one[0,index]=edge_length/edge_length_total
        edge_length += np.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)
        edge_one[1,index]=edge_length/edge_length_total
    edge_mat_34_split.append(edge_one)

# 拼接起来组成edge_mat的12行
edge_mat_34=edge_mat_34_split[0]
edge_mat_12=edge_mat_12_split[0]
edge_mat_5=edge_mat_5_split[0]

for i in range(len(edge_mat_34_split)-1):
    edge_mat_34=np.hstack((edge_mat_34,edge_mat_34_split[i+1]))
    edge_mat_12=np.hstack((edge_mat_12,edge_mat_12_split[i+1]))
    edge_mat_5=np.hstack((edge_mat_5,edge_mat_5_split[i+1]))
edge_mat_6=np.ones((1,edge_mat_5[0].shape[0]),dtype=np.uint64)
edge_mat_7=np.zeros((1,edge_mat_5[0].shape[0]),dtype=np.uint64)
tmp=1

edge_mat=np.vstack((edge_mat_12.astype(np.float64),edge_mat_34.astype(np.float64),edge_mat_5.astype(np.float64),edge_mat_6.astype(np.float64),edge_mat_7.astype(np.float64)))
# 做最后的修改，确保和code_fem需要的一致
node_mat=node_mat.transpose()
element_mat=element_mat.transpose()

# 保存为 matlab.mat，变量名与字段名一致
savemat('../matlab_my.mat', {'node': node_mat.astype(np.float64), 'edge': edge_mat, 'element': element_mat.astype(np.float64)})
print('已生成 matlab.mat')
# 将上面三个数据存为mat格式
gmsh.clear()

gmsh.finalize()
