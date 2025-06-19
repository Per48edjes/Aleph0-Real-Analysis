#!/bin/bash
# Build script for real analysis homework.
set -e
latexmk -pdf -interaction=nonstopmode main.tex
