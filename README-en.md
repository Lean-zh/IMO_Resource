# IMO Resource

[中文简体](README.md) | [English](README-en.md)

Resources and solution analysis for the International Mathematical Olympiad (IMO) 2024.

## Directory Structure

- `IMO_2024`
  - `scripts`: Python analysis code for Problem 3.
  - `IMO2024`: AlphaProof's [LEAN solutions](https://storage.googleapis.com/deepmind-media/DeepMind.com/Blog/imo-2024-solutions/index.html) for Problems 1, 2, and 6.
  - `IMO_2024_Solutions.pdf`: Official solutions for all problems. ([Ref](https://static1.squarespace.com/static/6466334ad7b8bd6423671df6/t/6697e748ea84cc7893e4aab8/1721231178032/IMO+2024+-+Paper+1+Solutions.pdf))
- `problems`
  - `Chinese`: Problems in Chinese (2006-2024).
  - `English`: Problems in English (1959-2024).
- `shortlist`: IMO competition shortlist problems and solutions from 2006 to 2023.

## Environment Setup

For installation instructions, refer to: [LEAN 4 Installation and Configuration Guide](https://www.leanprover.cn/tutorial/install/).

Initialize the Lean environment:

```bash
git clone https://github.com/Lean-zh/IMO_Resource.git
cd IMO_Resource/IMO_2024
lake update # Update dependencies
lake build # Build project
```

`IMO_2024/scripts` contains the Python analysis code for Problem 3, generated through model dialog. Dialog prompts:
- Function code generation: https://shared-chats.lookeng.cn/IMO_2024_p3_gen_funcs.html
- Experimental code generation: https://shared-chats.lookeng.cn/Integer_Sequence_Analysis.html
