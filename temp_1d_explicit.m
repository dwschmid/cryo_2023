% 1d explicite temperature

% User input
np    = 100;   % number of points in space
nt    = 1000;   % number of points in time
dt    = 1e-3; 
k     = 1;
rho   = 1;
cp    = 1;
x_max = 2*pi;

% Initial condition
X_vec = linspace(0, x_max, np);
T_vec = sin(X_vec);

% Plot initiation
h_fig = figure;
h_ax  = axes(h_fig);
plot(h_ax, X_vec, T_vec, '-r', 'DisplayName', 'Initial condition');
hold(h_ax, 'on');
h_pl = plot(h_ax, X_vec, T_vec, '.b', 'DisplayName', 'Current state');
h_ax.XLim(2) = x_max;
grid(h_ax, 'on')
h_t = title('Step: 0');
legend;

% Time loop
Ind = 2:np-1;
for tstep = 1:nt
    T_vec(Ind) = T_vec(Ind) + dt*k/rho/cp*( ...
        ((T_vec(Ind+1)-T_vec(Ind  ))./(X_vec(Ind+1)-X_vec(Ind  ))) - ...
        ((T_vec(Ind  )-T_vec(Ind-1))./(X_vec(Ind  )-X_vec(Ind-1))) )./ ...
        ((X_vec(Ind+1)-X_vec(Ind-1))/2);

    % Update plot
    h_pl.YData = T_vec;
    h_t.String = ['Step: ', num2str(tstep)];
    drawnow;
end