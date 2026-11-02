{ ... }:

{
  # AMD GPU (amdgpu). Enable 32-bit graphics for Proton/Wine.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
