{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "xlnx-dp-modules-${kernel.version}-${finalAttrs.version}";
  version = kernel.meta.xlnxVersion;

  src = fetchFromGitHub {
    owner = "Xilinx";
    repo = "dp-modules";
    rev = "xilinx_v${finalAttrs.version}";
    hash =
      {
        "2024.1" = "sha256-uWy83c7W0oebvqkhmwkXejFredM4ACO0Cb0jqfeA25Q=";
        "2025.1" = "sha256-22nSUHptYGe35ueaDlOARQXqQ/Ux+Lqs3bqTVeAfovE=";
      }
      .${kernel.meta.xlnxVersion};
  };

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ ];

  makeFlags = kernel.makeFlags ++ [
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installTargets = [ "modules_install" ];
  installFlags = [ "INSTALL_MOD_PATH=$(out)" ];

  enableParallelBuilding = true;

  meta = {
    description = "Out-of-tree Linux modules for Xilinx DisplayPort IP cores";
    homepage = "https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/665747573/Xilinx+DRM+KMS+DisplayPort+1.4+TX+Subsystem+Driver";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})
