#!/bin/bash
# python环境为rocm
python ./nacell_full.py # 生成网格
python ./convert_msh_2_mat.py  ./CFM56_model.msh40 # 转为为matlab_my.mat文件
cd ../
octave-cli main.m # 执行m文件，计算流场结果