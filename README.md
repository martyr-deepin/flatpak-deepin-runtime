flatdeb
============

flatdeb is a proof of concept for building Flatpak runtimes and apps
from Debian packages.

### Depends
* debootstrap 
* flatpak 
* flatpak-builder 
* systemd-container

### Run
Runtime 生成(runtimes)
```
./run.py --suite=unstable --arch=amd64 base # 生成base
./run.py --suite=unstable --arch=amd64 runtimes org.deepin.flatdeb.Base.yaml # 生成flatpak Runtime/SDK
```

应用生成(packages)
```
./run.py --arch=amd64 app *.yaml # 生成flatpak应用
```
```
flatpak --user add-remote --no-gpg-verify flatdeb $HOME/.cache/flatdeb/repo
flatpak --user install flatdeb org.deepin.flatdeb.hello
flatpak run org.deepin.flatdeb.hello
```

### Packages
Deepin 已打包软件包的YAML文件在 `https://cr.deepin.io/flatpak-deepin-applications`
切换到`flatdeb`分支, 拷贝到`packages`, 执行生成flatpak应用命令
