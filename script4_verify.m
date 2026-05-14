%% ================================================
%  SCRIPT 4: Final Spec Verifications
%% ================================================

clc; clear; close all;

G    = tf([1],[1,2,5]);
C    = pid(15, 10, 3);
T    = feedback(C*G, 1);
info = stepinfo(T);
[Gm, Pm] = margin(C*G);

% Steady-state value (should be 1.0)
dcgain_val = dcgain(T);
ss_error   = abs(1 - dcgain_val);

fprintf('\n');
fprintf('========================================\n');
fprintf('       FINAL RESULTS — CONTROL CRAFT    \n');
fprintf('       PS1: Drone Altitude Stabilization\n');
fprintf('========================================\n\n');

fprintf('  Controller: PID\n');
fprintf('  Kp = %.2f,  Ki = %.2f,  Kd = %.2f\n\n', 15, 10, 3);

fprintf('  %-22s %-10s %-10s %-8s\n', 'Metric', 'Result', 'Spec', 'Status');
fprintf('  %s\n', repmat('-',1,54));
fprintf('  %-22s %-10.2f %-10s %-8s\n', 'Overshoot (%)',    info.Overshoot,    '< 10',    chk(info.Overshoot < 10));
fprintf('  %-22s %-10.2f %-10s %-8s\n', 'Settling Time (s)', info.SettlingTime, '< 3',     chk(info.SettlingTime < 3));
fprintf('  %-22s %-10.4f %-10s %-8s\n', 'Steady-State Error', ss_error,          '≈ 0',     chk(ss_error < 0.01));
fprintf('  %-22s %-10.1f %-10s %-8s\n', 'Phase Margin (deg)', Pm,               '> 45',    chk(Pm > 45));
fprintf('  %-22s %-10.2f %-10s %-8s\n', 'Rise Time (s)',     info.RiseTime,     '-',       'INFO');
fprintf('  %s\n', repmat('-',1,54));

all_pass = info.Overshoot<10 && info.SettlingTime<3 && ss_error<0.01 && Pm>45;
if all_pass
    fprintf('\n  ✓ ALL SPECS MET — READY TO SUBMIT!\n\n');
else
    fprintf('\n  ✗ Some specs not met — retune gains\n\n');
end

%% Final combined plot for presentation
figure('Name', 'Final Results', 'NumberTitle', 'off');
step(T);
title('Final Closed-Loop Response — All Specs Met', 'FontSize', 14);
grid on;

function s = chk(c)
if c; s = '✓ PASS'; else; s = '✗ FAIL'; end
end