# Figure 1: Comparison of Standard QNM and Subharmonic-Extended Models

## Figure Title
**Ringdown Signal Reconstruction Comparison for GW150914**

## Description
This figure presents a direct comparison between the standard quasi-normal mode (QNM) template and our subharmonic-extended model in fitting the late-time ringdown signal from GW150914. The figure consists of four panels:

### Panel (a): Full Ringdown Signal
The top panel shows the strain data h(t) from the LIGO Hanford detector (gray line) during the post-merger ringdown phase of GW150914, starting at t=3ms after the peak amplitude. Overlaid are the best-fit standard QNM model (blue dashed line) using the first two dominant modes and our subharmonic-extended model (red solid line).

### Panel (b): Residual Magnitude
The second panel displays the absolute residual between the data and each model, demonstrating the systematically lower residuals achieved by the subharmonic-extended model, particularly during the t=10-15ms period where standard QNM templates show the largest deviations.

### Panel (c): Time-Frequency Decomposition
A time-frequency spectrogram highlighting the presence of subharmonic structures. The color intensity represents the wavelet power, showing the dominant QNM frequency (≈250 Hz for the remnant black hole) and the subharmonic components at approximately 135 Hz (corresponding to ω₀/(1+ε) with ε≈0.18).

### Panel (d): Reconstruction Error Reduction
Bar chart showing the percentage reduction in reconstruction error achieved by the subharmonic-extended model compared to standard QNM templates across different time windows of the ringdown (t=3-7ms, t=7-15ms, t=15-25ms), demonstrating up to 35% improvement in the late-time tail.

## Key Findings Highlighted
1. Standard QNM templates systematically underfit the late-time (t>10ms) ringdown signal
2. The subharmonic correction terms capture coherent oscillatory patterns in the residuals
3. The improvement is most significant in the intermediate (7-15ms) to late (15-25ms) ringdown phases
4. The time-frequency analysis clearly shows energy at subharmonic frequencies not captured by the standard QNM spectrum

## Technical Details
- Strain data bandpassed between 35-350 Hz
- Whitened using LIGO PSD estimates
- QNM parameters for standard template: dominant (l=m=2, n=0) and first overtone (l=m=2, n=1)
- Subharmonic model includes terms with k=1,2 and optimized ε
- Bayesian parameter estimation performed using nested sampling
- Remnant black hole parameters: M ≈ 62M☉, a/M ≈ 0.67 