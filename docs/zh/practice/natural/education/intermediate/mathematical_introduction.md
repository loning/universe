# 数学入门 | Mathematical Introduction

[中文版](#中文版) | [English Version](#english-version)

<a name="中文版"></a>
# 中文版

## 引言

数学入门是量子经典二元论的基础工具，它提供了理解理论所需的数学语言和方法。

$$
\text{数学入门} = \{\text{线性代数},\;\text{微分方程},\;\text{概率论}\}
$$

## 线性代数

### 向量空间

1. **基本概念**
   - 向量
   - 基
   - 内积

$$
|\psi\rangle = \sum c_i|i\rangle \\
\langle\phi|\psi\rangle = \sum \phi_i^*\psi_i
$$

2. **线性算子**
   - 矩阵
   - 算符
   - 特征值

$$
\hat{A}|\psi\rangle = a|\psi\rangle \\
\hat{A} = \sum a_i|i\rangle\langle i|
$$

### 希尔伯特空间

1. **完备性**
   - 柯西序列
   - 收敛性
   - 完备空间

$$
\lim_{n\rightarrow\infty}\|x_n-x_m\| = 0 \\
\exists x: \lim_{n\rightarrow\infty}\|x_n-x\| = 0
$$

2. **正交性**
   - 正交基
   - 投影
   - 分解

$$
\langle i|j\rangle = \delta_{ij} \\
|\psi\rangle = \sum\langle i|\psi\rangle|i\rangle
$$

## 微分方程

### 常微分方程

1. **一阶方程**
   - 可分离变量
   - 线性方程
   - 伯努利方程

$$
\frac{dy}{dx} = f(x)g(y) \\
\frac{dy}{dx} + P(x)y = Q(x)
$$

2. **二阶方程**
   - 齐次方程
   - 非齐次方程
   - 特征方程

$$
\frac{d^2y}{dx^2} + P(x)\frac{dy}{dx} + Q(x)y = R(x)
$$

### 偏微分方程

1. **波动方程**
   - 一维波动
   - 二维波动
   - 三维波动

$$
\frac{\partial^2u}{\partial t^2} = c^2\nabla^2u
$$

2. **扩散方程**
   - 热传导
   - 扩散
   - 边界条件

$$
\frac{\partial u}{\partial t} = D\nabla^2u
$$

## 概率论

### 基本概念

1. **概率空间**
   - 样本空间
   - 事件
   - 概率测度

$$
P(A) \geq 0 \\
P(\Omega) = 1 \\
P(A\cup B) = P(A) + P(B) - P(A\cap B)
$$

2. **随机变量**
   - 离散变量
   - 连续变量
   - 期望值

$$
E[X] = \sum xp(x) \\
E[X] = \int xf(x)dx
$$

### 统计推断

1. **参数估计**
   - 点估计
   - 区间估计
   - 最大似然

$$
\hat{\theta} = \arg\max_{\theta} L(\theta|x)
$$

2. **假设检验**
   - 零假设
   - 备择假设
   - p值

$$
H_0: \theta = \theta_0 \\
H_1: \theta \neq \theta_0
$$

## 量子数学

### 量子态

1. **波函数**
   - 概率幅
   - 相位
   - 归一化

$$
\int|\psi(x)|^2dx = 1 \\
\psi(x) = A(x)e^{i\phi(x)}
$$

2. **算符**
   - 位置算符
   - 动量算符
   - 能量算符

$$
\hat{x} = x \\
\hat{p} = -i\hbar\frac{\partial}{\partial x} \\
\hat{H} = -\frac{\hbar^2}{2m}\nabla^2 + V(x)
$$

### 测量理论

1. **测量算符**
   - 投影算符
   - POVM
   - 测量结果

$$
\hat{M}_m = \sqrt{\hat{E}_m} \\
\sum\hat{E}_m = \hat{I}
$$

2. **测量概率**
   - 玻恩规则
   - 条件概率
   - 后测量态

$$
p(m) = \langle\psi|\hat{E}_m|\psi\rangle \\
|\psi_m\rangle = \frac{\hat{M}_m|\psi\rangle}{\sqrt{p(m)}}
$$

<a name="english-version"></a>
# English Version

## Introduction

Mathematical introduction provides the fundamental tools for quantum-classical dualism, offering the mathematical language and methods needed to understand the theory.

$$
\text{Mathematical Introduction} = \{\text{Linear Algebra},\;\text{Differential Equations},\;\text{Probability Theory}\}
$$

## Linear Algebra

### Vector Spaces

1. **Basic Concepts**
   - Vectors
   - Bases
   - Inner products

$$
|\psi\rangle = \sum c_i|i\rangle \\
\langle\phi|\psi\rangle = \sum \phi_i^*\psi_i
$$

2. **Linear Operators**
   - Matrices
   - Operators
   - Eigenvalues

$$
\hat{A}|\psi\rangle = a|\psi\rangle \\
\hat{A} = \sum a_i|i\rangle\langle i|
$$

### Hilbert Space

1. **Completeness**
   - Cauchy sequences
   - Convergence
   - Complete space

$$
\lim_{n\rightarrow\infty}\|x_n-x_m\| = 0 \\
\exists x: \lim_{n\rightarrow\infty}\|x_n-x\| = 0
$$

2. **Orthogonality**
   - Orthogonal basis
   - Projection
   - Decomposition

$$
\langle i|j\rangle = \delta_{ij} \\
|\psi\rangle = \sum\langle i|\psi\rangle|i\rangle
$$

## Differential Equations

### Ordinary Differential Equations

1. **First Order Equations**
   - Separable variables
   - Linear equations
   - Bernoulli equations

$$
\frac{dy}{dx} = f(x)g(y) \\
\frac{dy}{dx} + P(x)y = Q(x)
$$

2. **Second Order Equations**
   - Homogeneous equations
   - Non-homogeneous equations
   - Characteristic equation

$$
\frac{d^2y}{dx^2} + P(x)\frac{dy}{dx} + Q(x)y = R(x)
$$

### Partial Differential Equations

1. **Wave Equation**
   - One-dimensional waves
   - Two-dimensional waves
   - Three-dimensional waves

$$
\frac{\partial^2u}{\partial t^2} = c^2\nabla^2u
$$

2. **Diffusion Equation**
   - Heat conduction
   - Diffusion
   - Boundary conditions

$$
\frac{\partial u}{\partial t} = D\nabla^2u
$$

## Probability Theory

### Basic Concepts

1. **Probability Space**
   - Sample space
   - Events
   - Probability measure

$$
P(A) \geq 0 \\
P(\Omega) = 1 \\
P(A\cup B) = P(A) + P(B) - P(A\cap B)
$$

2. **Random Variables**
   - Discrete variables
   - Continuous variables
   - Expected value

$$
E[X] = \sum xp(x) \\
E[X] = \int xf(x)dx
$$

### Statistical Inference

1. **Parameter Estimation**
   - Point estimation
   - Interval estimation
   - Maximum likelihood

$$
\hat{\theta} = \arg\max_{\theta} L(\theta|x)
$$

2. **Hypothesis Testing**
   - Null hypothesis
   - Alternative hypothesis
   - p-value

$$
H_0: \theta = \theta_0 \\
H_1: \theta \neq \theta_0
$$

## Quantum Mathematics

### Quantum States

1. **Wave Function**
   - Probability amplitude
   - Phase
   - Normalization

$$
\int|\psi(x)|^2dx = 1 \\
\psi(x) = A(x)e^{i\phi(x)}
$$

2. **Operators**
   - Position operator
   - Momentum operator
   - Energy operator

$$
\hat{x} = x \\
\hat{p} = -i\hbar\frac{\partial}{\partial x} \\
\hat{H} = -\frac{\hbar^2}{2m}\nabla^2 + V(x)
$$

### Measurement Theory

1. **Measurement Operators**
   - Projection operators
   - POVM
   - Measurement outcomes

$$
\hat{M}_m = \sqrt{\hat{E}_m} \\
\sum\hat{E}_m = \hat{I}
$$

2. **Measurement Probability**
   - Born rule
   - Conditional probability
   - Post-measurement state

$$
p(m) = \langle\psi|\hat{E}_m|\psi\rangle \\
|\psi_m\rangle = \frac{\hat{M}_m|\psi\rangle}{\sqrt{p(m)}}
$$ 