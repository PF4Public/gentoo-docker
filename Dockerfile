FROM gentoo/portage:latest as portage
FROM gentoo/stage3:latest
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

RUN echo -e "www-client/ungoogled-chromium\napp-misc/font-manager\napp-editors/vscode\ndev-util/electron" > /etc/portage/package.accept_keywords
RUN echo -e "app-text/poppler -qt5" > /etc/portage/package.use/poppler
RUN echo -e "PORTAGE_BINHOST='ftp://ftp.calculate-linux.org/calculate/grp/x86_64'\nFEATURES='getbinpkg parallel-install -news -sandbox'\nEMERGE_DEFAULT_OPTS='--autounmask-continue=y --binpkg-changed-deps=n --binpkg-respect-use=y --quiet-build=y'" >> /etc/portage/make.conf

RUN eselect profile set default/linux/amd64/17.1/desktop

RUN emerge -v --unmerge net-misc/openssh sys-apps/sandbox
RUN emerge -v app-portage/layman
RUN yes | layman -f -a pf4public

RUN emerge -v --binpkg-respect-use=n dev-lang/rust sys-devel/clang sys-devel/llvm

RUN emerge -v --onlydeps ungoogled-chromium font-manager electron
RUN emerge -v --fetchonly ungoogled-chromium font-manager electron

RUN emerge -v dev-libs/json-glib x11-libs/libva gnome-base/nautilus gnome-extra/nemo xfce-base/thunar

#RUN FEATURES="-sandbox" emerge -v  dev-util/gn media-libs/opus

RUN layman -d pf4public
