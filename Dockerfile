FROM gentoo/portage:latest as portage
FROM gentoo/stage3-amd64:latest
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

RUN echo -e "www-client/ungoogled-chromium **\napp-misc/font-manager **\ndev-util/electron **\nnet-misc/sb-hosts **\napp-admin/gb-chroot **" > /etc/portage/package.accept_keywords
RUN echo -e "app-text/poppler -qt5\ngnome-base/nautilus -previewer\nmedia-video/ffmpeg -svg\nmedia-libs/libjpeg-turbo abi_x86_32" > /etc/portage/package.use/custom
RUN echo -e "PORTAGE_BINHOST='ftp://ftp.calculate-linux.org/calculate/grp/x86_64'\nFEATURES='getbinpkg parallel-install -news -sandbox'\nEMERGE_DEFAULT_OPTS='--autounmask-continue=y --binpkg-changed-deps=n --binpkg-respect-use=y --quiet-build=y'" >> /etc/portage/make.conf

RUN eselect profile set default/linux/amd64/17.1/desktop

RUN emerge -v --unmerge net-misc/openssh sys-apps/sandbox
RUN emerge -v app-portage/layman
RUN yes | layman -f -a pf4public

RUN emerge -v --binpkg-respect-use=n sys-devel/clang sys-devel/llvm media-libs/libjpeg-turbo gnome-base/librsvg

RUN emerge -v app-text/yelp-tools media-sound/pulseaudio x11-libs/libxkbcommon gnome-base/nautilus xfce-base/thunar dev-libs/wayland

RUN emerge -v --onlydeps ungoogled-chromium font-manager electron app-admin/gb-chroot
RUN emerge -v --fetchonly ungoogled-chromium font-manager electron

RUN layman -d pf4public
