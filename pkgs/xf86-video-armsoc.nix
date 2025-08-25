{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, pkg-config
, autoreconfHook
, xorg
, libdrm
, xlnxVersion ? "2025.1"
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-armsoc";
  version = "1.4.1";

  # The <nixpkgs/pkgs/servers/x11/xorg/builder.sh> builder must be used, or
  # Failed to load armsoc_drv.so: undefined symbol: "exaDriverAlloc"
  builder = lib.elemAt xorg.xf86videofbdev.args 1;
  hardeningDisable = [ "bindnow" "relro" ];
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-armsoc";
    rev = finalAttrs.version;
    hash = "sha256-iIfFa/hKKlhkQGHsw74WgJ/+kj7crWo+iQQuwaTK2Lg=";
  };

  patches = [
    (fetchpatch {
      url = "https://git.yoctoproject.org/meta-xilinx/plain/meta-xilinx-core/dynamic-layers/openembedded-layer/recipes-graphics/xorg-driver/xf86-video-armsoc/0001-armsoc_driver.c-Bypass-the-exa-layer-to-free-the-roo.patch?h=fd359f0cf8973aff3fa46cd43111e093fbad26a1";
      hash = "sha256-KYGjU41MV79O6nG+bNXO5OSRrD2mI/amJpG9iFvhNZ8=";
    })
    (fetchpatch {
      url = "https://git.yoctoproject.org/meta-xilinx/plain/meta-xilinx-core/dynamic-layers/openembedded-layer/recipes-graphics/xorg-driver/xf86-video-armsoc/0001-src-drmmode_xilinx-Add-the-dumb-gem-support-for-Xili.patch?h=fd359f0cf8973aff3fa46cd43111e093fbad26a1";
      hash = "sha256-ZbZivnv+rqHScl1YLS8ICW7bb1xMX1/DSJ2h+EI7yH4=";
    })
  ] ++ lib.optionals (lib.versionAtLeast xlnxVersion "2025.1") [
    (fetchpatch {
      url = "https://git.yoctoproject.org/meta-xilinx/plain/meta-xilinx-core/dynamic-layers/openembedded-layer/recipes-graphics/xorg-driver/xf86-video-armsoc/0001-xf86-video-armsoc-Add-shadow-buffer-hooks.patch?h=80923f7036d91b7c4ba20b19ca61f258b53295dc";
      hash = "sha256-jFZz+56PpS5oYYdTvrLPZHlbe9zP62A0Oo4RYK+02PI=";
    })
    (fetchpatch {
      url = "https://git.yoctoproject.org/meta-xilinx/plain/meta-xilinx-core/dynamic-layers/openembedded-layer/recipes-graphics/xorg-driver/xf86-video-armsoc/0001-xf86-video-armsoc-Update-xilinx-drm-driver-name.patch?h=80923f7036d91b7c4ba20b19ca61f258b53295dc";
      hash = "sha256-sGDArEXQYpeq6IPk3QPREiwjSpBhc1v/aqZbVXcYi8M=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    xorg.utilmacros
    xorg.xorgserver
    libdrm
  ];

  meta = with lib; {
    description = "Open-source X.org graphics driver for ARM graphics (with Xilinx patches)";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-armsoc";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chuangzhu ];
  };
})
