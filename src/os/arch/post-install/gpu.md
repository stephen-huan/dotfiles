# gpu

- [arch wiki - AMDGPU](https://wiki.archlinux.org/title/AMDGPU)
- Install mesa for OpenGL/3D acceleration

```shell
sudo pacman -S mesa
```

- test mesa support

```shell
sudo pacman -S mesa-utils
glxinfo
```

- Install DDX driver for 2D acceleration

```shell
sudo pacman -S xf86-video-amdgpu
```

- Enable vulkan support

```shell
sudo pacman -S amdvlk
```

- test vulkan support

```shell
sudo pacman -S vulkan-tools
vulkaninfo
```

- Accelerated video decoding

```shell
pacman -S libva-mesa-driver mesa-vdpau
```
