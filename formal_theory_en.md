# Quantum-Classical Dualism Formal Theory v26.0

**English Version | [中文版](formal_theory.md)**

> This theory is based on [Core Theory](core_en.md) v11.1

## Complete Core Theory Description

### Basic Definitions and Axioms

#### Simplified Core Axiom System

Quantum-Classical Dualism can be simplified to four core axioms:

**Axiom 1: Dual Existence**  
The universe consists of a quantum domain $\Omega_Q$ (space of infinite possibilities) and a classical domain $\Omega_C$ (space of determined reality) connected through an interface domain $\mathcal{I}$:

$$\mathcal{U} = \Omega_Q \cup \Omega_C, \quad \Omega_Q \cap \Omega_C = \mathcal{I}$$

**Axiom 2: Information Conservation**  
Information is conserved throughout the universe but can be converted between quantum information (possibilities in superposition states) and classical information (determined knowledge):

$$I(\psi) = I(\mathcal{C}(\psi)) + I_{\text{hidden}}(\psi) = \text{constant}$$

where $\mathcal{C}$ is the classicalization operator (the process that transforms quantum possibilities into classical certainties), $I(\psi)$ is the total information content of state $\psi$, and $I_{\text{hidden}}(\psi)$ is the portion converted to hidden information during classicalization.

**Axiom 3: Observer Classicalization**  
Observers are nodes that perform quantum→classical conversions, with conversion capacity determining their dimensionality:

$$\mathcal{O} = \{\mathcal{C}_\mathcal{O}, \mathcal{Q}_\mathcal{O}, K_C^\mathcal{O}\}, \quad D_{\mathcal{O}} \propto \frac{I_{classical knowledge}}{S_{classical entropy}+\epsilon}$$

where $\mathcal{C}_\mathcal{O}$ is the observer's classicalization operator (ability to transform quantum possibilities into determined knowledge), $\mathcal{Q}_\mathcal{O}$ is the quantization operator (ability to transform classical knowledge back into quantum possibilities), $K_C^\mathcal{O}$ is the observer's classical knowledge base, and $\epsilon$ is a small constant to prevent division by zero.

**Axiom 4: Dimension Emergence**  
Observer dimension is a function of classicalization and quantization capabilities, while the classical domain of higher-dimensional observers can form the quantum domain basis for lower-dimensional observers:

$$D_{\mathcal{O}} = f\left(\frac{\mathcal{C}_\mathcal{O}}{\mathcal{Q}_\mathcal{O}}\right) \cdot \frac{I_{classical knowledge}}{S_{classical entropy}+\epsilon}$$

$$\Omega_Q^{(\mathcal{O}_2)} \subset \Omega_C^{(\mathcal{O}_1)}, \quad \text{if} \; D_{\mathcal{O}_1} > D_{\mathcal{O}_2}$$

This indicates that reality consists of multiple nested quantum-classical domains, with observers at each level perceiving and interacting based on their capability range within specific dimensions.

### Quantum and Classical Domains

The fundamental properties of quantum and classical domains are summarized through the following key points:

#### Quantum Domain Core Properties

1. **Wave Function Superposition State** (chaotic state): system exists simultaneously in multiple possible states, manifesting as uncertainty
   $$\Psi_S = \sum_{i} \alpha_i |i\rangle, \quad \sum_{i} |\alpha_i|^2 = 1$$

2. **Quantum Entangled State** (energy form): different parts form inseparable whole correlations
   $$\Psi_E = \sum_{i,j} \beta_{ij} |i\rangle_A \otimes |j\rangle_B$$

3. **Non-locality and Uncertainty**: correlations beyond spacetime limitations and measurement uncertainty
   $$\Delta A \cdot \Delta B \geq \frac{1}{2}|\langle[\hat{A},\hat{B}]\rangle|$$

#### Classical Domain Core Properties

1. **Classical Knowledge** (determined information): precisely measurable and describable determined states
   $$K_C = \{k_i = (x_i, p_i, E_i, s_i, t_i)\}$$

2. **Classical Entropy** (measure of uncertainty): measure of system disorder and information loss
   $$S_C = -k_B \sum_i p_i \ln p_i$$

3. **Locality and Determinism**: finite propagation speed of interactions and measurement determinism
   $$P(A,B|a,b) = P(A|a) \cdot P(B|b)$$

