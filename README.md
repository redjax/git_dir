# Git dir <!-- omit in toc -->

My `git/` directory as a repository.

## Table of Contents <!-- omit in toc -->

- [Requirements](#requirements)
- [Quick-Start](#quick-start)
- [Setup](#setup)
- [Usage](#usage)
- [Direnv](#direnv)
- [Taskfile tasks](#taskfile-tasks)

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

## Quick-Start

- Clone the repository to `~/git` (or wherever you put your `git/` directory).
  - HTTP: `git clone https://github.com/redjax/git_dir.git ~/git`
  - SSH: `git clone git@github.com:redjax/git_dir ~/git`
- Trust the `.mise.toml` file and install all tools.
  - `mise trust && mise install`
- Optionally, copy the commented example `.envrc.local` section at the bottom of the [`.envrc`](./.envrc) and paste it into a new file at `~/git/.envrc.local`.
  - You can set local overrides or machine-specific environment variables.
  - Trust the file with `direnv allow`.
  - Now, any time you `cd` into the `~/git` directory, `direnv` will source those files and set the environment variables you define.
  - When you `cd` out of the `~/git` directory, `direnv` will handle unloading those variables.
- Run `task -l` to list all `go-task/task` sessions (to ensure `task` commands will work).

Now you can start cloning repositories into the [`repos/` directory](./repos/). For example, `git clone git@github.com/username/repository.git repos/local_repo_name`. That repository can now be managed by the tasks, automations, etc in this `~/git` repository.

After cloning a repository, test running the `status-all` task:

```shell
task status-all
```

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

## Direnv

You can use `direnv` to automatically set environment variables when you `cd` into the `~/git` repository, and un-set them automatically when you `cd` out of that directory.

The [`.envrc` file](./.envrc) sets some environment variables that will be the same across every machine that clones this repository. It is source-controlled, and should remain generic, and free of any secret/personal data.

If you want to add more custom environment variables for the specific machine you're working on, you can create a `.envrc.local` file, which will be ignored by git so you can put whatever environment variables you want in it. Just copy the commented code at the bottom of the [`.envrc` file](.envrc) to `.envrc.local`, delete the `#` at the beginning of each line, and customize to your liking.

You can set whatever environment variables you want in this file. Think of it a bit like a `~/.bashrc`, but only while your shell session's working directory is `~/git`.

If you navigate to another directory, i.e. `cd ../` or `cd repos/`, the environment variables will unload.

## Taskfile tasks

You can use [`go-task/task`](https://taskfile.dev), which reads from the [`Taskfile.yml`](./Taskfile.yml) to create cross-platform sessions. Inspired by [`Make`](https://www.gnu.org/software/make/), `go-task/task` is primarily a build tool, but can be used for all kinds of automations.

The `Taskfile.yml` imports tasks defined in the [`.tasks/` directory](./.tasks/). You can list all available tasks with:

```shell
$ task -l

task: Available tasks for this project:
* default:              Show machine info
* fetch-all:            Synchronize all git directories in the current path
* status-all:           Show `git status` for all repos found in current path
* git:fetch-all:        Fetch --all --prune for all repositories (parallel, worktree only)
* git:status-all:       Show dirty git status for all repositories
```

Running a task is as simple as running `task <task-name>`. For example, to check the status of all repositories found in `~/git/{repos,sparse-clones,worktrees}`:

```shell
task status-all
```
