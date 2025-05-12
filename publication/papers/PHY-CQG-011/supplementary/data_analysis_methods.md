# Supplementary Material: Data Analysis Methods

## 1. LIGO/Virgo Data Preparation

### 1.1 Data Selection and Conditioning

We analyze data from the LIGO Hanford, LIGO Livingston, and Virgo detectors for two gravitational wave events: GW150914 and GW190521. The data were obtained from the Gravitational Wave Open Science Center (GWOSC) in the form of strain time series $h(t)$.

For each detector and event, we apply the following data conditioning steps:

1. **Time Window Selection**: For the ringdown analysis, we focus on data starting from $t_0 + 3$ ms, where $t_0$ is the estimated merger time from the peak of the waveform amplitude. We analyze a segment of 32 ms duration after this point.

2. **Bandpass Filtering**: A zero-phase Butterworth bandpass filter of order 8 is applied with corner frequencies [25, 500] Hz to reduce both low-frequency seismic noise and high-frequency shot noise while preserving the relevant ringdown frequencies.

3. **Whitening**: The data are whitened using an estimate of the detector's power spectral density (PSD) computed from 128 seconds of data adjacent to, but not including, the event.

4. **Notch Filtering**: Narrow-band instrumental artifacts ("lines") are removed using notch filters at known instrumental resonance frequencies.

### 1.2 Detector Response and Antenna Patterns

The detector response to the gravitational wave signal depends on the sky position and polarization of the source. The strain measured by each detector is:

$$h_{\text{det}}(t) = F_+(t)h_+(t) + F_\times(t)h_\times(t)$$

where $F_+$ and $F_\times$ are the antenna pattern functions, and $h_+$ and $h_\times$ are the plus and cross polarizations of the gravitational wave.

For the ringdown analysis, we use the sky location and orientation inferred from the full inspiral-merger-ringdown analysis, which provides constraints on the relevant geometric factors.

## 2. Parameter Estimation Framework

### 2.1 Model and Parameters

Our ringdown model consists of two components:

1. **Standard QNM Component**: 
   $$h_{\text{QNM}}(t) = \sum_{n=0}^{N-1} A_n e^{-\alpha_n t} \cos(\omega_n t + \phi_n)$$

2. **Subharmonic Extension**:
   $$h_{\text{sub}}(t) = \sum_{k=1}^{K} B_k e^{-\beta_k t} \cos(\Omega_k t + \psi_k)$$

where $\Omega_k = \omega_0 / (k + \epsilon)$.

The full parameter set for our model is:
- Standard QNM parameters: $\{A_n, \phi_n\}_{n=0}^{N-1}$
- Subharmonic parameters: $\{B_k, \psi_k, \beta_k\}_{k=1}^{K}$
- Deviation parameter: $\epsilon$

The frequencies $\omega_n$ and damping rates $\alpha_n$ of the standard QNM modes are fixed functions of the black hole mass $M$ and spin $a/M$, which are treated as model parameters.

### 2.2 Bayesian Inference

We employ Bayesian inference to estimate the model parameters and compare different models. The posterior probability distribution for the parameters $\theta$ given the data $d$ is:

$$p(\theta|d) = \frac{p(d|\theta)p(\theta)}{p(d)}$$

where $p(d|\theta)$ is the likelihood, $p(\theta)$ is the prior, and $p(d)$ is the evidence.

#### 2.2.1 Likelihood Function

Assuming stationary Gaussian noise with zero mean, the likelihood function is:

$$p(d|\theta) \propto \exp\left(-\frac{1}{2}(d-h(\theta)|d-h(\theta))\right)$$

where $(a|b)$ denotes the noise-weighted inner product:

$$(a|b) = 4\Re\int_{f_{\text{min}}}^{f_{\text{max}}} \frac{\tilde{a}(f)\tilde{b}^*(f)}{S_n(f)}df$$

Here, $\tilde{a}(f)$ represents the Fourier transform of $a(t)$, $S_n(f)$ is the one-sided power spectral density of the detector noise, and $f_{\text{min}}$ and $f_{\text{max}}$ are the minimum and maximum frequencies used in the analysis (set to 25 Hz and 500 Hz, respectively).

#### 2.2.2 Prior Distributions

We use the following prior distributions for our parameters:

- Black hole mass $M$: Uniform in $[50, 100]$ M$_\odot$ for GW150914 and $[100, 200]$ M$_\odot$ for GW190521
- Black hole spin $a/M$: Uniform in $[0, 0.99]$
- Amplitudes $A_n$ and $B_k$: Log-uniform in $[10^{-24}, 10^{-21}]$
- Phases $\phi_n$ and $\psi_k$: Uniform in $[0, 2\pi]$
- Deviation parameter $\epsilon$: Uniform in $[0, 0.5]$
- Damping rates $\beta_k$: Log-uniform in $[0.5\alpha_0, 2\alpha_0]$