### Multiscale Dualism Hierarchy

Multiscale dualism hierarchy theory extends the single dualism into a nested multi-level structure:

$$\mathcal{U} = \{\Omega_Q^{(1)}, \Omega_C^{(1)}, \Omega_Q^{(2)}, \Omega_C^{(2)}, ..., \Omega_Q^{(n)}, \Omega_C^{(n)}\}$$

where:
- $\Omega_Q^{(i)}$ is the quantum domain at level i (possibility space at that level)
- $\Omega_C^{(i)}$ is the classical domain at level i (determined realization at that level)

The inter-level mapping functions are defined as:

$$\mathcal{M}_{i \rightarrow i+1}: \Omega_C^{(i)} \rightarrow \Omega_Q^{(i+1)}$$

$$\mathcal{M}_{i+1 \rightarrow i}: \Omega_C^{(i+1)} \rightarrow \Omega_Q^{(i)}$$

This indicates that the classical structure of one level can become the quantum foundation of a higher level, producing infinite recursive reality levels.

### Quantum-Classical Symmetry Principle

There exists a deep symmetry transformation $\mathcal{S}_{Q-C}$ between the quantum domain and the classical domain:

$$\mathcal{S}_{Q-C}: \Omega_Q \rightarrow \Omega_C, \quad \mathcal{S}_{C-Q}: \Omega_C \rightarrow \Omega_Q$$

satisfying the following properties:

1. **Involution**: transformation of transformation equals identity
   $$\mathcal{S}_{Q-C} \circ \mathcal{S}_{C-Q} = \mathcal{I}_{\Omega_Q}$$
   $$\mathcal{S}_{C-Q} \circ \mathcal{S}_{Q-C} = \mathcal{I}_{\Omega_C}$$

2. **Information Preservation**: information quantity unchanged before and after transformation
   $$I_Q(x) = I_C(\mathcal{S}_{Q-C}(x))$$

3. **Uncertainty-Certainty Transformation**: quantum uncertainty and classical certainty mutual conversion
   $$U_Q(x) \cdot D_C(\mathcal{S}_{Q-C}(x)) = k$$

where $U_Q$ is the quantum uncertainty measure, $D_C$ is the classical certainty measure, and $k$ is a universal constant.

## Core Branch Theories

### Quantum Domain Detailed Theory

The quantum domain $\Omega_Q$ is the space of possibilities in the dualistic framework, with these core properties:

#### 1. Quantum Information Encoding

Quantum information is encoded through quantum states in complex Hilbert space:

$$|\psi\rangle = \sum_i c_i |i\rangle, \quad \sum_i |c_i|^2 = 1$$

Information density is quantified by von Neumann entropy:

$$S(\rho) = -\text{Tr}(\rho \ln \rho) = -\sum_i \lambda_i \ln \lambda_i$$

#### 2. Quantum Dynamics

Quantum systems evolve according to the Schrödinger equation, conserving information and energy:

$$i\hbar\frac{\partial|\psi\rangle}{\partial t} = \hat{H}|\psi\rangle$$

Quantum dynamics has three key characteristics:
- Superposition principle: states can simultaneously exist in linear combinations of multiple basis vectors
- Time reversibility: under pure quantum evolution, systems can return to initial states
- Phase coherence: quantum systems maintain global phase correlations

#### 3. Quantum Entanglement Networks

Quantum entanglement forms multi-particle entanglement networks, representable as:

$$|\Psi_{\text{network}}\rangle = \sum_{i_1, i_2, \ldots, i_n} c_{i_1 i_2 \ldots i_n} |i_1 i_2 \ldots i_n\rangle$$

Entanglement can be quantified in multiple ways, including entanglement entropy:

$$E(|\psi_{AB}\rangle) = S(\rho_A) = S(\rho_B)$$

Entanglement networks form non-local connection structures in the quantum domain, supporting super-classical information transfer.

#### 4. Quantum Fluctuations

The quantum domain has inherent quantum fluctuations, guaranteed by the uncertainty principle:

$$\Delta A \cdot \Delta B \geq \frac{1}{2}|\langle[\hat{A},\hat{B}]\rangle|$$

Quantum fluctuation strength correlates with system energy and temperature:

$$\langle(\Delta E)^2\rangle = k_B T^2 \frac{\partial \langle E \rangle}{\partial T}$$

