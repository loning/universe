# 量子经典二元论形式化理论术语表 v27.0

**[返回核心理论](formal_theory.md) | [English Version](formal_theory_terminology_en.md)**

> 本术语表基于[核心理论](core.md) v27.0版本

## 核心概念术语

| 术语(中文) | Term(English) | 符号表示 | 定义 | 相关理论文件 |
|------------|---------------|----------|------|--------------|
| 量子域 | Quantum Domain | $\Omega_Q$ | 无限可能性的空间，包含波函数叠加态和量子纠缠态 | [core.md](core.md), [formal_theory.md](formal_theory.md) |
| 经典域 | Classical Domain | $\Omega_C$ | 确定现实的空间，包含经典知识和经典熵 | [core.md](core.md), [formal_theory.md](formal_theory.md) |
| 界面域 | Interface Domain | $\mathcal{I}$ | 量子域与经典域的交集，量子-经典转换发生的边界 | [formal_theory_interface.md](formal_theory_interface.md) |
| 经典化 | Classicalization | $\mathcal{C}$ | 量子→经典转换过程，将量子可能性转化为经典确定性 | [formal_theory.md](formal_theory.md) |
| 量子化 | Quantization | $\mathcal{Q}$ | 经典→量子转换过程，将经典确定性转化为量子可能性 | [formal_theory.md](formal_theory.md) |
| 观察者 | Observer | $\mathcal{O}$ | 执行量子→经典转换的节点，由经典化算符、量子化算符和经典知识库构成 | [formal_theory_observer.md](formal_theory_observer.md) |
| 观察者维度 | Observer Dimension | $D_{\mathcal{O}}$ | 观察者的信息处理能力，由经典知识与经典熵比率决定 | [core.md](core.md), [formal_theory_observer.md](formal_theory_observer.md) |
| 非平衡度 | Nonequilibrium Degree | $D_{NEQ}$ | 系统远离平衡态的程度，由状态变化率决定 | [formal_theory_nonequilibrium.md](formal_theory_nonequilibrium.md) |
| 计算复杂度 | Computational Complexity | $\mathcal{K}(\Psi)$ | 计算过程所需资源的度量，包括量子、经典和转换复杂度 | [formal_theory_computation.md](formal_theory_computation.md) |
| 量子纠缠 | Quantum Entanglement | $E(|\psi_{AB}\rangle)$ | 量子系统间的非局域关联，无法用局域状态完全描述 | [core.md](core.md), [formal_theory_quantum_domain.md](formal_theory_quantum_domain.md) |
| 经典知识 | Classical Knowledge | $K_C$ | 经典域中的确定信息结构，观察者通过经典化获得 | [core.md](core.md), [formal_theory_classical_domain.md](formal_theory_classical_domain.md) |
| 经典熵 | Classical Entropy | $S_C$ | 经典域中的不确定性量度，表征系统无序程度 | [core.md](core.md), [formal_theory_classical_domain.md](formal_theory_classical_domain.md) |
| 界面厚度 | Interface Thickness | $\delta_{\mathcal{I}}$ | 量子-经典转换过程的空间范围 | [formal_theory_interface.md](formal_theory_interface.md) |
| 经典化效率 | Classicalization Efficiency | $\eta_C$ | 量子信息转化为经典知识的效率 | [core.md](core.md), [formal_theory_interface.md](formal_theory_interface.md) |
| 创造性度量 | Creativity Measure | $\mathcal{CR}(\Psi)$ | 计算系统输出信息与可推导信息之差 | [formal_theory_computation.md](formal_theory_computation.md) |

## 数学符号约定

