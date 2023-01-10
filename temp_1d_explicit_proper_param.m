% 1d explicite temperature
% Proper rock paramters

% User input
np    = 100;   % number of points in space
nt    = 50;   % number of points in time

k     = 1.626;  % conductivity [W/m/K]
rho   = 2272;   % density [kg/m3]
cp    = 816;    % heat capcity [J/K/kg]

x_max      = 105;  % model half width [m]
sill_width = 10;   % [m]

t_sill     = 1000;  % [C]
t_bg       = 50;    % background temperature [C]

% Initial condition
X_vec = linspace(-x_max, x_max, np);
T_vec = t_bg * ones(size(X_vec));
T_vec(abs(X_vec)<sill_width/2) = t_sill;

% time step according to CFL 
dx = X_vec(2)-X_vec(1);
dt = 0.51*dx^2/(k/rho/cp);

% Plot initiation
h_fig = figure;
h_ax  = axes(h_fig);
plot(h_ax, X_vec, T_vec, '-r', 'DisplayName', 'Initial condition');
hold(h_ax, 'on');
h_pl = plot(h_ax, X_vec, T_vec, '-b', 'DisplayName', 'Current state');
h_ax.XLim = [-x_max, x_max];
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
    time       = tstep*dt/3600/24/365;
    h_pl.YData = T_vec;
    h_t.String = ['Step: ', num2str(tstep), ' - Time: ', num2str(time), ' (years)'];
    drawnow;
end