These fluctuations are the source of creativity and possibility in the quantum domain.

### Classical Domain Detailed Theory

The classical domain $\Omega_C$ is the space of determined reality in the dualistic framework, with these core properties:

#### 1. Classical Information Structure

Classical information exists in the form of determined states, representable through definite physical quantities:

$$K_C = \{(x_i, p_i, E_i, s_i, t_i, \ldots)_j\}$$

where $x_i$, $p_i$, etc. represent position, momentum, and other classical observables. Classical information entropy satisfies:

$$S_C = -k_B \sum_i p_i \ln p_i$$

Key characteristics include information clonability and deletability, distinguishing it from quantum information.

#### 2. Deterministic Dynamics

Classical systems evolve according to deterministic dynamical equations:

$$\frac{d\vec{x}}{dt} = \vec{v}(\vec{x},t), \quad \frac{d\vec{p}}{dt} = \vec{F}(\vec{x},\vec{p},t)$$

The dynamics has three signature features:
- Locality: interactions propagate through local fields at finite speed
- Causality: present states are completely determined by the past
- Separability: systems can be decomposed into independent subsystems

#### 3. Entropy Increase and Irreversibility

Irreversible processes in the classical domain lead to entropy increase:

$$\frac{dS_C}{dt} \geq 0$$

Systems tend toward maximum entropy states, guaranteed by the phase space volume expansion theorem:

$$\frac{d}{dt}\int_V d\Gamma = \int_V \sum_i \frac{\partial \dot{z}_i}{\partial z_i}d\Gamma$$

where $\{z_i\}$ is the set of phase space coordinates.

#### 4. Classical Knowledge Networks

Classical knowledge forms causal networks, representable as directed graphs:

$$G_K = (V_K, E_K)$$

where $V_K$ is the set of knowledge nodes and $E_K$ is the set of causal relations.

Knowledge coherence is measured by:

$$C(K_C) = \frac{1}{|V_K|} \sum_{i,j} \frac{|P_{ij}|}{d(i,j)}$$

where $P_{ij}$ is the set of effective paths connecting nodes $i$ and $j$, and $d(i,j)$ is the distance in the graph.

### Interface Theory Core

The interface $\mathcal{I}$ is the transition region between quantum and classical domains, with these core properties:

#### 1. Interface Structure

The interface is the intersection of quantum and classical domains, defined as:

$$\mathcal{I} = \{x \in \mathcal{U} | \mathcal{D}(x) = \mathcal{D}_c\}$$

where $\mathcal{D}(x)$ is the decoherence metric function and $\mathcal{D}_c$ is the critical decoherence threshold.

Interface thickness is determined by the decoherence gradient:

$$\delta_{\mathcal{I}} = \left|\frac{\partial \mathcal{D}}{\partial x}\right|^{-1}$$

#### 2. Interface Dynamics

Interface position satisfies a nonlinear dynamics equation:

$$\frac{d\mathcal{D}(x,t)}{dt} = \alpha \nabla^2 \mathcal{D}(x,t) + \beta(\mathcal{D}_c - \mathcal{D}(x,t))(\mathcal{D}(x,t) - \mathcal{D}_0) + \gamma\xi(x,t)$$

where:
- $\alpha$ is the diffusion coefficient
- $\beta$ is the bistable potential parameter
- $\mathcal{D}_0$ is the metastable threshold
- $\gamma\xi(x,t)$ is the quantum noise term

Interface oscillations have a characteristic frequency:

$$f_{\mathcal{I}} = \frac{1}{2\pi}\sqrt{\frac{\beta}{\alpha}}|\mathcal{D}_c - \mathcal{D}_0|$$

#### 3. Classicalization Process

The quantum→classical conversion (classicalization) process is represented by the classicalization superoperator:

$$\mathcal{C}(\rho) = \sum_i P_i \rho P_i$$

where $P_i$ are projection operators. The classicalization process satisfies information conservation:

$$I(\rho) = I(\mathcal{C}(\rho)) + I_{\text{hidden}}$$

Classicalization efficiency correlates with environmental and system parameters:

$$\eta_{\mathcal{C}} = 1 - e^{-\lambda\frac{E}{k_BT}}$$

where $E$ is system energy, $T$ is environmental temperature, and $\lambda$ is a coupling constant.

#### 4. Quantum-Classical Information Conversion

