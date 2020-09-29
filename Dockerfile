FROM gentoo/portage:latest as portage

FROM gentoo/stage3:latest

COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

RUN emerge -qv app-portage/layman

RUN layman -q -f -a pf4public

RUN emerge -qv --onlydeps ungoogled-chromium
