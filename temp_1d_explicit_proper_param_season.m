% 1d explicite temperature
% Proper rock paramters
% Seasonal temperature variations - boundary condition

% Conversions
d2s   = 3600*24;
y2s   = d2s*365;

% User input
np       = 100;   % number of points in space
duration = 40000;     % [years] 

k     = 1.626;  % conductivity [W/m/K]
rho   = 2272;   % density [kg/m3]
cp    = 816;    % heat capcity [J/K/kg]

x_max = 5000;    % model width [m]
t_bg  = 0;     % background temperature [C]
t_amp = 10;    % amplitude of temperature variations [C]

% Initial condition
X_vec = linspace(0, x_max, np);
T_vec = t_bg * ones(size(X_vec));

% time step according to CFL 
dx = X_vec(2)-X_vec(1);
dt = 0.4*dx^2/(k/rho/cp);
nt = ceil(duration*y2s/dt);

% Plot initiation
h_fig = figure;
h_ax  = axes(h_fig);
plot(h_ax, T_vec, X_vec, '-r', 'DisplayName', 'Initial condition');
hold(h_ax, 'on');
h_pl = plot(h_ax, T_vec, X_vec, '-b', 'DisplayName', 'Current state');
h_ax.XLim = [t_bg-t_amp, t_bg+t_amp];
h_ax.YLim = [0, x_max];
h_ax.YDir = 'reverse';
grid(h_ax, 'on')
h_t = title('Step: 0');
xlabel(h_ax, 'Temperature');
ylabel(h_ax, 'Depth');
%legend;

% Prepare for reduced plot (only every x days)
tstep_plot = round(100*y2s/dt);
plot_counter = 0;

% Time loop
Ind = 2:np-1;
for tstep = 1:nt
    % Boundary conditions
    T_vec(1) = t_bg + t_amp*sin(tstep*dt/(20000*y2s)*2*pi);
    
    % Compute new temperature
    T_vec(Ind) = T_vec(Ind) + dt*k/rho/cp*( ...
        ((T_vec(Ind+1)-T_vec(Ind  ))./(X_vec(Ind+1)-X_vec(Ind  ))) - ...
        ((T_vec(Ind  )-T_vec(Ind-1))./(X_vec(Ind  )-X_vec(Ind-1))) )./ ...
        ((X_vec(Ind+1)-X_vec(Ind-1))/2);

    % Update plot
    if mod(tstep, tstep_plot)==0
        plot_counter = plot_counter+1;
        h_pl(plot_counter) = plot(h_ax, T_vec, X_vec, '-r', 'DisplayName', 'Current state');
        if plot_counter>1
            h_pl(plot_counter-1).Color='b';
        end
        %h_pl.XData = T_vec;
        h_t.String = ['Step: ', num2str(tstep), ' - Time: ', num2str(tstep*dt/y2s), ' (years)'];
        %pause(1);
        drawnow;
    end
end