FROM gentoo/portage:latest as portage

FROM gentoo/stage3:latest

COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

RUN echo -e "www-client/ungoogled-chromium\napp-misc/font-manager\napp-editors/vscode\ndev-util/electron" > /etc/portage/package.accept_keywords

RUN eselect profile set default/linux/amd64/17.1/desktop

RUN emerge -qv app-portage/layman

RUN yes | layman -f -a pf4public

RUN FEATURES="-usersandbox -userpriv" emerge -qv --autounmask-continue=y --onlydeps ungoogled-chromium font-manager

RUN layman -d pf4public
