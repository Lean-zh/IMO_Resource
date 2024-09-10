# IMO Resource

[中文简体](README.md) | [English](README-en.md)

Resources and solution analyses for the International Mathematical Olympiad (IMO) 2024.

## File Structure

- `IMO_2024`: AlphaProof's [LEAN solutions](https://storage.googleapis.com/deepmind-media/DeepMind.com/Blog/imo-2024-solutions/index.html) for problems 1, 2, and 6.
- `scripts`: Python code for analyzing IMO 2024 problems.
- `problems`
  - `Chinese`: Chinese version of problems (2006-2024).
  - `English`: English version of problems (1959-2024).
- `shortlist`: IMO shortlist problems and solutions from 2006 to 2023.

## Environment Setup

For installation instructions, see: [LEAN 4 Installation and Setup Guide](https://www.leanprover.cn/tutorial/install/).

Initialize the Lean environment:

```bash
# Clone the repository
git clone https://github.com/Lean-zh/IMO_Resource.git
cd IMO_Resource/
git submodule update --init --recursive
# Initialize the Lean environment
cd IMO_2024
lake update # Update dependencies
lake build # Build
```

`scripts` contains the Python analysis code for problem 3, generated through model dialogue. Relevant dialogues:
- `basic.py` function code generation: https://shared-chats.lookeng.cn/IMO_2024_p3_gen_funcs.html
- `p3.ipynb` experimental code generation: https://shared-chats.lookeng.cn/Integer_Sequence_Analysis.html
