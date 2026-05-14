
clc; clear; close all;

%% Define plant (same as always)
G = tf([1], [1, 2, 5]);

%% ---- METHOD 1: Manual PID (analytically derived) ----
Kp = 15;   % Proportional gain
Ki = 10;   % Integral gain
Kd = 3;    % Derivative gain

C_manual = pid(Kp, Ki, Kd);
T_manual = feedback(C_manual * G, 1);

%% ---- METHOD 2: MATLAB Auto-tuning (for comparison) ----
C_auto = pidtune(G, 'PID');
T_auto = feedback(C_auto * G, 1);

%% ---- PLOT: Compare both controllers ----
t = 0:0.01:10;
figure('Name', 'Controller Comparison', 'NumberTitle', 'off');

[y1,t1] = step(T_manual, t);
[y2,t2] = step(T_auto,   t);

plot(t1, y1, 'b-', 'LineWidth', 2.5); hold on;
plot(t2, y2, 'r--', 'LineWidth', 2);
yline(1, 'k--', 'LineWidth', 1);
legend('Manual PID (Kp=15,Ki=10,Kd=3)', 'MATLAB pidtune()', 'Reference');
title('Closed-Loop Step Response — Controller Comparison', 'FontSize', 14);
xlabel('Time (s)'); ylabel('Altitude');
grid on; ylim([0 1.4]);

%% ---- PERFORMANCE METRICS ----
info_m = stepinfo(T_manual);
info_a = stepinfo(T_auto);

fprintf('\n================================================\n');
fprintf('         PERFORMANCE COMPARISON TABLE\n');
fprintf('================================================\n');
fprintf('%-20s %-12s %-12s %-8s\n', 'Metric', 'Manual PID', 'Auto PID', 'Spec');
fprintf('%-20s %-12.2f %-12.2f %-8s\n', 'Overshoot (%)',    info_m.Overshoot,    info_a.Overshoot,    '< 10%');
fprintf('%-20s %-12.2f %-12.2f %-8s\n', 'Settling Time (s)', info_m.SettlingTime, info_a.SettlingTime, '< 3s');
fprintf('%-20s %-12.2f %-12.2f %-8s\n', 'Rise Time (s)',     info_m.RiseTime,     info_a.RiseTime,     '-');
fprintf('================================================\n');

%% ---- VERIFY STABILITY ----
poles_cl = pole(T_manual);
fprintf('\nClosed-Loop Poles (all must be negative real part):\n');
disp(poles_cl);

if all(real(poles_cl) < 0)
    disp('STABILITY: System is STABLE ✓');
else
    disp('WARNING: System may be unstable!');
end

%% ---- SHOW PID PARAMETERS ----
fprintf('\nManual PID: Kp=%.2f  Ki=%.2f  Kd=%.2f\n', Kp, Ki, Kd);
fprintf('Auto PID:   Kp=%.2f  Ki=%.2f  Kd=%.2f\n', ...
    C_auto.Kp, C_auto.Ki, C_auto.Kd);

G = tf([1],[1,2,5]);
C = pid(15, 10, 3);
T = feedback(C*G, 1);
info = stepinfo(T);
fprintf('Overshoot:    %.2f%%\n', info.Overshoot)
fprintf('SettlingTime: %.2fs\n',  info.SettlingTime)

% IF overshoot > 10%: INCREASE Kd or DECREASE Kp
% IF settling > 3s:   INCREASE Kp or INCREASE Ki