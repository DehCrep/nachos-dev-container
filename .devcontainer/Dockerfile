FROM debian:bookworm-slim

ENV CROSS_COMPILE_ARCH=mipsel\
    DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
    && apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        #gcc-multilib \
        #g++-multilib \
        libc6-dev-i386 \
        lib32stdc++-12-dev \
        lib32gcc-12-dev \
        linux-libc-dev-i386-cross \
        gcc-${CROSS_COMPILE_ARCH}-linux-gnu \
        g++-${CROSS_COMPILE_ARCH}-linux-gnu \
        gdb-multiarch \
        cmake \
        ed \
        git \
    && rm -rf /var/lib/apt/lists/*

# Redirect legacy build calls
RUN if [ ! -d /usr/include/asm ]; then \
        ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/asm; \
    fi \
    && ln -s /bin/${CROSS_COMPILE_ARCH}-linux-gnu-gcc /usr/local/bin/mips-linux-gcc \
    && ln -s /bin/${CROSS_COMPILE_ARCH}-linux-gnu-g++ /usr/local/bin/mips-linux-g++ \
    && ln -s /bin/${CROSS_COMPILE_ARCH}-linux-gnu-ld /usr/local/bin/mips-linux-ld \
    && ln -s /bin/${CROSS_COMPILE_ARCH}-linux-gnu-ar /usr/local/bin/mips-linux-ar

# Create and use developer user for safe development
RUN useradd -m -s /bin/bash developer \
    && mkdir -p /workspace \
    && chown developer:developer /workspace

USER developer
WORKDIR /workspace