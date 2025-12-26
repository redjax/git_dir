# Git dir <!-- omit in toc -->

My `git/` directory as a repository.

## Table of Contents <!-- omit in toc -->

- [Requirements](#requirements)
- [Setup](#setup)
- [Usage](#usage)

## Requirements

> [!TIP]
> You can use [`mise`](https://mise.jdx.dev) to install all of these requirements. After cloning, just run:
>
> ```shell
> mise trust
> mise install
> ```

- [`mise`](https://mise.jdx.dev)
- [`direnv`](https://direnv.net)
- [`go-task/task`](https://taskfile.dev)
- [Python](https://www.python.org/downloads/)
- [`uv`](https://docs.astral.sh/uv)

## Setup

Clone this repository:

```shell
## HTTP
git clone https://github.com/redjax/git_dir.git ~/git

## SSH
git clone git@github.com:redjax/git_dir.git ~/git
```

`cd` into `~/git` and run:

```shell
## Trust & install tools with mise
mise trust && mise install

## Enable direnv
direnv allow

## List tasks ensure go-task/task is working
task -l
```

## Usage

When you clone repositories, put them in [the `repos/` directory](./repos/). You can use whatever structure you want, i.e. clone every repo right into `repos/`, or put them in subdirectories. However you want to organize your repositories, just make sure they are all under the `~/git/repos/` path.

This structure accomplishes a few things:

- Fully isolates the repositories from the `~/git` meta-repository.
- Allows for easily targeting only your cloned repos, and not the `~/git` repository itself, i.e. for scans or scripts.
- Keeps VSCode decluttered.
  - If you open the `~/git` repository in VSCode, the source-control plugin will be overwhelmed by all of the repositories if they are all in the root of `~/git`.
  - Nesting repositories in the `repos/` directory allows you to open the `~/git` repository in its own, isolated workspace.

> [!NOTE]
> There are a couple of exceptions to this. You can store sparse clones in [the `sparse-clones/` directory](./sparse-clones/), and git worktrees in [the `worktrees/` directory](./worktrees/).
>
> In general, unless you have a reason to keep a git repository in another path in the `~/git` directory, use the `repos/` directory to clone/create new repositories.
