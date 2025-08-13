% Solve the steady, potential, compressible flow through a 2D duct

% Add the Core directory to the path
addpath(fullfile('..','..','..','..','Code_FEM','Core'));
addpath(fullfile('..','..','..','..','Code_FEM','Library','Potential_Flow_2D','T6'));


global LIBRARY_PATH %#ok<NUSED>
MANAGE_PATH

% Properties of the flow at infinity
global Flow
Flow.gamma = 1.4;
Flow.rho_inf = 1.2;
Flow.c_inf = 340;
Flow.outlet_velocity = Flow.c_inf*0.13;
Flow.v_inf = Flow.outlet_velocity;

% Create a T3 mesh
% [node, edge, element] = initmesh('geometry', 'Jiggle', 'mean', 'JiggleIter', 20, 'Hmax', 0.1);
% or load an example of mesh
% load mesh_example
load matlab_my
% a=load('mesh_example.mat');

% 验证网格几何
figure;
PLOT_FEM(node(1:2, :), element(1:3, :));  % 显示T3网格
hold on;

fprintf('Mesh info:\n');
fprintf('Nodes: %d\n', size(node,2));
fprintf('Elements: %d\n', size(element,2));
fprintf('Edges: %d\n', size(edge,2));

% 检查边界边的编号
unique_boundary_indices = unique(edge(5,:));
fprintf('Boundary indices in mesh: ');
fprintf('%d ', unique_boundary_indices);
fprintf('\n');
% 标记边界边
for i = 1:size(edge,2)
    if edge(5,i) > 0  % 如果是边界边
        n1 = edge(1,i);
        n2 = edge(2,i);
        plot([node(1,n1), node(1,n2)], [node(2,n1), node(2,n2)], 'r-', 'LineWidth', 2);
        text(mean([node(1,n1), node(1,n2)]), mean([node(2,n1), node(2,n2)]), ...
             sprintf('%d', edge(5,i)), 'Color', 'red', 'FontWeight', 'bold');
    end
end
title('Mesh with boundary indices');
axis equal;
saveas(gcf, 'mesh_bound_tag.png');

% Convert the mesh to T6 elements
% node: 2xN node的坐标
% edge： 7xnum_edge_point,[node1,node2, node_x,node_y,boundary_index,1,0]
[node, edge, element] = convert_T3_T6(node, edge, element);#, @geometry); # 不需要使用geometry公式来优化插入的中点，这样简单
% [node, edge, element] = convert_T3_T6(node, edge, element, @geometry);

% Plot the mesh
figure;
PLOT_FEM(node(1:2, :), element(1:6, :));
axis equal; axis tight; box on;
saveas(gcf, 'mesh.png');

INIT_GEOMETRY

ADD_DOMAIN(node, edge, element);
 
BUILD_MODEL
BUILD_DOF

% The boundary elements need to have access to the T6 elements
ADD_BORDER_DOFS(1, 1:8);


%% Calculate the incompressible flow

% The current solution will be used by the element functions
global U

% Initial solution
U = zeros(N_DOF,1);

% Instead of using a separate model for the incompressible flow the trick
% is to set the reference sound speed to infinity. All the terms associated
% with compressibility will naturally drop from the formulation.
c_inf_backup = Flow.c_inf;
Flow.c_inf = inf;

% Build and solve the linear system
BUILD_SYSTEM;
SOLVE_SYSTEM;

% Restore the actual value of the reference sound speed
Flow.c_inf = c_inf_backup;
clear c_inf_backup


%% Solving non-linear problem for the compressible flow

% Maximum number of iterations for each step
N_MAX_ITER = 100;
% Convergence criteria for the iterations
ERROR = 1.0e-12;

% We use a basic Newton-Raphson method to solve the non-linear equations
for iter=1:N_MAX_ITER
    fprintf('\nITERATION %i\n', iter);
    % Build and solve the linear system for this iteration
    BUILD_SYSTEM;
    Uold = U;
    SOLVE_SYSTEM;
    % The norm of the delta
    e = norm(U);
    % Update the solution
    U = Uold+U;
    % Relative change in solution
    e = e/norm(U);
    % Test for convergence
    fprintf('ITERATION ERROR: %e\n',e);
    if e < ERROR
        break
    end
end

% Plot the velocity potential
figure
PLOT_FEM(node(1:2,:), element(1:6,:), full(U))
axis equal; axis tight; box on;
colorbar;
title('velocity potential');
saveas(gcf, 'velocity_potential.png');


%% Calculate the velocity and other flow properties
get_flow;

% Plot the properties of the flow
figure
PLOT_FEM(node(1:2,:), element(1:6,:), Vx)
axis equal; axis tight; box on;
colorbar;
title('vx');
saveas(gcf, 'vx.png');

figure
PLOT_FEM(node(1:2,:), element(1:6,:), Vy)
axis equal; axis tight; box on;
colorbar;
title('vy');
saveas(gcf, 'vy.png');

figure
PLOT_FEM(node(1:2,:), element(1:6,:), V./c)
axis equal; axis tight; box on;
colorbar;
title('Mach number');
saveas(gcf, 'mach_number.png');

figure
PLOT_FEM(node(1:2,:), element(1:6,:), rho)
axis equal; axis tight; box on;
colorbar;
title('density');
saveas(gcf, 'density.png');

figure
PLOT_FEM(node(1:2,:), element(1:6,:), c)
axis equal; axis tight; box on;
colorbar;
title('sound speed');
saveas(gcf, 'sound_speed.png');
