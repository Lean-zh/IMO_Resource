# IMO Resource

[中文简体](README.md) | [English](README-en.md)

国际数学奥林匹克竞赛 (IMO, International Mathematical Olympiad) 的资源及 2024 年的题解分析。

## 文件结构

- `IMO_2024`
  - `scripts`: 题目 3 的 Python 分析代码。
  - `IMO2024`: AlphaProof 关于问题 1、2 和 6 的[ LEAN 题解](https://storage.googleapis.com/deepmind-media/DeepMind.com/Blog/imo-2024-solutions/index.html)。
  - `IMO_2024_Solutions.pdf`: 所有问题的官方解答。([Ref](https://static1.squarespace.com/static/6466334ad7b8bd6423671df6/t/6697e748ea84cc7893e4aab8/1721231178032/IMO+2024+-+Paper+1+Solutions.pdf))
- `problems`
  - `Chinese`: 中文版题目（2006-2024）。
  - `English`: 英文版题目（1959-2024）。
- `shortlist`: 2006 年至 2023 年 IMO 竞赛候选题及解答。


## 环境配置

安装教程参看：[LEAN 4 安装和配置教程](https://www.leanprover.cn/tutorial/install/)。

初始化 Lean 环境：

```bash
git clone https://github.com/Lean-zh/IMO_Resource.git
cd IMO_Resource/IMO_2024
lake update # 更新依赖
lake build # 编译
```


`IMO_2024/scripts` 为题目 3 的 Python 分析代码，通过模型对话生成。对话提示词：
- 函数代码的生成：https://shared-chats.lookeng.cn/IMO_2024_p3_gen_funcs.html
- 实验代码的生成：https://shared-chats.lookeng.cn/Integer_Sequence_Analysis.html

题解博客（更新中）：[国际数学奥林匹克竞赛及 IMO 2024 题解分析](https://lookeng.cn/2024/09/04/imo-competition/)。