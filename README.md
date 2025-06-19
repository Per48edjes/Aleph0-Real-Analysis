# README.md

# Aleph 0 Real Analysis

This repository contains artifacts from the [Aleph 0](https://aleph0.substack.com/about) real analysis course as taught in 2H25.

## Usage

### Build the PDF

```bash
make
```

### Clean auxiliary files

```bash
make clean
```

### Remove the PDF, too

```bash
make purge
```

### Create a GitHub release with the compiled PDF

```bash
make release
```

(Requires GitHub CLI tool `gh` installed and authenticated)

## Structure

- `main.tex`: master file, includes unit files and sets up document layout
- `macros.tex`: math symbols, theorem styles, and environments
- `XX_unit_name/problems.tex`: problems for each unit (where `XX` is the unit number and `unit_name` is the unit's name)
- `build.sh`: builds `main.pdf`
- `release.sh`: releases PDF to GitHub with metadata

## Notes

- To add a new unit to the document, create `XX_unit_name/problems.tex` and add `\input{XX_unit_name/problems}` to `main.tex`
- Use the `problem` environment for numbered problems:

```latex
\begin{problem}\label{prob:example}
Prove that $\aleph_0$ is the cardinality of $\N$.
\end{problem}
```