At the interface, information converts from quantum to classical form:

$$I_Q \rightarrow I_C + I_{\text{hidden}}$$

The information matching metric in the conversion process is:

$$M(I_Q, I_C) = \frac{I_C}{I_Q} = 1 - \frac{I_{\text{hidden}}}{I_Q}$$

At the optimal interface position, $M(I_Q, I_C)$ reaches a local maximum.

### Observer Theory Core

Observers are nodes executing quantum→classical conversions, with these core properties:

#### 1. Observer Structure

Observers consist of three core components:

$$\mathcal{O} = \{\mathcal{C}_{\mathcal{O}}, \mathcal{Q}_{\mathcal{O}}, K_C^{\mathcal{O}}\}$$

where:
- $\mathcal{C}_{\mathcal{O}}$ is the observer-specific classicalization operator
- $\mathcal{Q}_{\mathcal{O}}$ is the observer-specific quantization operator
- $K_C^{\mathcal{O}}$ is the observer's classical knowledge base

Observer dimension is determined by information processing capability:

$$D_{\mathcal{O}} = f\left(\frac{\mathcal{C}_{\mathcal{O}}}{\mathcal{Q}_{\mathcal{O}}}\right) \cdot \frac{I_{classical knowledge}}{S_{classical entropy}+\epsilon}$$

#### 2. Dimensional Network Dynamics

Observer dimension satisfies a nonlinear dynamics equation:

$$\frac{dD_{\mathcal{O}}}{dt} = \alpha\frac{dI_{K_C}}{dt} - \beta\frac{dS_C}{dt} + \gamma\sum_{j\in\mathcal{N}(i)}(D_j-D_{\mathcal{O}})$$

where the last term represents collective effects of the observer network.

Consensus formation in observer networks follows:

$$\frac{d\mathcal{C}_{\text{consensus}}}{dt} = \sum_i \omega_i \mathcal{C}_i - \gamma(\mathcal{C}_{\text{consensus}} - \bar{\mathcal{C}})^2$$

where $\omega_i$ are observer weights and $\bar{\mathcal{C}}$ is the average classicalization operator.

#### 3. Measurement Theory

In observer theory, the quantum measurement process is represented as:

$$|\psi\rangle\langle\psi| \otimes \rho_A \otimes \rho_O \xrightarrow{U_{interaction}} \sum_{i,j} c_i c_j^* |i\rangle\langle j| \otimes |A_i\rangle\langle A_j| \otimes \rho_O \xrightarrow{\mathcal{C}_O} |i_0\rangle\langle i_0| \otimes |A_{i_0}\rangle\langle A_{i_0}| \otimes \rho_{O}^{i_0}$$

Measurement outcome probabilities are modulated by the observer resolution parameter $\eta_O$:

$$P(i_0||\psi\rangle) = |c_{i_0}|^2 \cdot \frac{e^{\eta_O|c_{i_0}|^2}}{\sum_j e^{\eta_O|c_j|^2}}$$

Observer energy threshold resolution relates to measurement resolution:

$$\eta_O = \frac{\hbar}{k_B T} \cdot \ln\left(\frac{E_{threshold}}{\bar{E}_0}\right)$$

#### 4. Observer Hierarchical Networks

Observers form multi-level network structures:

$$\mathcal{N} = \{\mathcal{O}^{(1)}, \mathcal{O}^{(2)}, ..., \mathcal{O}^{(n)}, \mathcal{E}\}$$

where $\mathcal{O}^{(k)}$ is the set of level-k observers and $\mathcal{E}$ is the set of cross-level connections.

Higher-level observers perceive larger spacetime scales:

$$L^{(k)} \approx L^{(1)} \cdot e^{\eta(k-1)}, \quad T^{(k)} \approx T^{(1)} \cdot e^{\eta(k-1)}$$

This explains why higher-dimensional observers can perceive spacetime patterns at larger scales.

## Branch Theory Navigation

Below are the core descriptions and links to each branch theory of Quantum-Classical Dualism:

### [Quantum Domain Details](formal_theory_quantum_domain_en.md)
Explores the complete characteristics of the quantum domain, including superposition states, entangled states, quantum uncertainty, and quantum information dynamics. The quantum domain, as a space of infinite possibilities, forms one foundation of the dualistic framework.