#### 2.2.3 Posterior Sampling

We use the nested sampling algorithm as implemented in the Dynesty package to efficiently sample the posterior distribution and calculate the evidence. The specific settings used include:

- Number of live points: 1000
- Convergence criterion: 0.01 in log-evidence
- Sampling method: Random walk slice sampling
- Boundary expansion factor: 0.1
- Maximum number of iterations: 50,000

### 2.3 Model Selection

We compare different models using the Bayes factor, which is the ratio of evidences:

$$\mathcal{B}_{12} = \frac{p(d|M_1)}{p(d|M_2)}$$

where $p(d|M_i)$ is the evidence for model $M_i$:

$$p(d|M_i) = \int p(d|\theta_i, M_i)p(\theta_i|M_i)d\theta_i$$

We consider the following models:
- $M_0$: Noise only
- $M_1$: Standard QNM with fundamental mode only
- $M_2$: Standard QNM with fundamental mode and first overtone
- $M_3$: Model $M_2$ plus one subharmonic mode ($k=1$)
- $M_4$: Model $M_2$ plus two subharmonic modes ($k=1,2$)

## 3. Signal Consistency Tests

### 3.1 Time-Domain Residual Analysis

We perform time-domain residual analysis by subtracting the best-fit model from the data and examining the residuals. We quantify the goodness of fit using the following statistics:

1. **Residual Energy**: $E_{\text{res}} = \sum_i [d(t_i) - h(t_i)]^2 \Delta t$
2. **Normalized Residual Energy**: $E_{\text{res}} / E_{\text{data}}$, where $E_{\text{data}} = \sum_i d(t_i)^2 \Delta t$
3. **Residual SNR**: $\rho_{\text{res}} = \sqrt{(r|r)}$, where $r = d - h$ is the residual

### 3.2 Frequency-Domain Tests

In the frequency domain, we perform the following consistency tests:

1. **Power Spectral Density of Residuals**: We compute the PSD of the residuals and compare it to the expected noise PSD. Significant excess power at specific frequencies indicates unmodeled features.

2. **Spectral Line Analysis**: We search for spectral lines in the residual spectrum using a template-based approach, where the templates are sinusoids with exponential decay.

3. **Q-Transform Analysis**: We apply a constant-Q transform to the residuals to identify any time-frequency structures that are not captured by our models.

### 3.3 Injection Studies

To validate our analysis pipeline and quantify potential biases, we perform injection studies where simulated signals with known parameters are added to detector noise, and our parameter estimation procedure is applied to recover these parameters.

We perform three types of injection studies:

1. **Standard QNM Injections**: Signals containing only standard QNM modes to test for false positives in subharmonic detection.

2. **Subharmonic Injections**: Signals containing both standard QNM and subharmonic modes with various values of $\epsilon$ to test our recovery accuracy.

3. **Non-Subharmonic Anomaly Injections**: Signals containing standard QNM modes plus other types of deviations (echoes, memory effects, etc.) to test the specificity of our subharmonic model.

## 4. Systematic Error Analysis

### 4.1 Calibration Uncertainties

Detector calibration uncertainties affect the amplitude and phase of the measured strain. We account for these by including calibration uncertainty parameters in our model:

$$h_{\text{cal}}(f) = h(f)[1 + \delta A(f)]e^{i\delta\phi(f)}$$

where $\delta A(f)$ and $\delta\phi(f)$ are frequency-dependent amplitude and phase corrections.

We marginalize over these calibration parameters using the uncertainty estimates provided by the LIGO/Virgo collaborations: typically 5-10% in amplitude and 3-5 degrees in phase.

### 4.2 Waveform Systematics

Systematic errors can also arise from limitations in our waveform models. We assess these by:

1. **Varying the Ringdown Start Time**: We repeat our analysis with different choices of $t_0$ to quantify sensitivity to this choice.

2. **Higher Modes**: We include higher-order angular modes (beyond $l=m=2$) to test for degeneracies with subharmonic features.

3. **Alternative Damping Models**: We explore different functional forms for the damping rates $\beta_k$ of the subharmonic modes.

### 4.3 Detector Noise Non-Stationarity

We evaluate the impact of non-stationary noise by:

1. **PSD Estimation Variations**: Using different time segments and methods to estimate the noise PSD.

2. **Glitch Identification**: Applying glitch identification algorithms to ensure our results are not influenced by instrumental transients.

3. **Multi-Detector Consistency**: Comparing results obtained from different detectors independently as a cross-check. 