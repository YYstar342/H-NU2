% 初始化参数
F_p = 20;  % 平台罚金
F_g = 20;  % 政府罚金
C_g = 11;  % 政府监管成本
C_p = 5;   % 平台审查成本
C_u = 4;   % 用户反馈成本
R_g = 10;  % 政府声誉溢价
R_p = 10;  % 平台声誉溢价
V = 15;    % 用户从安全APP中获得的价值
phi = char(966);  % 使用 Unicode 表示希腊字母 ϕ
synergy = 30;  % 协同收益

% 复制动态方程的定义
dx_dt = @(x, y, z) x.* (1 - x).* ((R_g * z + F_p - C_g + phi * synergy * y) - 0); % 政府
dy_dt = @(x, y, z) y.* (1 - y).* ((R_p * z - C_p + (1 - phi) * synergy * x) - 0); % 平台
dz_dt = @(x, y, z) z.* (1 - z).* ((V + F_p - C_u) - 0);  % 用户



% 设置初始策略选择概率 (x, y, z)
x0 = 0.5;  % 政府初始选择“监管”的概率
y0 = 0.5;  % 平台初始选择“审查”的概率
z0 = 0.5;  % 用户初始选择“反馈”的概率
initial_conditions = [x0, y0, z0];

% 时间范围
tspan = [0, 100];

% 定义三方复制动态方程
dynamics = @(t, vars) [
    dx_dt(vars(1), vars(2), vars(3));
    dy_dt(vars(1), vars(2), vars(3));
    dz_dt(vars(1), vars(2), vars(3));
];


% 使用 ode45 求解方程
[t, vars] = ode45(dynamics, tspan, initial_conditions);

% 提取结果
x = vars(:, 1);  % 政府策略概率
y = vars(:, 2);  % 平台策略概率
z = vars(:, 3);  % 用户策略概率


% 绘制结果
figure;
plot(t, x, 'r', 'LineWidth', 1.5); hold on;
plot(t, y, 'g', 'LineWidth', 1.5);
plot(t, y, 'b', 'LineWidth', 1.5);
xlabel('Time');
ylabel('Strategy Probability');
legend('Government (x)', 'Platform (y)', 'User (z)');
title('Evolution of Strategies over Time');
grid on; 