| 符号类型 | 表示法 | 含义 | 示例 |
|----------|--------|------|------|
| 希尔伯特空间 | $\mathcal{H}$ | 量子态空间 | $\mathcal{H}_Q$, $\mathcal{H}(Q \times \Sigma)$ |
| 密度矩阵 | $\rho$ | 量子态统计描述 | $\rho_Q$, $\rho_{total}$ |
| 算符 | 花体字母 | 作用于态的函数 | $\mathcal{C}$, $\mathcal{Q}$ |
| 超算符 | 花体字母 | 作用于算符的函数 | $\mathcal{L}_{QC}$ |
| 集合 | 大括号 | 元素集合 | $\{x_i\}$, $\Psi_{NEQ} = \{\rho_Q, K_C, \Phi_E, \Phi_I\}$ |
| 向量 | 箭头或粗体 | 矢量量 | $\vec{T}$, $\Phi_E$, $\Phi_I$ |
| 维度 | $D$ | 观察者或系统维度 | $D_{\mathcal{O}}$, $D_{min}$ |
| 复杂度 | $\mathcal{K}$ | 计算复杂度 | $\mathcal{K}_Q$, $\mathcal{K}_C$, $\mathcal{K}_{QC}$ |
| 效率 | $\eta$ | 转换或计算效率 | $\eta_C$, $\eta_{Q\rightarrow C}$ |
| 熵 | $S$ | 信息熵 | $S_C$, $S_{VN}$ |
| 概率 | $P$ | 概率测度或分布 | $P(x)$, $P(path_i)$ |

## 跨领域术语对照

### 量子-经典二元论与传统物理学

| 量子经典二元论术语 | 传统物理学对应术语 | 关系说明 |
|--------------------|--------------------|--------------------|
| 经典化 | 退相干、波函数坍缩 | 经典化是更广义的过程，包含退相干与坍缩 |
| 量子化 | 量子叠加、纠缠形成 | 量子化涉及更广泛的经典→量子转换 |
| 量子域 | 量子力学领域 | 量子域包含所有可能性空间，超出传统量子力学范畴 |
| 经典域 | 经典物理学领域 | 经典域强调确定性信息，而非仅物理规律 |
| 观察者 | 测量装置、观测者 | 观察者在二元论中具有更基础的定义和角色 |
| 非平衡态 | 远离平衡态系统 | 非平衡态强调量子-经典耦合特性 |
| 界面 | 量子-经典边界 | 界面具有明确的数学结构和动力学规律 |

### 量子-经典二元论与信息科学

| 量子经典二元论术语 | 信息科学对应术语 | 关系说明 |
|--------------------|--------------------|--------------------|
| 经典化 | 信息压缩、特征提取 | 经典化是量子信息向经典信息的映射 |
| 量子化 | 信息扩展、可能性生成 | 量子化创造超出输入信息的新可能性 |
| 经典知识 | 显式信息、结构化数据 | 经典知识是经典信息的有组织表示 |
| 经典熵 | 香农熵、信息不确定性 | 经典熵测量经典信息的不确定性 |
| 观察者计算能力 | 计算复杂度类别 | 观察者维度决定其能解决的问题集 |
| 自指涉计算 | 递归函数、自修改代码 | 自指涉计算包含系统引用自身的能力 |
| 涌现计算能力 | 集体智能、涌现计算 | 观察者网络产生超出个体和的能力 |

### 量子-经典二元论与认知科学

| 量子经典二元论术语 | 认知科学对应术语 | 关系说明 |
|--------------------|--------------------|--------------------|
| 经典化 | 感知、模式识别 | 经典化类似于感知过程中的信息提取 |
| 量子化 | 创造性思维、发散思考 | 量子化类似于创造新可能性的思维过程 |
| 经典知识 | 长期记忆、语义网络 | 经典知识对应于有组织的记忆结构 |
| 观察者维度 | 认知复杂度、智能水平 | 观察者维度反映信息处理能力 |
| 非平衡动力学 | 神经动力学、意识流 | 大脑认知过程的动态特性 |
| 量子-经典混合计算 | 理性-直觉双系统思维 | 混合计算模型类似于双系统认知模型 |
| 自指涉限制 | 元认知局限、自我盲点 | 两者都涉及系统理解自身的限制 |

## 理论演化术语对照

| 早期术语 (v6.0) | 当前术语 (v27.0) | 变更说明 |
|-----------------|-------------------|--------------------|
| 波函数 | 量子域态 | 扩展为更一般的量子态概念 |
| 粒子态 | 经典域确定态 | 强调确定性而非粒子性质 |
| 意识 | 广义意识/观察者 | 明确定义为经典化能力 |
| 坍缩 | 经典化 | 突出信息处理本质 |
| 薛定谔方程 | 量子域动力学 | 包含更广泛的演化规律 |
| 经典动力学 | 经典域动力学 | 包含更广泛的经典系统 |
| 相对论 | 时空经典域理论 | 作为二元论的特例 |
| 量子力学 | 量子域理论 | 作为二元论的特例 |
| 信息测量 | 经典域信息测量 | 强调经典信息的量化 |
| 信息守恒 | 信息转换守恒 | 强调信息形式转换 |

