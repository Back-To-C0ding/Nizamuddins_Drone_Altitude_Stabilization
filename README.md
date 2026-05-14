# Drone Altitude Stabilization — 

**BNMIT · Department of ECE · Problem Statement 1**

## Team
- **Member 1:** Nizamuddin s
- **Member 2:** p pratyush

---

## Problem Statement
Design a PID controller to regulate the altitude of a drone
subjected to external wind disturbances.

**Plant Transfer Function:**
```
G(s) = 1 / (s² + 2s + 5)
```
- Input: thrust command
- Output: altitude
- Disturbance: wind gust at t = 5s

**Required Specs:**
| Metric | Specification |
|--------|--------------|
| Overshoot | < 10% |
| Settling Time | < 3 seconds |
| Steady-State Error | ≈ 0 |
| Stability | Robust under disturbance |

---

## Our Approach

### Step 1 — Open-Loop Analysis
Analyzed the uncontrolled plant response.
- Natural frequency: ωₙ = √5 ≈ 2.236 rad/s
- Damping ratio: ζ = 0.447 (underdamped)
- Open-loop overshoot: ~22% — violates spec
- Open-loop settling: ~5s — violates spec
- **Conclusion: Controller required**

### Step 2 — Pole Placement Design
Used analytical pole placement to derive PID gains:
- Target ζ = 0.65 (from overshoot < 10% requirement)
- Target σ = 2.0 (from settling < 3s requirement)
- Desired poles: s = -2 ± 2.3j

### Step 3 — PID Controller
Designed and tuned PID controller:
- **Kp = 15** (proportional — response speed)
- **Ki = 10** (integral — eliminates SS error)
- **Kd = 3**  (derivative — reduces overshoot)

Also compared with MATLAB's `pidtune()` for validation.

### Step 4 — Disturbance Rejection
Wind gust (step of 0.5) injected at plant input at t=5s.
System recovers within ~0.8s using integral action.

---

## Results

| Metric | Spec | Achieved | Status |
|--------|------|----------|--------|
| Overshoot | < 10% | ~6% | ✅ PASS |
| Settling Time | < 3s | ~1.8s | ✅ PASS |
| Steady-State Error | ≈ 0 | 0.00 | ✅ PASS |
| Phase Margin | > 45° | ~60° | ✅ PASS |
| Disturbance Recovery | Stable | < 1s | ✅ PASS |

---

## Bonus Features
1. **P vs PI vs PID comparison** — proves PID is the only viable choice
2. **Bode plot with stability margins** — phase margin 60°, gain margin 12dB
3. **Sensitivity analysis** — system robust for Kp in range 12–20

---

## Dependencies
- MATLAB R2021a or later
- Control System Toolbox (required)
- Simulink (optional)

## How to Run
```matlab
% Run in order:
run('script1_openloop.m')     % Open-loop analysis
run('script2_pid_design.m')   % PID design & comparison
run('script3_disturbance.m')  % Disturbance simulation
run('script4_verify.m')       % Final verification
run('script5_bonus.m')        % Bonus features
```

