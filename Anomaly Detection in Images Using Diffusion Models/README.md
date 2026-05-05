# Anomaly Detection in Images Using Diffusion Maps

This repository contains a mathematical and computational study of anomaly
detection in images using diffusion maps. The main focus is not software
engineering, but the use of nonlinear dimensionality reduction, kernel methods,
nearest-neighbor graph construction, Nyström extension, and multiscale image
analysis to identify pixels or regions that differ from the dominant structure
of an image.

The project was prepared as part of the course Matrix and Tensor Methods in Data
Analysis. The full write-up is available in
[`Final Paper/main.pdf`](Final%20Paper/main.pdf).

## Mathematical Motivation

An image can be viewed as a collection of local pixel neighborhoods, or patches.
Each patch is represented as a vector, and the goal is to detect patches whose
local structure differs from the normal image pattern.

The central assumption is that normal pixels form dense, geometrically coherent
regions in a suitable feature space, while anomalous pixels are more isolated.
Diffusion maps are used to reveal this geometry by embedding image patches into a
lower-dimensional space where diffusion distance captures both local similarity
and global data structure.

The main challenges are:

1. **Large image size**, since even moderate-resolution images contain many
   pixels.
2. **Noise**, which can produce false detections.
3. **Few anomaly examples**, since anomalies are usually rare or unavailable for
   training.
4. **Complex normal structure**, because the background may contain several
   clusters or repeated patterns.

The implemented method does not require a training phase or an assumed
probability distribution for the data.

## Diffusion Maps

Given image patches

$$S = \{x_1, \ldots, x_n\} \subset \mathbb{R}^d,$$

the method constructs an affinity matrix using a Gaussian-type kernel

$$K(i,j) = \exp\left(-\frac{||x_i - x_j||^2}{\sigma}\right).$$

After normalization, this matrix can be interpreted as a Markov transition
matrix on a graph whose vertices are image patches. Powers of this transition
matrix describe diffusion through the data set, and the leading eigenvectors give
a low-dimensional embedding that preserves diffusion distances.

In this project, the affinity matrix is made sparse by connecting each sample
only to its nearest neighbors. This reduces memory use and makes the spectral
decomposition more efficient.

## Nyström Extension

Computing a full diffusion map for all pixels can be expensive. To reduce the
cost, the method computes the diffusion map on a sampled subset of patches and
then extends the embedding to the remaining patches using a Nyström extension.

This preserves the geometry of the sampled data while avoiding the full
all-pairs kernel computation.

The main files involved are:

- `build_affinity_matrix.m`
- `diffusion_map.m`
- `nystrom_extension.m`

## Gaussian Pyramid

The method uses a Gaussian pyramid to perform anomaly detection at multiple
image resolutions. Detection begins at the coarsest level, where the image is
small and a larger fraction of pixels can be sampled. Suspicious pixels are then
propagated to finer levels and supplemented with random samples.

This multiscale strategy reduces the risk that random sampling misses the
anomaly entirely. It also improves efficiency, because expensive computations are
focused on the most relevant regions as the algorithm moves back toward full
resolution.

The pyramid is constructed in `gaussian_pyramid.m`, and the full multiscale
workflow is implemented in `multiscale_anomaly_detector.m`.

## Anomaly Score

After computing the diffusion-map embedding, each pixel receives an anomaly
score. The score compares the pixel to nearby pixels in image coordinates, but
uses distances in the diffusion-map embedding.

Pixels that have few close neighbors in diffusion space receive higher anomaly
scores. An inner mask is used so that a pixel is not compared only with its
immediate neighbors, which helps prevent spatially extended anomalies from being
hidden by similar neighboring anomalous pixels.

The anomaly score is implemented in `anomaly_score.m`.

## Repository Structure

```text
.
+-- Code/
|   +-- main.m                         # example script for running detection
|   +-- multiscale_anomaly_detector.m  # full multiscale detection pipeline
|   +-- gaussian_pyramid.m             # Gaussian pyramid construction
|   +-- extract_patches.m              # image patch extraction
|   +-- build_affinity_matrix.m        # sparse nearest-neighbor affinity matrix
|   +-- diffusion_map.m                # diffusion-map embedding
|   +-- nystrom_extension.m            # out-of-sample extension
|   +-- estimate_sigma.m               # scale estimation for anomaly scoring
|   +-- anomaly_score.m                # local diffusion-space anomaly score
|   +-- results/                       # saved experiment outputs
+-- Final Paper/
|   +-- main.pdf                       # full mathematical report
+-- LaTex/
|   +-- main.tex                       # LaTeX source
|   +-- preamble.tex                   # LaTeX preamble
|   +-- sections/                      # report sections
|   +-- slike/                         # figures used in the report
+-- README.md
```

## Working With the Code

The code is written in MATLAB. To run the example script, open MATLAB in this
project folder or add the code directory to the MATLAB path:

```matlab
addpath("Code")
cd("Code")
main
```

The script `main.m` loads an example image, sets the pyramid and patch
parameters, runs the multiscale detector, and displays:

- the anomaly score map,
- the top 5% highest-scoring pixels overlaid on the input image,
- summary statistics for the anomaly scores.

A typical call to the detector has the form:

```matlab
I = im2double(imread("low_res_image.png"));

L = 2;
patch_sizes = [7, 5, 3];
window_sizes = [20, 13, 7];
mask_half = 7;
sample_percents = [0.15, 0.3, 0.5];

score_map = multiscale_anomaly_detector( ...
    I, L, patch_sizes, window_sizes, mask_half, sample_percents);
```

The parameters control the number of pyramid levels, patch sizes at each level,
the spatial window used for anomaly scoring, the inner mask size, and the
fraction of pixels sampled at each resolution.

## Implemented Functions

| Function | Purpose |
| --- | --- |
| `main.m` | Runs an example anomaly detection experiment |
| `multiscale_anomaly_detector.m` | Coordinates pyramid construction, sampling, embedding, and scoring |
| `gaussian_pyramid.m` | Builds lower-resolution versions of the image |
| `extract_patches.m` | Converts local image neighborhoods into feature vectors |
| `build_affinity_matrix.m` | Builds a sparse affinity matrix using nearest neighbors |
| `diffusion_map.m` | Computes the diffusion-map embedding |
| `nystrom_extension.m` | Extends the sampled embedding to all image patches |
| `estimate_sigma.m` | Estimates a global scale parameter from random pairs |
| `anomaly_score.m` | Computes local anomaly scores from diffusion coordinates |

## Possible Directions for Further Research

- Automatic parameter selection for patch size, mask size, and detection
  thresholds.
- Adaptive thresholds depending on image texture and expected anomaly size.
- More efficient nearest-neighbor search for larger images.
- Comparison with other unsupervised anomaly detection methods.
- Extension from still images to video sequences.
- Better evaluation on labeled anomaly detection data sets.

## References

- G. Mishne and I. Cohen, *Multiscale Anomaly Detection Using Diffusion Maps*,
  IEEE Journal of Selected Topics in Signal Processing, vol. 7, no. 1,
  pp. 111--125, 2013.
- M. Salhov, A. Bermanis, G. Wolf, and A. Averbuch,
  *Approximately-isometric diffusion maps*, Applied and Computational Harmonic
  Analysis, vol. 38, no. 3, pp. 399--419, 2015.

