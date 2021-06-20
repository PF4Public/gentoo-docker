FROM gentoo/portage:latest as portage
FROM gentoo/stage3:amd64
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

RUN echo -e "www-client/ungoogled-chromium **\napp-misc/font-manager **\ndev-util/electron **\nnet-misc/sb-hosts **\napp-admin/gb-chroot **\ngnome-extra/nemo\ngnome-base/nautilus\nmedia-plugins/deadbeef-waveform-seekbar **\nmedia-sound/deadbeef" > /etc/portage/package.accept_keywords
RUN echo -e "app-text/poppler -qt5\ngnome-base/nautilus -previewer\nmedia-video/ffmpeg -svg\nmedia-libs/libjpeg-turbo abi_x86_32\nnet-libs/nodejs inspector\nsys-apps/portage -ipc" > /etc/portage/package.use/custom
RUN echo -e "PORTAGE_BINHOST='ftp://ftp.calculate-linux.org/calculate/grp/x86_64'\nFEATURES='getbinpkg parallel-install -news -sandbox -usersandbox -pid-sandbox -ipc-sandbox'\nEMERGE_DEFAULT_OPTS='--autounmask-continue=y --binpkg-changed-deps=n --binpkg-respect-use=y --quiet-build=y'" >> /etc/portage/make.conf
RUN eselect profile set default/linux/amd64/17.1/desktop

RUN emerge -v sys-apps/portage
RUN emerge -q --unmerge sys-apps/sandbox
RUN emerge -q --unmerge net-misc/openssh 
RUN emerge -q app-portage/layman app-portage/repoman
RUN yes | layman -f -a pf4public

RUN emerge -v --getbinpkgonly=y --binpkg-respect-use=n x11-libs/gtk+
RUN emerge -v --getbinpkgonly=y --binpkg-respect-use=n dev-util/gtk-doc net-libs/webkit-gtk media-libs/openh264 dev-libs/re2 media-libs/libvpx media-libs/libsdl media-libs/libsdl2 media-sound/mpg123 media-sound/mpg123 media-sound/deadbeef media-video/ffmpeg

RUN emerge -v app-text/yelp-tools media-libs/libjpeg-turbo

RUN emerge -v --onlydeps ungoogled-chromium font-manager electron app-admin/gb-chroot media-plugins/deadbeef-waveform-seekbar

RUN emerge -v --nodeps --getbinpkgonly=y --binpkg-respect-use=n gnome-base/nautilus xfce-base/thunar gnome-extra/nemo

RUN layman -d pf4public
