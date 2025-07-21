# Euler-Lagrange-Direct-and-Inverse-Toolbox

This repository contains a MATLAB framework designed for the simulation and analysis of dynamic systems using the Euler-Lagrange formulation. The project allows solving both the **direct problem** (simulating the behavior of the system from its known parameters) and the **inverse problem** (estimating unknown parameters of the system from noisy measurements of its behavior).


## 📜 General description

The core of this project is the ability to define a dynamical system symbolically through its Lagrangian and its Rayleigh dissipation function. From this definition, the framework automatically derives the equations of motion, solves them numerically and provides tools to visualize the results.

### ✨ Main Features

- **Automatic equation derivation:** Uses the Euler-Lagrange formulation to derive the equations of motion symbolically.
- **Direct problem solving:** Simulates the time evolution of the generalized coordinates of the system and generates a visual animation of the motion.
- **Parameter estimation (inverse problem):** Estimates unknown physical parameters (masses, lengths, friction coefficients, etc.) from "measured" data (simulated with noise).
- **Multiple optimization algorithms:** Supports a variety of optimizers to solve the inverse problem, including:
  - Trust-Region-Dogleg (TRD).
  - Levenberg-Marquardt (LMA)
  - Particle Swarm Optimization (PSO)
  - Genetic Algorithm (GA)
  - Stochastic Optimization Strategy (SOS)
  - Simulated Annealing (SA)
  - Pattern Search (PS)
  - Trust-Region-Reflective (TRR)
- **Noise simulation:** Allows to add Additive White Gaussian Noise (AWGN) to the measurements to simulate realistic conditions.
- **Advanced visualization:** Generates comparative graphs and animations in GIF format of the system dynamics.
- **Modular design:** Allows new dynamic systems to be easily defined by creating a single configuration file in the `Variables/` folder.

## 📂 Project structure.

The repository is organized as follows to separate logic, system definitions and run scripts:

├── RunDirect.m # Script to run the direct problem
├── RunInverse.m # Script to run the inverse problem
├── Scripts/
│ ├── Animator/ # Scripts to generate the animation of each system (AnimatorXX.m)
│ │ ├── Animator01.m
│ │ ├── Animator02.m
│ │ ├── Animator03.m
│ │ ├── Animator04.m
│ │ ├── Animator05.m
│ │ ├── Animator06.m
│ │ ├── Animator07.m
│ ├── General/ # Utility functions (solvers, plotters, etc.)
│ │ ├── AddNoise.m
│ │ ├── ChooseAnim.m
│ │ ├── DynamicEqSolver.m
│ │ ├── IsNumeric.m
│ │ ├── LagrangeDynamicEqDeriver.m
│ │ ├── ObjFunc.m
│ │ ├── PlotEq.m
│ │ ├── SsOdeSolver.m
│ │ ├── SymsWs.m
│ │ ├── UpdateConst.m
├── Variables/
│ ├── Vars01.m # Definition file for system 01 (e.g. double pendulum)
│ ├── Vars02.m
│ ├── Vars03.m
│ ├── Vars04.m
│ ├── Vars05.m
│ ├── Vars06.m
│ ├── Vars07.m
└── README.md
