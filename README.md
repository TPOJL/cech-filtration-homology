# Topological Data Analysis (TDA) Engine: Cech Complexes & Homology

A Python-based computational engine for **Topological Data Analysis (TDA)**, focusing on the construction of Čech complexes from point clouds in Euclidean spaces, computing their simplicial homologies over Z2, and analyzing filtration events and Euler characteristic curves.

---

## Key Features & Modules

1. **Simplicial Structure (`Simplex`):**
   * Core dataclass representing simplex dimensions and vertex indices.

2. **Čech Complex Construction (`CechComplex`):**
   * Generates point clouds uniformly in hypercubes.
   * Computes exact or approximate Čech complex filtration values using Convex Optimization (SOCP via `cvxpy` with ECOS/SCS solvers) to check for common non-empty ball intersections.

3. **Filtration Events & Sorting:**
   * Automatically computes radius-based filtration values while maintaining face-monotonicity.
   * Implements total ordering (`radius -> dimension -> vertices`) and injection mapping to natural numbers for persistent homology workflows.

4. **Simplicial Homology (Z2):**
   * Computes boundary operator matrices and uses Galois fields (`galois`) to extract Z2-Betti numbers and homology groups (H_0, H_1, H_n).

5. **Euler Characteristic Curves (ECC):**
   * Tracks and plots Euler characteristic trajectories across filtration steps or time.

6. **Visualization Tools:**
   * **2D interactive visualizations** using `matplotlib` sliders for radius (r) and vertex count (k).
   * **Higher-dimensional visualizations** (n > 2) via Principal Component Analysis (PCA) projections.

---

## Requirements & Dependencies

* **Python 3.10+**
* `numpy`
* `cvxpy` (with `ecos` or `scs` solvers)
* `galois`
* `matplotlib`
* `scikit-learn`
* `pyqt5` (for interactive GUI backend)
