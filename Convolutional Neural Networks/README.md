# Convolutional Neural Networks

This repository contains a mathematical and computational study of convolutional
neural networks (CNNs). The main focus is not software engineering, but the
mathematical ideas behind deep learning models for structured data: empirical
risk minimization, gradient-based optimization, backpropagation, convolutional
layers, activation functions, pooling, and regularization.

The project was prepared as part of the course Matrix and Tensor Methods in Data
Analysis. The full write-up is available in
[`Final Paper/main.pdf`](Final%20Paper/main.pdf).

## Mathematical Motivation

Classical fully connected neural networks treat input data as vectors. This is
often inefficient for data with spatial or sequential structure, such as images
or text. A color image, for example, is naturally represented as a third-order
tensor, while a text document can be represented as a sequence of word indices
or embedded vectors.

Convolutional neural networks exploit this structure through two key principles:

1. **Local connectivity**, where each filter examines only a small neighborhood
   of the input rather than the entire input at once.
2. **Weight sharing**, where the same filter is applied repeatedly across
   different positions.

These ideas reduce the number of trainable parameters and allow the model to
learn local patterns such as edges, shapes, textures, or n-gram phrases.

## Empirical Risk and Loss Functions

The project begins with the general supervised learning setting. Given training
data `x_i` and labels `y_i`, the goal is to choose parameters `theta` that
minimize an empirical risk of the form

$$
\hat{J}(\theta)
= \frac{1}{m}\sum_{i=1}^{m} L(f_\theta(x_i), y_i),
$$

where `L` is a loss function and `f_theta` is the neural network model.

The report discusses several loss functions, including:

- the 0-1 loss for classification,
- categorical cross-entropy,
- softmax log loss,
- squared and absolute losses,
- losses derived from p-norms.

This provides the optimization framework in which neural networks are trained.

## Gradient Descent and Backpropagation

Training a neural network requires computing derivatives of the loss with
respect to many parameters. The report derives gradient descent from a first
order Taylor approximation and discusses stochastic gradient descent as a more
efficient approximation for large training sets.

Momentum is introduced as a modification of stochastic gradient descent:

$$
v \leftarrow \alpha v - \eta \nabla_\theta L,
\qquad
\theta \leftarrow \theta + v.
$$

The report also explains backpropagation as a recursive application of the chain
rule through the layers of a network. This avoids explicitly forming large
Jacobian matrices and reduces gradient computation to a sequence of local
derivative calculations.

## Convolutional Layers

A convolutional layer applies small filters, or kernels, to local regions of the
input. For images, a kernel may detect edges, colors, shapes, or higher-level
visual patterns. For text, a one-dimensional convolution can detect local word
patterns such as 3-grams, 5-grams, or 7-grams.

In the image setting, a convolutional kernel acts on local submatrices or
subtensors. If the input is a tensor of size

$$
H \times W \times D,
$$

then a kernel of size

$$
H' \times W' \times D
$$

is moved across the spatial dimensions of the input, producing a feature map.

The report also describes activation functions, especially ReLU,

$$
\text{ReLU}(x) = \max(0, x)
$$

and explains why ReLU is often preferred over sigmoid activations in deep
networks because it helps mitigate the vanishing-gradient problem.

## Pooling Layers

Pooling layers reduce the spatial or temporal dimension of intermediate feature
maps. The report focuses on max pooling, where each pooling window is replaced
by its maximum value.

Pooling reduces computational cost, decreases the number of parameters in later
layers, and makes the model less sensitive to small translations or local
position changes.

## Experimental Task: Fake vs. Real News

The code applies one-dimensional CNNs to binary text classification. The task is
to classify news articles as either:

- `FAKE`, encoded as `0`,
- `REAL`, encoded as `1`.

The data set is stored in `Code/fake_or_real_news.csv`. The notebook combines
the article title and text, cleans the text, tokenizes words into integer
indices, pads each sequence to a fixed length, and trains several CNN models.

