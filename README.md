# Topological Data Analysis (TDA) Engine: Čech Complexes & Homology

![Python](https://img.shields.io/badge/Python-3.10%2B-blue.svg)
![CVXPY](https://img.shields.io/badge/CVXPY-SOCP_Optimization-red.svg)
![Galois](https://img.shields.io/badge/Galois-GF(2)_Algebra-purple.svg)
![Jupyter](https://img.shields.io/badge/Jupyter-Interactive_Notebook-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

A Python-based computational engine for **Topological Data Analysis (TDA)**, focusing on the exact geometric construction of Čech complexes from point clouds in arbitrary Euclidean spaces (`ℝᵈ`), computing their simplicial homologies over the finite field `ℤ₂`, and analyzing filtration events and Euler Characteristic Curves (ECC).

---

## Key Features & Architecture

1. **Simplicial Structure (`Simplex`):**
   * Immutable `@dataclass(frozen=True)` representation storing simplex dimension (`dim`) and ordered vertex indices (`vertices`).
2. **Čech Complex Construction via Convex Optimization (`CechComplex`):**
   * Generates uniform point clouds in `d`-dimensional hypercubes.
   * Determines exact multi-ball intersections and minimum enclosing ball radii (`f(σ)`) by formulating a **Second-Order Cone Program (SOCP)** solved via `cvxpy` (`ECOS` and `SCS` solvers), accelerated with pairwise distance pruning (`D_max > 2r`) and filtration caching.
3. **Filtration Events & Face-Monotonicity (`FiltrationEvent`):**
   * Computes exact appearance radii for all simplices while enforcing face-monotonicity (`radius(face) ≤ radius(simplex)`) to prevent numerical solver drift.
   * Establishes a strict total ordering (`radius → dimension → lexicographical vertices`) and maps the filtration bijectively to discrete time steps (`t ∈ ℕ`).
4. **Simplicial Homology Solver over GF(2) (`simplical_homology`):**
   * Constructs boundary operator matrices `∂ₖ : Cₖ → Cₖ₋₁` and performs exact rank computation over the Galois field `GF(2)` using the `galois` library (avoiding floating-point rank instability).
   * Extracts `ℤ₂`-Betti numbers (`β₀, β₁, ..., βₙ`) and homology groups `Hₖ(K; ℤ₂)`.
5. **Euler Characteristic Curves (ECC):**
   * Tracks and plots step-function trajectories of the Euler characteristic `χ(K_t)` across both continuous filtration radii and discrete injection steps.
6. **Interactive Visualization Suite:**
   * **2D Fast Interactive Viewer (`QtAgg`):** Precomputes circumradii and minimum enclosing circles for all edges and triangles, enabling zero-latency real-time filtering via dual `matplotlib` sliders for radius `r` and active vertex count `k`.
   * **High-Dimensional Projection (`d > 2`):** Projects higher-dimensional simplicial complexes onto 2D via Principal Component Analysis (`PCA`) with dimension-scaled opacity rendering.

---

## Mathematical Formulation

### 1. Čech Filtration Value (Minimum Enclosing Ball as SOCP)
A simplex `σ = [p₀, p₁, ..., pₘ]` enters the Čech filtration at radius `r` if and only if the closed balls `B(pᵢ, r)` share a common intersection point `x ∈ ℝᵈ`. Finding the exact filtration value `f(σ)` is formulated as a Second-Order Cone Program:

    f(σ) = min_{x ∈ ℝᵈ, t ∈ ℝ}   t
           subject to            ‖x - pᵢ‖₂ ≤ t,   ∀i ∈ {0, ..., m}
                                 t ≥ 0

### 2. Simplicial Homology over ℤ₂ & Betti Numbers
Given the chain complex `... → Cₖ₊₁ → Cₖ → Cₖ₋₁ → ...` with boundary matrices `∂ₖ` over `ℤ₂`, the `k`-th Betti number `βₖ` is computed via the Rank-Nullity Theorem in `GF(2)`:

    βₖ = dim(ker ∂ₖ) - dim(im ∂ₖ₊₁) = dim(Cₖ) - rank_ℤ₂(∂ₖ) - rank_ℤ₂(∂ₖ₊₁)

    Hₖ(K; ℤ₂) ≅ (ℤ₂)^(βₖ)

### 3. Euler Characteristic Curve (ECC)
Across the ordered filtration steps, the topological invariant `χ` is tracked incrementally:

    χ(K) = ∑ (-1)^k · |Sₖ| = ∑ (-1)^k · βₖ

---

## Built-in Topological Verification Suite

The notebook includes automated triangulation benchmarks validating the homology and Euler characteristic solvers against canonical manifolds:

| Manifold | Triangulation | Computed Homology (`ℤ₂`) | Euler Characteristic (`χ`) |
| :--- | :--- | :--- | :---: |
| **2-Sphere (`S²`)** | Boundary of a 3-simplex (4 vertices, 6 edges, 4 triangles) | `H₀ = ℤ₂`, `H₁ = 0`, `H₂ = ℤ₂` | `2` |
| **2-Torus (`T²`)** | `3 × 3` periodic grid (9 vertices, 27 edges, 18 triangles) | `H₀ = ℤ₂`, `H₁ = ℤ₂²`, `H₂ = ℤ₂` | `0` |
| **Real Projective Plane (`ℝP²`)** | Minimal 6-vertex triangulation (6 vertices, 15 edges, 10 triangles) | `H₀ = ℤ₂`, `H₁ = ℤ₂`, `H₂ = ℤ₂` | `1` |

---

## Getting Started

### Option 1: Automated Launch (macOS / Linux)

    git clone [https://github.com/TPOJL/YOUR_REPO_NAME.git](https://github.com/TPOJL/YOUR_REPO_NAME.git)
    cd YOUR_REPO_NAME
    chmod +x run.sh
    ./run.sh

### Option 2: Manual Setup

1. **Clone the repository:**

       git clone [https://github.com/TPOJL/YOUR_REPO_NAME.git](https://github.com/TPOJL/YOUR_REPO_NAME.git)
       cd YOUR_REPO_NAME

2. **Create and activate a virtual environment:**

       python3 -m venv venv
       source venv/bin/activate  # On Windows: venv\Scripts\activate

3. **Install dependencies and open the notebook:**

       pip install -r requirements.txt
       jupyter notebook TAO_projekt.ipynb

---

## Project Structure

    ├── TAO_projekt.ipynb    # Core TDA engine, SOCP solver, GF(2) homology & interactive plots
    ├── requirements.txt     # Python dependencies (cvxpy, galois, PyQt5, scikit-learn, etc.)
    ├── run.sh               # Automated environment setup and Jupyter launcher
    └── README.md            # Architectural & mathematical documentation
