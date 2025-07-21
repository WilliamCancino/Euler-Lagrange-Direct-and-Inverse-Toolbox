# Euler-Lagrange-Direct-and-Inverse-Toolbox

This repository contains a MATLAB framework designed for the simulation and analysis of dynamic systems using the Euler-Lagrange formulation. The project allows solving both the **direct problem** (simulating the behavior of the system from its known parameters) and the **inverse problem** (estimating unknown parameters of the system from noisy measurements of its behavior).


## 📜 General description

The core of this project is the ability to define a dynamical system symbolically through its Lagrangian and its Rayleigh dissipation function. From this definition, the framework automatically derives the equations of motion, solves them numerically and provides tools to visualize the results.

### ✨ Main Features

- **Automatic equation derivation:** Uses the Euler-Lagrange formulation to derive the equations of motion symbolically.
- **Direct problem solving:** Simulates the time evolution of the generalized coordinates of the system and generates a visual animation of the motion.
- Parameter estimation (inverse problem):** Estimates unknown physical parameters (masses, lengths, friction coefficients, etc.) from "measured" data (simulated with noise).
- Multiple optimization algorithms:** Supports a variety of optimizers to solve the inverse problem, including:
  - Trust-Region-Dogleg (TRD).
  - Levenberg-Marquardt (LMA)
  - Particle Swarm Optimization (PSO)
  - Genetic Algorithm (GA)
  - Stochastic Optimization Strategy (SOS)
  - Simulated Annealing (SA)
  - Pattern Search (PS)
  - Trust-Region-Reflective (TRR)
- Noise simulation:** Allows to add Additive White Gaussian Noise (AWGN) to the measurements to simulate realistic conditions.
- Advanced visualization:** Generates comparative graphs and animations in GIF format of the system dynamics.
- Modular design:** Allows new dynamic systems to be easily defined by creating a single configuration file in the `Variables/` folder.