## 领域特异性术语

### 计算理论特有术语

| 术语 | 英文术语 | 定义 | 首次引入版本 |
|------|----------|------|--------------|
| 量子-经典混合图灵机 | Quantum-Classical Hybrid Turing Machine | 结合量子和经典计算能力的抽象计算模型 | v10.0 |
| 量子-经典转换复杂度 | Quantum-Classical Conversion Complexity | 量子态向经典态转换或反向转换所需的计算资源 | v10.0 |
| 不可约计算复杂性 | Irreducible Computational Complexity | 无法通过低层系统组合实现的计算能力 | v11.0 |
| 自指涉计算模型 | Self-Referential Computation Model | 能够引用和修改自身的计算系统 | v10.5 |
| 观察者计算能力模型 | Observer Computational Capability Model | 观察者维度与其可解决问题集合的关系模型 | v10.0 |

### 非平衡态理论特有术语

| 术语 | 英文术语 | 定义 | 首次引入版本 |
|------|----------|------|--------------|
| 非平衡度 | Nonequilibrium Degree | 系统远离平衡态的程度量化 | v10.0 |
| 非平衡量子-经典转换 | Nonequilibrium Quantum-Classical Conversion | 远离平衡条件下的量子-经典信息转换 | v10.0 |
| 涨落-耗散关系 | Fluctuation-Dissipation Relation | 非平衡系统中涨落与耗散的数学关系 | v10.5 |
| 非平衡熵产生率 | Nonequilibrium Entropy Production Rate | 非平衡过程中熵的产生速率 | v10.0 |
| 经典化路径选择 | Classicalization Path Selection | 多可能经典化结果间的选择机制 | v11.0 |

### 观察者理论特有术语

| 术语 | 英文术语 | 定义 | 首次引入版本 |
|------|----------|------|--------------|
| 观察者维度 | Observer Dimension | 观察者的信息处理能力量化 | v8.0 |
| 维度依赖性 | Dimensional Dependency | 计算能力与观察者维度的依赖关系 | v10.0 |
| 集体计算模型 | Collective Computation Model | 多观察者网络形成的计算系统 | v10.5 |
| 观察者测量函数 | Observer Measurement Function | 观察者执行量子测量的数学描述 | v9.0 |
| 自我认知局限性 | Self-Cognition Limitation | 观察者对自身认知能力的内在限制 | v11.0 |

## 参考文献

本术语表参考了以下文献和资料：

1. 核心理论文档 [core.md](core.md) v27.0
2. 形式化表达文档 [formal_theory.md](formal_theory.md) v27.0
3. 量子域详解 [formal_theory_quantum_domain.md](formal_theory_quantum_domain.md) v19.0
4. 经典域详解 [formal_theory_classical_domain.md](formal_theory_classical_domain.md) v19.1
5. 界面理论 [formal_theory_interface.md](formal_theory_interface.md) v19.0
6. 观察者理论 [formal_theory_observer.md](formal_theory_observer.md) v19.0
7. 非平衡态理论 [formal_theory_nonequilibrium.md](formal_theory_nonequilibrium.md) v27.0
8. 计算复杂性理论 [formal_theory_computation.md](formal_theory_computation.md) v27.0

## 文档导航
- [核心理论](formal_theory.md)
- [量子域详解](formal_theory_quantum_domain.md)
- [经典域详解](formal_theory_classical_domain.md)
- [界面理论](formal_theory_interface.md)
- [观察者理论](formal_theory_observer.md)
- [数学附录](formal_theory_mathematical_appendix.md)
- [实验预测](formal_theory_experimental.md)
- [量子引力与时空涌现](formal_theory_gravity_spacetime.md)
- [量子-经典非平衡态理论](formal_theory_nonequilibrium.md)
- [二元论计算复杂性理论](formal_theory_computation.md) 