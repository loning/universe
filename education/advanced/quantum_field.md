# 量子场论 | Quantum Field Theory

[中文版](#中文版) | [English Version](#english-version)

<a name="中文版"></a>
# 中文版

## 引言

量子场论是量子经典二元论的重要理论，它探索了场的量子经典本质和机制。

$$
\text{量子场论} = \{\text{量子场},\;\text{相互作用},\;\text{对称性}\}
$$

## 量子场

### 标量场

1. **克莱因-戈登场**
   - 场算符
   - 产生湮灭算符
   - 真空态

$$
\hat{\phi}(x) = \int\frac{d^3p}{(2\pi)^3}\frac{1}{\sqrt{2E_p}}(\hat{a}_pe^{-ip\cdot x} + \hat{a}_p^\dagger e^{ip\cdot x})
$$

2. **希格斯场**
   - 自发对称性破缺
   - 质量产生
   - 规范玻色子

$$
\mathcal{L} = |D_\mu\phi|^2 - V(\phi)
$$

### 旋量场

1. **狄拉克场**
   - 场算符
   - 费米子
   - 反费米子

$$
\hat{\psi}(x) = \int\frac{d^3p}{(2\pi)^3}\frac{1}{\sqrt{2E_p}}\sum_s(\hat{b}_{p,s}u_s(p)e^{-ip\cdot x} + \hat{d}_{p,s}^\dagger v_s(p)e^{ip\cdot x})
$$

2. **外尔场**
   - 手征性
   - 中微子
   - 外尔费米子

$$
\mathcal{L} = i\bar{\psi}\gamma^\mu\partial_\mu\psi
$$

## 相互作用

### 规范场

1. **电磁场**
   - 光子
   - 规范不变性
   - 电荷守恒

$$
\mathcal{L} = -\frac{1}{4}F_{\mu\nu}F^{\mu\nu} + \bar{\psi}(i\gamma^\mu D_\mu - m)\psi
$$

2. **弱相互作用**
   - W玻色子
   - Z玻色子
   - 弱中性流

$$
\mathcal{L} = -\frac{1}{4}W_{\mu\nu}^a W^{a\mu\nu} + \frac{g}{2}\bar{\psi}\gamma^\mu\tau^a\psi W_\mu^a
$$

### 强相互作用

1. **量子色动力学**
   - 胶子
   - 夸克
   - 色禁闭

$$
\mathcal{L} = -\frac{1}{4}G_{\mu\nu}^a G^{a\mu\nu} + \sum_f \bar{q}_f(i\gamma^\mu D_\mu - m_f)q_f
$$

2. **渐近自由**
   - β函数
   - 耦合常数
   - 重整化群

$$
\beta(g) = -\frac{g^3}{16\pi^2}\left(11 - \frac{2}{3}n_f\right)
$$

## 对称性

### 全局对称性

1. **空间对称性**
   - 平移
   - 旋转
   - 洛伦兹变换

$$
x'^\mu = \Lambda^\mu_\nu x^\nu
$$

2. **内部对称性**
   - U(1)
   - SU(2)
   - SU(3)

$$
U = e^{i\theta_a T_a}
$$

### 局域对称性

1. **规范对称性**
   - 规范变换
   - 规范场
   - 规范玻色子

$$
A_\mu \rightarrow A_\mu + \partial_\mu\alpha
$$

2. **超对称性**
   - 玻色子
   - 费米子
   - 超多重态

$$
Q|\text{玻色子}\rangle = |\text{费米子}\rangle
$$

## 统一理论

### 量子经典统一

1. **场论统一**
   - 量子场
   - 经典场
   - 统一方程

$$
\lim_{\hbar\rightarrow 0} \text{量子场论} = \text{经典场论}
$$

2. **相互作用统一**
   - 量子相互作用
   - 经典相互作用
   - 统一理论

$$
\mathcal{L} = \mathcal{L}_{\text{自由}} + \mathcal{L}_{\text{相互作用}}
$$

### 应用统一

1. **对称性统一**
   - 量子对称性
   - 经典对称性
   - 统一群

$$
G = G_{\text{量子}} \otimes G_{\text{经典}}
$$

2. **守恒统一**
   - 量子守恒
   - 经典守恒
   - 统一定律

$$
\partial_\mu J^\mu = 0
$$

<a name="english-version"></a>
# English Version

## Introduction

Quantum field theory is an important theory of quantum-classical dualism, exploring the quantum-classical nature and mechanism of fields.

$$
\text{Quantum Field Theory} = \{\text{Quantum Fields},\;\text{Interactions},\;\text{Symmetries}\}
$$

## Quantum Fields

### Scalar Fields

1. **Klein-Gordon Field**
   - Field operators
   - Creation/annihilation operators
   - Vacuum state

$$
\hat{\phi}(x) = \int\frac{d^3p}{(2\pi)^3}\frac{1}{\sqrt{2E_p}}(\hat{a}_pe^{-ip\cdot x} + \hat{a}_p^\dagger e^{ip\cdot x})
$$

2. **Higgs Field**
   - Spontaneous symmetry breaking
   - Mass generation
   - Gauge bosons

$$
\mathcal{L} = |D_\mu\phi|^2 - V(\phi)
$$

### Spinor Fields

1. **Dirac Field**
   - Field operators
   - Fermions
   - Antifermions

$$
\hat{\psi}(x) = \int\frac{d^3p}{(2\pi)^3}\frac{1}{\sqrt{2E_p}}\sum_s(\hat{b}_{p,s}u_s(p)e^{-ip\cdot x} + \hat{d}_{p,s}^\dagger v_s(p)e^{ip\cdot x})
$$

2. **Weyl Field**
   - Chirality
   - Neutrinos
   - Weyl fermions

$$
\mathcal{L} = i\bar{\psi}\gamma^\mu\partial_\mu\psi
$$

## Interactions

### Gauge Fields

1. **Electromagnetic Field**
   - Photons
   - Gauge invariance
   - Charge conservation

$$
\mathcal{L} = -\frac{1}{4}F_{\mu\nu}F^{\mu\nu} + \bar{\psi}(i\gamma^\mu D_\mu - m)\psi
$$

2. **Weak Interaction**
   - W bosons
   - Z bosons
   - Weak neutral current

$$
\mathcal{L} = -\frac{1}{4}W_{\mu\nu}^a W^{a\mu\nu} + \frac{g}{2}\bar{\psi}\gamma^\mu\tau^a\psi W_\mu^a
$$

### Strong Interaction

1. **Quantum Chromodynamics**
   - Gluons
   - Quarks
   - Color confinement

$$
\mathcal{L} = -\frac{1}{4}G_{\mu\nu}^a G^{a\mu\nu} + \sum_f \bar{q}_f(i\gamma^\mu D_\mu - m_f)q_f
$$

2. **Asymptotic Freedom**
   - Beta function
   - Coupling constant
   - Renormalization group

$$
\beta(g) = -\frac{g^3}{16\pi^2}\left(11 - \frac{2}{3}n_f\right)
$$

## Symmetries

### Global Symmetries

1. **Space-Time Symmetries**
   - Translation
   - Rotation
   - Lorentz transformation

$$
x'^\mu = \Lambda^\mu_\nu x^\nu
$$

2. **Internal Symmetries**
   - U(1)
   - SU(2)
   - SU(3)

$$
U = e^{i\theta_a T_a}
$$

### Local Symmetries

1. **Gauge Symmetries**
   - Gauge transformation
   - Gauge fields
   - Gauge bosons

$$
A_\mu \rightarrow A_\mu + \partial_\mu\alpha
$$

2. **Supersymmetry**
   - Bosons
   - Fermions
   - Supermultiplets

$$
Q|\text{boson}\rangle = |\text{fermion}\rangle
$$

## Unified Theory

### Quantum-Classical Unification

1. **Field Theory Unification**
   - Quantum fields
   - Classical fields
   - Unified equation

$$
\lim_{\hbar\rightarrow 0} \text{Quantum Field Theory} = \text{Classical Field Theory}
$$

2. **Interaction Unification**
   - Quantum interactions
   - Classical interactions
   - Unified theory

$$
\mathcal{L} = \mathcal{L}_{\text{free}} + \mathcal{L}_{\text{interaction}}
$$

### Application Unification

1. **Symmetry Unification**
   - Quantum symmetries
   - Classical symmetries
   - Unified group

$$
G = G_{\text{quantum}} \otimes G_{\text{classical}}
$$

2. **Conservation Unification**
   - Quantum conservation
   - Classical conservation
   - Unified law

$$
\partial_\mu J^\mu = 0
$$ 