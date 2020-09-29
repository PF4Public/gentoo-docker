# name the portage image
FROM gentoo/portage:latest as portage

# image is based on stage3-amd64
FROM gentoo/stage3-amd64:latest

# copy the entire portage volume in
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

RUN emerge -qv app-portage/layman

RUN layman -f -a pf4public

RUN emerge -qv --onlydeps ungoogled-chromium
