FROM gentoo/portage:latest as portage

FROM gentoo/stage3:latest

COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

RUN emerge -qv app-portage/layman

RUN yes | layman -f -a pf4public

RUN emerge -qv --onlydeps ungoogled-chromium vscode font-manager

RUN layman -d pf4public
