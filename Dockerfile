FROM gcc:4.9

# Either copy or git clone/update
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp

CMD git clone https://github.com/git/git.git . \
    && git checkout $(git ls-remote --tags origin | grep -oE 'v[0-9]+(.[0-9]+){2}$' | tail -n1) 

COPY scripts/build_start.sh /usr/bin/

ENV CONFIG_OPTIONS --prefix=/usr/build 
ENV DEFAULT_HELP_FORMAT man


CMD chmod 755 /usr/bin/build_start.sh \
    && /usr/bin/build_start.sh
# CMD ["scl", "enable", "devtoolset-7", "/usr/bin/build_start.sh"]
