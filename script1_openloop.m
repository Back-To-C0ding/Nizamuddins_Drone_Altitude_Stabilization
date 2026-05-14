clc; clear; close all;

%% STEP 1: Define the plant (EXACTLY as given in problem statement)
G = tf([1], [1, 2, 5]);   % G(s) = 1/(s^2 + 2s + 5)

disp('=========================================');
disp('        PLANT TRANSFER FUNCTION         ');
disp('=========================================');
G

%% STEP 2: Calculate system parameters
wn   = sqrt(5);           % Natural frequency
zeta = 2 / (2 * wn);      % Damping ratio

fprintf('\n--- System Parameters ---\n');
fprintf('Natural Frequency (wn)  : %.4f rad/s\n', wn);
fprintf('Damping Ratio (zeta)    : %.4f\n', zeta);
fprintf('Open-Loop Poles         : -1 + 2j and -1 - 2j\n');
fprintf('System Type             : Underdamped (zeta < 1)\n');

%% STEP 3: Open-loop step response
figure('Name', 'Open-Loop Step Response', 'NumberTitle', 'off');
step(G);
title('Open-Loop Step Response — NO Controller', 'FontSize', 14);
xlabel('Time (s)'); ylabel('Altitude');
grid on;

% Get step info
info_ol = stepinfo(G);

fprintf('\n--- Open-Loop Performance (NO controller) ---\n');
fprintf('Overshoot     : %.2f%%   (SPEC: < 10%%)  [%s]\n', ...
    info_ol.Overshoot, passOrFail(info_ol.Overshoot < 10));
fprintf('Settling Time : %.2f s  (SPEC: < 3s)   [%s]\n', ...
    info_ol.SettlingTime, passOrFail(info_ol.SettlingTime < 3));
fprintf('Rise Time     : %.2f s\n', info_ol.RiseTime);
fprintf('Conclusion    : CONTROLLER REQUIRED\n');

%% STEP 4: Pole-Zero Map
figure('Name', 'Pole-Zero Map', 'NumberTitle', 'off');
pzmap(G);
title('Pole-Zero Map — Open-Loop Plant', 'FontSize', 14);
grid on;

%% STEP 5: Bode plot
figure('Name', 'Bode Plot', 'NumberTitle', 'off');
bode(G);
title('Bode Plot — Open-Loop Plant', 'FontSize', 14);
grid on;

[Gm, Pm] = margin(G);
fprintf('\n--- Frequency Domain (Open-Loop) ---\n');
fprintf('Gain Margin   : %.2f dB\n', 20*log10(Gm));
fprintf('Phase Margin  : %.2f deg\n', Pm);

disp('\nScript 1 COMPLETE. Save all 3 plot screenshots.');

%% Helper function
function s = passOrFail(cond)
if cond; s = 'PASS'; else; s = 'FAIL'; end
end