#!/bin/bash
# PDF generation script with error handling

# Set up error handling
set -e  # Exit on error
trap 'echo "Error occurred at line $LINENO. Command: $BASH_COMMAND"' ERR

# Define directories
BASE_DIR="$(pwd)"
TEMP_DIR="${BASE_DIR}/temp"
LATEX_DIR="${BASE_DIR}/submission_package/latex_final"
BUILD_DIR="${BASE_DIR}/build"
PDF_DIR="${BUILD_DIR}/pdf"

# Create necessary directories
mkdir -p "${TEMP_DIR}"
mkdir -p "${PDF_DIR}"

echo "===== Generating PDFs for PHY-CQG-011 paper ====="

# Compile main paper
echo "Compiling main paper..."
cd "${LATEX_DIR}"
pdflatex -interaction=nonstopmode main.tex || echo "First pdflatex run had issues, continuing..."
bibtex main || echo "BibTeX had issues, continuing..."
pdflatex -interaction=nonstopmode main.tex || echo "Second pdflatex run had issues, continuing..."
pdflatex -interaction=nonstopmode main.tex || echo "Third pdflatex run had issues, continuing..."

# Check if the PDF was created
if [ -f "main.pdf" ]; then
    echo "Successfully generated main.pdf"
    cp main.pdf "${PDF_DIR}/manuscript.pdf"
else
    echo "Error: Failed to generate main.pdf"
    exit 1
fi

# Compile supplementary material
echo "Compiling supplementary material..."
pdflatex -interaction=nonstopmode supplement.tex || echo "First pdflatex run had issues, continuing..."
bibtex supplement || echo "BibTeX had issues, continuing..."
pdflatex -interaction=nonstopmode supplement.tex || echo "Second pdflatex run had issues, continuing..."
pdflatex -interaction=nonstopmode supplement.tex || echo "Third pdflatex run had issues, continuing..."

# Check if the PDF was created
if [ -f "supplement.pdf" ]; then
    echo "Successfully generated supplement.pdf"
    cp supplement.pdf "${PDF_DIR}/supplementary.pdf"
else
    echo "Warning: Failed to generate supplement.pdf"
fi

# Return to base directory
cd "${BASE_DIR}"

echo "===== PDF generation complete ====="
echo "PDFs are available in ${PDF_DIR}"

# List the generated PDFs
ls -la "${PDF_DIR}" 