The notebook is available at:

```text
Code/FakeOrReal.ipynb
```

## Implemented Models

Three CNN architectures are explored.

**Model 1: basic CNN architecture.**

The first model uses:

- an embedding layer with dimension `100`,
- `SpatialDropout1D`,
- one `Conv1D` layer with 128 filters and kernel size 5,
- `GlobalMaxPooling1D`,
- a dense hidden layer,
- dropout,
- a sigmoid output neuron.

This model serves as the baseline and achieves a reported test accuracy of
approximately `0.926`.

**Model 2: extended CNN architecture.**

The second model uses parallel convolutional branches with kernel sizes 3, 5,
and 7. It also introduces batch normalization, additional dense layers,
dropout, `EarlyStopping`, and `ReduceLROnPlateau`.

This architecture is designed to capture phrases of several lengths while
stabilizing training and reducing overfitting.

**Model 3: regularized CNN architecture.**

The third model keeps the parallel convolutional paths but uses stronger
regularization:

- higher dropout,
- L2 regularization,
- batch normalization,
- fewer filters and hidden units,
- early stopping with a shorter patience.

This model achieves the strongest reported behavior, with test accuracy around
`0.94`.

## Repository Structure

```text
.
+-- Code/
|   +-- FakeOrReal.ipynb        # Jupyter notebook for fake/real news classification
|   +-- fake_or_real_news.csv   # news article data set
+-- Final Paper/
|   +-- main.pdf                # full mathematical report
+-- LaTeX/
|   +-- main.tex                # LaTeX source
|   +-- preamble.tex            # LaTeX preamble
|   +-- sections/               # report sections
|   +-- slike/                  # figures used in the report
+-- README.md
```

## Working With the Code

The code is written in Python and organized as a Jupyter notebook. The main
libraries used are:

- `pandas`,
- `numpy`,
- `scikit-learn`,
- `matplotlib`,
- `tensorflow` / `keras`.

To run the notebook, open the project folder and start Jupyter:

```bash
cd "Convolutional Neural Networks/Code"
jupyter notebook FakeOrReal.ipynb
```

The notebook performs the following steps:

1. Loads `fake_or_real_news.csv`.
2. Combines article titles and text.
3. Cleans and normalizes the text.
4. Splits the data into training, validation, and test sets.
5. Tokenizes text and pads sequences to a fixed length.
6. Trains several CNN models.
7. Evaluates test accuracy and displays confusion matrices.
8. Tests the models on several hand-written example articles.

The notebook can be rerun from top to bottom, but training the models may take
some time depending on the available hardware.

## Report Source

The LaTeX source for the report is included in `LaTeX/`. To rebuild the PDF from
the source, run:

```bash
cd "Convolutional Neural Networks/LaTeX"
pdflatex main.tex
pdflatex main.tex
```

The second compilation pass resolves references and the table of contents.

## Possible Directions for Further Research

- Compare CNN-based text classification with transformer-based models such as
  BERT.
- Use pretrained word embeddings instead of learning embeddings from scratch.
- Study how different kernel sizes affect detection of short and long phrases.
- Add systematic hyperparameter search for dropout, L2 regularization, and
  learning-rate schedules.
- Evaluate the models on larger or more recent misinformation data sets.
- Add interpretability methods to identify which phrases most influence the
  final classification.

## References

- C. F. Higham and D. J. Higham, *Deep Learning: An Introduction for Applied
  Mathematicians*, SIAM Review, vol. 61, no. 4, pp. 860--891, 2019.
- A. Vedaldi, K. Lenc, and A. Gupta, *Convolutional Neural Networks for MATLAB*.
- D. McCarter, *Mathematical Analysis of Convolutional Neural Networks*.
- I. Goodfellow, Y. Bengio, and A. Courville, *Deep Learning*, MIT Press, 2016.