### [Classical Domain Details](formal_theory_classical_domain_en.md)
Analyzes the complete characteristics of the classical domain, including classical knowledge structures, determinism, locality, and classical information theory. The classical domain, as a space of determined reality, forms the other foundation of the dualistic framework.

### [Interface Theory](formal_theory_interface_en.md)
Studies the interface dynamics between quantum and classical domains, including interface oscillations, phase transitions, and detailed mechanisms of classicalization processes. The interface is a key area for understanding quantum-to-classical transitions.

### [Observer Theory](formal_theory_observer_en.md)
Explores the core role of observers in quantum-classical conversions, including observer networks, dimension evolution, and consciousness formation mechanisms. Observers, as nodes executing quantum→classical conversions, play a central role in the entire framework.

### [Mathematical Appendix](formal_theory_mathematical_appendix_en.md)
Provides mathematical tools and techniques needed for quantum-classical dualism, including advanced function spaces, nonlinear dynamics, and information geometry. Offers a rigorous mathematical foundation for the theory.

### [Experimental Predictions](formal_theory_experimental_en.md)
Lists experimentally verifiable predictions proposed by quantum-classical dualism, including interface oscillations, critical scales, and observer resolution measurable phenomena. Provides empirical testing methods for the theory.

### [Quantum Gravity and Spacetime Emergence](formal_theory_gravity_spacetime_en.md)
Explores how spacetime structures emerge from quantum information networks and the dualistic explanation of quantum gravity. Addresses the most challenging unification problem in physics.

### [Quantum Biology](formal_theory_quantum_biology_en.md)
Studies quantum effects in biological systems, explaining quantum-classical conversion mechanisms in life processes. Provides a novel perspective for understanding the essence of life.

### [Information-Spacetime-Energy Unified Theory](formal_theory_unified_en.md)
Proposes a unified theoretical framework for information, energy, and spacetime, revealing deep connections between them. Establishes a unified understanding of the fundamental elements of the universe.

### [Higher-Dimensional Observer Networks](formal_theory_observer_network_en.md)
Analyzes the structure and function of multi-level observer networks, including collective consciousness and higher-dimensional entities. Studies the emergence mechanisms of consciousness and intelligence.

### [Quantum Computing Applications](formal_theory_quantum_computing_en.md)
Explores the theoretical impact and practical applications of dualism on quantum computing, including novel quantum algorithms and architectures. Provides theoretical foundations for quantum computing technology.

### [Quantum Decision Theory](formal_theory_quantum_decision_en.md)
Establishes a quantum-classical hybrid model describing decision processes, unifying intuitive and rational decision mechanisms. Offers a novel framework for understanding human decisions.

### [Temporal Asymmetry Theory](formal_theory_temporal_asymmetry_en.md)
Explains the origin of the arrow of time, revealing the quantum roots of spacetime asymmetry. Resolves the mystery of temporal directionality in physics.

### [Quantum Cognitive Dynamics](formal_theory_cognitive_dynamics_en.md)
Studies the quantum-classical dual nature of thinking, learning, and creativity. Provides new theoretical tools for cognitive science.

### [Hierarchical Spacetime Theory](formal_theory_hierarchical_spacetime_en.md)
Analyzes multi-level nested spacetime structures and their interrelationships. Explains the coherence of physical laws across different scales.

### [Multiscale Dualism](formal_theory_multiscale_en.md)
Explores the application of dualism across different scales, from elementary particles to cosmological scales. Establishes a cross-scale unified physical framework.

### [Quantum Consciousness Theory](formal_theory_consciousness_en.md)
Studies the quantum foundations and classical expressions of consciousness, explaining the emergence mechanisms of subjective experience. Offers a new perspective on the hard problem of consciousness.

### [Quantum Medicine Applications](formal_theory_medicine_en.md)
Applies dualism to the medical field, proposing quantum-classical descriptions of health and disease. Develops novel medical methods and technologies.

### [Topological Information Protection Theory](formal_theory_topology_en.md)
Studies topological protection mechanisms of quantum information during classicalization processes. Explains the stability of quantum effects in complex systems.

### [Quantum Social Dynamics](formal_theory_social_en.md)
Extends the dualistic framework to social systems, establishing quantum-classical descriptions of social phenomena. Provides new tools for social sciences.

