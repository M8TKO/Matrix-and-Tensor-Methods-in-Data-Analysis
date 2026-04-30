# Classification of Handwritten Digits using HOSVD and Tangential Distance

This repository contains a mathematical study of handwritten digit classification on
USPS digit data. The main focus is not software engineering, but the use of matrix
and tensor methods to model digit images, compare classification metrics, and study
how invariance to small geometric transformations affects accuracy.

The project was prepared at the University of Zagreb, Faculty of Science,
Department of Mathematics, by Duje Perkovic, Matko Petricic, and Paula Horvat.
The full write-up is available in [`Final Paper/main.pdf`](Final%20Paper/main.pdf).

## Mathematical Motivation

Each handwritten digit is represented as a `16 x 16` grayscale image, or
equivalently as a vector in `R^256`. The central question is how to classify an
unknown digit by exploiting the geometry of these images rather than treating
classification as a purely black-box machine learning problem.

The project compares two main mathematical ideas:

1. **HOSVD-based subspace classification**
2. **Tangential distance as a transformation-invariant metric**

It also studies hybrid methods that combine the speed of HOSVD with the geometric
sensitivity of tangential distance.

## HOSVD Classifier

For each digit class `k in {0, ..., 9}`, the training samples are arranged into a
third-order tensor

$$A^{(k)} \in \mathbb{R}^{16 x 16 x n_k},$$

where each frontal slice is one image of the digit `k`.

The Higher-Order Singular Value Decomposition writes a tensor as

$$A = S x_1 U^(1) x_2 U^(2) x_3 U^(3),$$

where the matrices `U^(1)`, `U^(2)`, and `U^(3)` are orthogonal, and the core
tensor `S` has mutually orthogonal slices in each mode. This gives a collection of
orthogonal basis images for each digit class.

For an unknown digit image `Z`, the classifier projects `Z` onto the approximation
space associated with each digit and chooses the digit with the smallest residual:

$$R(k) = min || Z - sum_i z_i^(k) A_i^(k) ||_F.$$

Because the basis elements are orthogonal, the coefficients can be computed
explicitly using Frobenius inner products:

$$z_i^(k) = <Z, A_i^(k)>_F / ||A_i^(k)||_F^2.$$

With normalized images and orthonormalized bases, this becomes especially simple:

$$R(k)^2 = 1 - sum_i (z_i^(k))^2.$$

In the experiments, a rank `r = 22` approximation was used for the HOSVD-based
methods.

## Tangential Distance

Euclidean distance between images is often too rigid. A digit that is slightly
translated, rotated, scaled, or thickened may represent the same handwritten
symbol, while Euclidean distance may treat it as substantially different.

Tangential distance addresses this by viewing a digit image as a point in
`R^256`, and small transformations of that image as curves or surfaces through
that point. Instead of comparing two points directly, the method compares the
tangent spaces of their transformation manifolds.

For a pattern `p`, a small transformation can be approximated by the first-order
Taylor expansion

$$s(p, alpha) ~= p + T_p alpha,$$

where the columns of `T_p` are tangent vectors corresponding to allowed
transformations. For two patterns `p` and `e`, tangential distance is computed by
the least-squares problem

$$min || p + T_p alpha_p - e - T_e alpha_e ||_2.$$

Equivalently,

$$min || (p - e) - [-T_p  T_e] [alpha_p; alpha_e] ||_2.$$

The project solves this least-squares problem using QR decomposition and uses the
residual norm as the distance.

The implemented transformation directions are derived from image derivatives:

$$\begin{align}
\text{x-translation:} & \quad p_x \\
\text{y-translation:} & \quad p_y \\
\text{rotation:} & \quad y p_x - x p_y \\
\text{scaling:} & \quad x p_x + y p_y
\end{align}$$

Gaussian blurring is used as preprocessing so that the originally discrete
`16 x 16` images can be treated through a smoother differential model.

## Hybrid Methods

Two hybrid classifiers are discussed:

**Hybrid 1.0** first computes the HOSVD projection of an unknown digit onto each
digit class space, then compares the unknown digit with those projections using
tangential distance. This reduces the number of tangential-distance comparisons,
but the paper observes that the resulting accuracy is lower than the strongest
individual methods.

**Hybrid 2.0** uses the HOSVD confusion matrix to identify which digit classes are
most commonly confused. Tangential distance is then applied only to the most
relevant competing classes. This attempts to preserve much of the speed of HOSVD
while using tangential distance where the linear subspace method is most uncertain.

## Results

The experiments use handwritten digits from the USPS dataset. For HOSVD-based
classification, Gaussian blurring with `sigma = 0.9` and a `3 x 3` kernel is used
as preprocessing.

Tangential distance results reported in the paper:

| Test samples | Training samples | Success rate |
| ---: | ---: | ---: |
| 100 | 600 | 0.95 |
| 100 | 1000 | 0.93 |
| 200 | 600 | 0.93 |
| 1707 | 1707 | 0.951 |

Hybrid 2.0 result reported in the paper:

| Test samples | Training samples | Success rate |
| ---: | ---: | ---: |
| 1707 | 1707 | 0.92 |

The paper also reports that tangential distance achieved approximately `98%`
accuracy on an extended experiment using `2000` classified digits and `5291`
comparison digits.

## Repository Structure

```text
.
+-- Code/
|   +-- azip.mat       # digit image matrix, 256 x 1707
|   +-- dzip.mat       # labels for azip, 1 x 1707
|   +-- testzip.mat    # digit image matrix, 256 x 2007
|   +-- dtest.mat      # labels for testzip, 1 x 2007
|   +-- ima2.m         # MATLAB helper for visualizing a 16 x 16 digit vector
+-- Final Paper/
    +-- main.pdf       # full mathematical report
```

## Working With the Data

In MATLAB or Octave, the data can be loaded with:

```matlab
load Code/azip.mat
load Code/dzip.mat
```

Each column of `azip` is a digit image stored as a vector in `R^256`. The helper
function `ima2.m` reshapes and displays one such vector as a `16 x 16` image:

```matlab
addpath Code
ima2(azip(:, 1))
```

The code in this repository is intentionally minimal. The main contribution is
the mathematical formulation, comparison of methods, and interpretation of the
experimental behavior.

## Possible Directions for Further Research

- Choosing the HOSVD approximation rank adaptively for each digit class.
- Accelerating tangential distance while preserving its transformation invariance.
- Studying alternative tangent spaces with additional deformation directions.
- Comparing tensor subspace methods against modern neural baselines while keeping
  the mathematical model interpretable.
- Extending the approach to larger OCR datasets or other structured image
  classification problems.

## References

- L. L. Njotto and B. Savas, *Analyses and tests of handwritten digit recognition
  algorithms*, LiTH-MAT-EX-2003-01, Linkoping Institute of Technology, 2003.
- L. Elden, *Matrix Methods in Data Mining and Pattern Recognition*, SIAM, 2007.
- P. Y. Simard, Y. LeCun, J. S. Denker, and B. Victorri, *Transformation
  invariance in pattern recognition - tangent distance and tangent propagation*,
  Neural Networks: Tricks of the Trade, Springer, 1998.
