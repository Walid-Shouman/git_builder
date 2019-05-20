###### Common commands
FROM gcc:4.9

RUN addgroup --gid 12345 appuser \
    && adduser --uid 12345 --disabled-password --ingroup appuser appuser \
    && adduser appuser sudo

WORKDIR /home/appuser
######

###### Project dependencies commands
RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

RUN apt update \
    && apt --yes install tcl-dev \
    && apt --yes install gettext

ENV DEFAULT_HELP_FORMAT man
######

###### Common commands resumed
USER appuser
######

###### Getting the source
# method 0: through volume mapping the src to /home/appuser/src
#           shall be realized from the run command

# method 1: copy
#           use while developing and the build time isn't really so high
# COPY --chown=appuser:appuser . /home/appuser/src

# method 2: git clone
RUN git clone https://github.com/git/git.git src \
    && cd src \
    && git checkout $(git ls-remote --tags origin | grep -oE 'v[0-9]+(.[0-9]+){2}$' | tail -n1)
######

###### Process specific commands
COPY --chown=appuser:appuser scripts/build_start.sh /usr/bin/

RUN chmod 755 /usr/bin/build_start.sh \
    && mkdir /home/appuser/build

ENV CONFIG_OPTIONS --prefix=/home/appuser/build
######

CMD cd src \
    && /usr/bin/build_start.sh
# CMD ["scl", "enable", "devtoolset-7", "/usr/bin/build_start.sh"]