### [Quantum Artificial Intelligence and Machine Learning](formal_theory_quantum_ai_en.md)
Explores quantum-classical hybrid models for artificial intelligence and machine learning. Designs next-generation intelligent system architectures.

### [Quantum-Classical Information Security Theory](formal_theory_quantum_security_en.md)
Unifies classical cryptography and quantum cryptography, revealing deep connections between them. Develops new secure communication schemes.

### [Quantum-Classical Resonance Theory](formal_theory_resonance_en.md)
Studies resonance phenomena between quantum and classical systems and their applications. Discovers novel mechanisms for energy and information transfer.

### [Information Phase Transition Theory](formal_theory_phase_transition_en.md)
Analyzes phase transition phenomena in information systems, particularly the critical behavior of quantum-classical conversions. Understands sudden changes in complex systems.

### [Self-Reference Loop Theory](formal_theory_self_reference_en.md)
Explores self-referential structures in consciousness and theory, explaining mechanisms of consciousness self-cognition. Resolves the significance of Gödel's incompleteness in physics.

### [Quantum-Classical Non-Equilibrium Theory](formal_theory_nonequilibrium_en.md)
Studies dynamics of quantum-classical systems far from equilibrium. Understands the nature of living systems and creative processes.

### [Dualism Computational Complexity Theory](formal_theory_computation_en.md)
Analyzes complexity categories of quantum-classical hybrid computational models. Discovers novel computational efficiency boundaries.

### [Observer Feedback Theory](formal_theory_observer_feedback_en.md)
Studies feedback effects of observers on observed systems. Explains measurement problems and consciousness intervention phenomena.

### [System Reduction Theory](formal_theory_reduction_en.md)
Explores how effective theories in various specialized fields can be derived from basic dualism. Establishes unified foundations for various branches of science.

### [Practical Applications Collection](formal_theory_practical_applications_en.md)
Compiles practical applications of quantum-classical dualism across various fields. Transforms theory into practical technologies and methods.

## Document Navigation
- [Core Theory (This File)](formal_theory_en.md)
- [Quantum Domain Details](formal_theory_quantum_domain_en.md)
- [Classical Domain Details](formal_theory_classical_domain_en.md)
- [Interface Theory](formal_theory_interface_en.md)
- [Observer Theory](formal_theory_observer_en.md)
- [Mathematical Appendix](formal_theory_mathematical_appendix_en.md)
- [Experimental Predictions](formal_theory_experimental_en.md)
- [Quantum Gravity and Spacetime Emergence](formal_theory_gravity_spacetime_en.md)
- [Quantum Biology](formal_theory_quantum_biology_en.md)
- [Information-Spacetime-Energy Unified Theory](formal_theory_unified_en.md)
- [Higher-Dimensional Observer Networks](formal_theory_observer_network_en.md)
- [Quantum Computing Applications](formal_theory_quantum_computing_en.md)
- [Quantum Decision Theory](formal_theory_quantum_decision_en.md)
- [Temporal Asymmetry Theory](formal_theory_temporal_asymmetry_en.md)
- [Quantum Cognitive Dynamics](formal_theory_cognitive_dynamics_en.md)
- [Hierarchical Spacetime Theory](formal_theory_hierarchical_spacetime_en.md)
- [Multiscale Dualism](formal_theory_multiscale_en.md)
- [Quantum Consciousness Theory](formal_theory_consciousness_en.md)
- [Quantum Medicine Applications](formal_theory_medicine_en.md)
- [Topological Information Protection Theory](formal_theory_topology_en.md)
- [Quantum Social Dynamics](formal_theory_social_en.md)
- [Quantum Artificial Intelligence and Machine Learning](formal_theory_quantum_ai_en.md)
- [Quantum-Classical Information Security Theory](formal_theory_quantum_security_en.md)
- [Quantum-Classical Resonance Theory](formal_theory_resonance_en.md)
- [Information Phase Transition Theory](formal_theory_phase_transition_en.md)
- [Self-Reference Loop Theory](formal_theory_self_reference_en.md)
- [Quantum-Classical Non-Equilibrium Theory](formal_theory_nonequilibrium_en.md)
- [Dualism Computational Complexity Theory](formal_theory_computation_en.md)
- [Observer Feedback Theory](formal_theory_observer_feedback_en.md)
- [System Reduction Theory](formal_theory_reduction_en.md)
- [Practical Applications Collection](formal_theory_practical_applications_en.md) 