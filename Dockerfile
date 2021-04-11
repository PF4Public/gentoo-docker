FROM gentoo/portage:latest as portage
FROM gentoo/stage3:amd64
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

RUN echo -e "www-client/ungoogled-chromium **\napp-misc/font-manager **\ndev-util/electron **\nnet-misc/sb-hosts **\napp-admin/gb-chroot **\ngnome-extra/nemo\ngnome-base/nautilus\nmedia-plugins/deadbeef-waveform-seekbar **\nmedia-sound/deadbeef" > /etc/portage/package.accept_keywords
RUN echo -e "app-text/poppler -qt5\ngnome-base/nautilus -previewer\nmedia-video/ffmpeg -svg\nmedia-libs/libjpeg-turbo abi_x86_32\nnet-libs/nodejs inspector" > /etc/portage/package.use/custom
RUN echo -e "PORTAGE_BINHOST='ftp://ftp.calculate-linux.org/calculate/grp/x86_64'\nFEATURES='getbinpkg parallel-install -news -sandbox'\nEMERGE_DEFAULT_OPTS='--autounmask-continue=y --binpkg-changed-deps=n --binpkg-respect-use=y --quiet-build=y'" >> /etc/portage/make.conf

RUN eselect profile set default/linux/amd64/17.1/desktop

RUN emerge -q --unmerge net-misc/openssh sys-apps/sandbox
RUN emerge -q app-portage/layman
RUN yes | layman -f -a pf4public

RUN emerge -v --getbinpkgonly=y --binpkg-respect-use=n dev-util/gtk-doc net-libs/webkit-gtk sys-devel/clang sys-devel/llvm; exit 0

RUN USE=pulseaudio emerge -v app-text/yelp-tools media-sound/pulseaudio media-libs/libjpeg-turbo

RUN emerge -v --onlydeps ungoogled-chromium font-manager electron app-admin/gb-chroot media-plugins/deadbeef-waveform-seekbar
RUN emerge -q --fetchonly ungoogled-chromium font-manager electron

RUN emerge -v --nodeps --getbinpkgonly=y --binpkg-respect-use=n gnome-base/nautilus xfce-base/thunar gnome-extra/nemo dev-libs/wayland

RUN layman -d pf4public
