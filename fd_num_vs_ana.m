% Check numerical finite difference vs. analytical
% Convergence Testing!

% User input
np    = 100;
x_max = 2*pi;

% Temperature signal
X_vec = linspace(0, x_max, np);
T_vec = sin(X_vec);

% Analytical derviative
Der_ana = cos(X_vec);

% Numerical derivative
Der_num = (T_vec(2:end)-T_vec(1:end-1))./(X_vec(2:end)-X_vec(1:end-1));

% Plot
h_fig = figure;
h_ax  = axes(h_fig);
plot(h_ax, X_vec, T_vec, '-r', 'DisplayName', 'sin(x)');
hold(h_ax, "on");
plot(h_ax, X_vec, Der_ana, '-b', 'DisplayName', 'Analytical Derivative');
plot(h_ax, (X_vec(2:end)+X_vec(1:end-1))/2, Der_num, '*b', 'DisplayName', 'Numerical Derivative');

% Ornaments
h_ax.XLim(2) = x_max;
grid(h_ax, 'on')
legend;