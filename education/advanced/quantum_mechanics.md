# 量子力学 | Quantum Mechanics

[中文版](#中文版) | [English Version](#english-version)

<a name="中文版"></a>
# 中文版

## 引言

量子力学是量子经典二元论的基础理论，它探索了微观世界的量子经典本质和机制。

$$
\text{量子力学} = \{\text{量子态},\;\text{量子算符},\;\text{量子测量}\}
$$

## 量子态

### 波函数

1. **量子态矢量**
   - 希尔伯特空间
   - 量子叠加
   - 量子纠缠

$$
|\psi\rangle = \sum_n c_n|n\rangle
$$

2. **量子概率**
   - 波函数模方
   - 概率密度
   - 概率流

$$
P(x) = |\psi(x)|^2 \\
j(x) = \frac{\hbar}{2mi}(\psi^*\nabla\psi - \psi\nabla\psi^*)
$$

### 量子演化

1. **薛定谔方程**
   - 时间演化
   - 能量本征值
   - 定态波函数

$$
i\hbar\frac{\partial}{\partial t}|\psi\rangle = \hat{H}|\psi\rangle
$$

2. **量子路径**
   - 费曼路径积分
   - 量子作用量
   - 量子传播子

$$
K(x_f,t_f;x_i,t_i) = \int\mathcal{D}xe^{iS/\hbar}
$$

## 量子算符

### 基本算符

1. **位置算符**
   - 坐标表示
   - 动量表示
   - 表象变换

$$
\hat{x}|\psi\rangle = x|\psi\rangle \\
\hat{p}|\psi\rangle = -i\hbar\frac{\partial}{\partial x}|\psi\rangle
$$

2. **能量算符**
   - 哈密顿量
   - 能量本征值
   - 能量本征态

$$
\hat{H}|\psi_n\rangle = E_n|\psi_n\rangle
$$

### 对易关系

1. **基本对易子**
   - 位置动量
   - 角动量
   - 升降算符

$$
[\hat{x},\hat{p}] = i\hbar \\
[\hat{L}_i,\hat{L}_j] = i\hbar\epsilon_{ijk}\hat{L}_k
$$

2. **量子代数**
   - 李代数
   - 泊松括号
   - 量子化规则

$$
\{A,B\} = \frac{1}{i\hbar}[\hat{A},\hat{B}]
$$

## 量子测量

### 测量理论

1. **投影测量**
   - 测量算符
   - 测量结果
   - 测量概率

$$
P(a) = \langle\psi|\hat{P}_a|\psi\rangle
$$

2. **广义测量**
   - POVM
   - 测量算符
   - 测量后态

$$
\rho' = \sum_i M_i\rho M_i^\dagger
$$

### 测量效应

1. **波函数坍缩**
   - 测量坍缩
   - 量子纠缠
   - 量子退相干

$$
|\psi\rangle \rightarrow |\psi_a\rangle
$$

2. **测量干扰**
   - 海森堡不确定关系
   - 测量精度
   - 测量极限

$$
\Delta x\Delta p \geq \frac{\hbar}{2}
$$

## 统一理论

### 量子经典统一

1. **对应原理**
   - 玻尔对应
   - 经典极限
   - 量子化规则

$$
\lim_{\hbar\rightarrow 0} \text{量子力学} = \text{经典力学}
$$

2. **测量统一**
   - 量子测量
   - 经典观察
   - 统一理论

$$
\langle A \rangle = \text{Tr}(\rho A)
$$

### 应用统一

1. **动力学统一**
   - 量子演化
   - 经典运动
   - 统一方程

$$
\frac{d}{dt}\langle A \rangle = \frac{1}{i\hbar}\langle[A,H]\rangle
$$

2. **守恒统一**
   - 量子守恒
   - 经典守恒
   - 统一定律

$$
\frac{d}{dt}\langle H \rangle = 0
$$

<a name="english-version"></a>
# English Version

## Introduction

Quantum mechanics is the fundamental theory of quantum-classical dualism, exploring the quantum-classical nature and mechanism of the microscopic world.

$$
\text{Quantum Mechanics} = \{\text{Quantum States},\;\text{Quantum Operators},\;\text{Quantum Measurement}\}
$$

## Quantum States

### Wave Functions

1. **Quantum State Vectors**
   - Hilbert space
   - Quantum superposition
   - Quantum entanglement

$$
|\psi\rangle = \sum_n c_n|n\rangle
$$

2. **Quantum Probability**
   - Wave function modulus
   - Probability density
   - Probability current

$$
P(x) = |\psi(x)|^2 \\
j(x) = \frac{\hbar}{2mi}(\psi^*\nabla\psi - \psi\nabla\psi^*)
$$

### Quantum Evolution

1. **Schrödinger Equation**
   - Time evolution
   - Energy eigenvalues
   - Stationary states

$$
i\hbar\frac{\partial}{\partial t}|\psi\rangle = \hat{H}|\psi\rangle
$$

2. **Quantum Paths**
   - Feynman path integral
   - Quantum action
   - Quantum propagator

$$
K(x_f,t_f;x_i,t_i) = \int\mathcal{D}xe^{iS/\hbar}
$$

## Quantum Operators

### Basic Operators

1. **Position Operator**
   - Coordinate representation
   - Momentum representation
   - Representation transformation

$$
\hat{x}|\psi\rangle = x|\psi\rangle \\
\hat{p}|\psi\rangle = -i\hbar\frac{\partial}{\partial x}|\psi\rangle
$$

2. **Energy Operator**
   - Hamiltonian
   - Energy eigenvalues
   - Energy eigenstates

$$
\hat{H}|\psi_n\rangle = E_n|\psi_n\rangle
$$

### Commutation Relations

1. **Basic Commutators**
   - Position-momentum
   - Angular momentum
   - Ladder operators

$$
[\hat{x},\hat{p}] = i\hbar \\
[\hat{L}_i,\hat{L}_j] = i\hbar\epsilon_{ijk}\hat{L}_k
$$

2. **Quantum Algebra**
   - Lie algebra
   - Poisson brackets
   - Quantization rules

$$
\{A,B\} = \frac{1}{i\hbar}[\hat{A},\hat{B}]
$$

## Quantum Measurement

### Measurement Theory

1. **Projective Measurement**
   - Measurement operators
   - Measurement outcomes
   - Measurement probability

$$
P(a) = \langle\psi|\hat{P}_a|\psi\rangle
$$

2. **Generalized Measurement**
   - POVM
   - Measurement operators
   - Post-measurement state

$$
\rho' = \sum_i M_i\rho M_i^\dagger
$$

### Measurement Effects

1. **Wave Function Collapse**
   - Measurement collapse
   - Quantum entanglement
   - Quantum decoherence

$$
|\psi\rangle \rightarrow |\psi_a\rangle
$$

2. **Measurement Disturbance**
   - Heisenberg uncertainty
   - Measurement precision
   - Measurement limits

$$
\Delta x\Delta p \geq \frac{\hbar}{2}
$$

## Unified Theory

### Quantum-Classical Unification

1. **Correspondence Principle**
   - Bohr correspondence
   - Classical limit
   - Quantization rules

$$
\lim_{\hbar\rightarrow 0} \text{Quantum Mechanics} = \text{Classical Mechanics}
$$

2. **Measurement Unification**
   - Quantum measurement
   - Classical observation
   - Unified theory

$$
\langle A \rangle = \text{Tr}(\rho A)
$$

### Application Unification

1. **Dynamics Unification**
   - Quantum evolution
   - Classical motion
   - Unified equation

$$
\frac{d}{dt}\langle A \rangle = \frac{1}{i\hbar}\langle[A,H]\rangle
$$

2. **Conservation Unification**
   - Quantum conservation
   - Classical conservation
   - Unified law

$$
\frac{d}{dt}\langle H \rangle = 0
$$ 