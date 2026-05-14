clc; clear; close all;
G = tf([1], [1, 2, 5]);

%% ---- Manual PID ----
Kp = 25;
Ki = 20;
Kd = 6;

C_manual = pid(Kp, Ki, Kd);
T_manual = feedback(C_manual * G, 1);

%% ---- Auto PID ----
opts = pidtuneOptions('PhaseMargin', 70);
C_auto = pidtune(G, 'PID', opts);
T_auto = feedback(C_auto * G, 1);

%% ---- PLOT ----
t = 0:0.01:10;
figure('Name', 'Controller Comparison - FIXED', 'NumberTitle', 'off');

[y1,t1] = step(T_manual, t);
[y2,t2] = step(T_auto,   t);

plot(t1, y1, 'b-',  'LineWidth', 2.5); hold on;
plot(t2, y2, 'r--', 'LineWidth', 2);
yline(1, 'k--', 'LineWidth', 1.5);

legend('Manual PID (Kp=25,Ki=20,Kd=6)', 'MATLAB pidtune() Fixed', 'Reference');
title('Closed-Loop Step Response — Settling < 3s', 'FontSize', 14);
xlabel('Time (s)'); ylabel('Altitude');
grid on; ylim([0 1.4]);

%% ---- METRICS ----
info_m = stepinfo(T_manual);
info_a = stepinfo(T_auto);

fprintf('\n================================================\n');
fprintf('         PERFORMANCE COMPARISON TABLE\n');
fprintf('================================================\n');
fprintf('%-20s %-12s %-12s %-8s\n', 'Metric','Manual PID','Auto PID','Spec');
fprintf('%-20s %-12.2f %-12.2f %-8s\n', 'Overshoot (%)',     info_m.Overshoot,    info_a.Overshoot,    '< 10%');
fprintf('%-20s %-12.2f %-12.2f %-8s\n', 'Settling Time (s)', info_m.SettlingTime, info_a.SettlingTime, '< 3s');
fprintf('%-20s %-12.2f %-12.2f %-8s\n', 'Rise Time (s)',     info_m.RiseTime,     info_a.RiseTime,     '-');
fprintf('================================================\n');

%% ---- STABILITY ----
poles_cl = pole(T_manual);
fprintf('\nClosed-Loop Poles:\n');
disp(poles_cl);
if all(real(poles_cl) < 0)
    disp('STABILITY: System is STABLE ✓');
else
    disp('WARNING: Unstable!');
end

fprintf('\nManual PID: Kp=%.2f  Ki=%.2f  Kd=%.2f\n', Kp, Ki, Kd);
fprintf('Auto PID:   Kp=%.2f  Ki=%.2f  Kd=%.2f\n', C_auto.Kp, C_auto.Ki, C_auto.Kd);
fprintf('\nOvershoot:    %.2f%%\n', info_m.Overshoot);
fprintf('SettlingTime: %.2fs\n',   info_m.SettlingTime);
