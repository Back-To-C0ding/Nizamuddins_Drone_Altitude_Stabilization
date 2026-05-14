%% ================================================
%  SCRIPT 3: Disturbance Simulation
%  Wind gust applied at plant input at t = 5s
%% ================================================

clc; clear; close all;

%% Setup
G  = tf([1], [1, 2, 5]);
C  = pid(15, 10, 3);

%% Time vector: 0 to 15 seconds
t  = 0:0.01:15;
n  = length(t);

%% Reference: step to altitude = 1 at t = 0
r  = ones(1, n);

%% Disturbance: wind gust (step of 0.5) at t = 5s
d  = zeros(1, n);
d(t >= 5) = 0.5;   % gust magnitude = 0.5

%% Closed-loop transfer functions (correct way)
T_ref  = feedback(C * G, 1);  % reference → output
T_dist = feedback(G, C);      % disturbance → output (correct!)

%% Simulate responses
y_ref   = lsim(T_ref,  r, t);   % response to reference
y_dist  = lsim(T_dist, d, t);   % response to disturbance
y_total = y_ref + y_dist;        % total = superposition

%% Without controller (for comparison)
y_no_ctrl = lsim(G, r, t);

%% ---- PLOT 1: Main comparison ----
figure('Name', 'Disturbance Response', 'NumberTitle', 'off');

subplot(2,1,1);
plot(t, y_total,    'b-',  'LineWidth', 2.5); hold on;
plot(t, y_no_ctrl, 'r--', 'LineWidth', 2);
yline(1,  'k--', 'Reference (Target Altitude)', 'LineWidth', 1);
xline(5,  'g--', 'Wind Gust @ t=5s', 'LineWidth', 1.5);
legend('With PID Controller', 'Without Controller');
title('Drone Altitude — With vs Without Controller + Wind Disturbance', 'FontSize', 13);
xlabel('Time (s)'); ylabel('Altitude (m)');
grid on; ylim([0 1.6]);

subplot(2,1,2);
plot(t, y_dist, 'm-', 'LineWidth', 2);
xline(5, 'g--', 'Wind Gust @ t=5s');
yline(0, 'k--');
title('Altitude Deviation Due to Wind Disturbance', 'FontSize', 13);
xlabel('Time (s)'); ylabel('Deviation (m)');
grid on;

%% ---- Calculate disturbance recovery time ----
y_after_dist  = y_total(t >= 5);
t_after_dist  = t(t >= 5) - 5;
recovered_idx = find(abs(y_after_dist - 1) < 0.02, 1);

fprintf('\n--- Disturbance Analysis ---\n');
fprintf('Wind gust applied at : t = 5s\n');
fprintf('Max altitude drop    : %.4f m\n', min(y_dist));

if ~isempty(recovered_idx)
    fprintf('Recovery time        : %.2f s after gust\n', t_after_dist(recovered_idx));
    fprintf('Result               : SYSTEM RECOVERS SUCCESSFULLY ✓\n');
else
    fprintf('WARNING: System did not recover within simulation time!\n');
end

disp('\nScript 3 COMPLETE. Screenshot both subplots.');