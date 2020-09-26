[回到首页](../README.md)

# shell小技巧

1、[Shell 脚本如何输出帮助信息？](https://samizdat.dev/help-message-for-shell-scripts/)（英文）

作者展示了一个技巧，将帮助信息写在 Bash 脚本脚本的头部，然后只要执行“脚本名 + help”，就能输出这段帮助信息。

```bash
#!/bin/bash
###
### my-script — does one thing well
###
### Usage:
###   my-script <input> <output>
###
### Options:
###   <input>   Input file to read.
###   <output>  Output file to write. Use '-' for stdout.
###   -h        Show this message.

function help() {
    sed -rn 's/^### ?//;T;p' "$0"
}

if [[ $# == 0 ]] || [[ "$1" == "-h" ]]; then
    help
    exit 1
fi

# task code...
```

2、上级管道的输出作为下级