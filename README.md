# Kubernetes Dev Training

This repository contains hands-on instructions for the **Kubernetes DEV** training.

Each exercise is a tutorial written for **local** execution however you will find a [Google Cloud Shell](https://cloud.google.com/shell/docs/) integration at the end of each exercise to run the tutorial in a remote environment.

## kubectl extra configuration

Allow completion in kubectl command (activate with `TAB`). bash-completion package should be installed first :

```sh
source <(kubectl completion bash)
```

Create a shortcut alias `k` to `kubectl` and activation completion for this alias :

```sh
alias k=kubectl
complete -o default -F __start_kubectl k
```