#!/bin/bash
# Submission preparation script with error handling

# Set up error handling
set -e  # Exit on error
trap 'echo "Error occurred at line $LINENO. Command: $BASH_COMMAND"' ERR

# Define directories
BASE_DIR="$(pwd)"
LATEX_DIR="${BASE_DIR}/submission_package/latex_final"
BUILD_DIR="${BASE_DIR}/build"
PDF_DIR="${BUILD_DIR}/pdf"
SUBMISSION_DIR="${BUILD_DIR}/submission"

# Create necessary directories
mkdir -p "${SUBMISSION_DIR}"
mkdir -p "${PDF_DIR}"

echo "===== Preparing submission package for PHY-CQG-011 paper ====="

# First make sure PDFs are generated
echo "Ensuring PDFs are up-to-date..."
bash "${BASE_DIR}/generate_pdfs.sh"

# Check if PDFs exist
if [ ! -f "${PDF_DIR}/manuscript.pdf" ]; then
    echo "Error: manuscript.pdf not found. PDF generation may have failed."
    exit 1
fi

# Create complete submission package
echo "Creating submission package..."

# Copy LaTeX source files
echo "Copying LaTeX source files..."
cp -r "${LATEX_DIR}"/* "${SUBMISSION_DIR}/"

# Copy PDFs
echo "Copying PDFs..."
cp "${PDF_DIR}"/* "${SUBMISSION_DIR}/"

# Create cover letter and additional documents if needed
echo "Creating additional documents..."
cat > "${SUBMISSION_DIR}/cover_letter.txt" << EOF
Dear Editor,

We are pleased to submit our manuscript "Subharmonic Corrections in Gravitational Wave Ringdowns: A Semi-Empirical Approach with Resonant Extensions" for consideration for publication in Classical and Quantum Gravity.

Our paper presents a novel semi-empirical correction model for the ringdown phase of gravitational wave signals, revealing consistent subharmonic structures characterized by a parameter ε ≈ 0.18 across different black hole merger events. This enhancement improves late-time waveform reconstruction accuracy by up to 35% and suggests a potential connection to fundamental physical constants like the golden ratio and fine structure constant.

We believe our findings provide significant insight into the structure of post-merger spacetime and open new avenues for testing quantum gravitational effects in the strong-field regime.

All authors have seen and approved the final version of this manuscript. This work has not been published previously and is not under consideration for publication elsewhere.

Sincerely,
Haobo Ma and Wen Niu
AELF PTE LTD.
EOF

# Create a README
cat > "${SUBMISSION_DIR}/README.txt" << EOF
Submission Package: Subharmonic Corrections in Gravitational Wave Ringdowns
Authors: Haobo Ma, Wen Niu
Date: $(date +"%Y-%m-%d")

Package Contents:
- manuscript.pdf: Main paper
- supplementary.pdf: Supplementary material
- cover_letter.txt: Cover letter to the editor
- main.tex: LaTeX source for main paper
- supplement.tex: LaTeX source for supplementary material
- references.bib: Bibliography file
- figures/: Directory containing figures

Submission prepared for: Classical and Quantum Gravity
EOF

# Create a zip archive of the submission package
echo "Creating submission zip archive..."
cd "${BUILD_DIR}"
zip -r "PHY-CQG-011_submission_$(date +"%Y%m%d").zip" submission/

echo "===== Submission preparation complete ====="
echo "Submission package is available at: ${BUILD_DIR}/PHY-CQG-011_submission_$(date +"%Y%m%d").zip"

# List the submission directory
ls -la "${SUBMISSION_DIR}" 