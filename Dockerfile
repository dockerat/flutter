ARG FLUTTER_HOME=/opt/google/flutter


FROM ghcr.io/cirruslabs/flutter:3.22.3 AS flutter

RUN rm -rf /sdks/flutter/dev
RUN rm -rf /sdks/flutter/examples

FROM bitnami/git:2.46.0 AS git


FROM ccr.ccs.tencentyun.com/storezhang/ubuntu:24.04.24 AS builder
ARG FLUTTER_HOME
COPY --from=flutter /sdks/flutter /docker/${FLUTTER_HOME}
COPY --from=git /opt/bitnami/git/bin/git /docker/usr/local/bin/git



FROM ccr.ccs.tencentyun.com/storezhang/ubuntu:24.04.24

LABEL author="storezhang<华寅>" \
    email="storezhang@gmail.com" \
    qq="160290688" \
    wechat="storezhang" \
    description="Flutter基础镜像，各个平台的打包应该再此基础上派生镜像"

COPY --from=builder /docker /

RUN set -ex \
    \
    \
    \
    && apt update -y \
    && apt upgrade -y \
    \
    # 安装依赖库
    && apt install -y unzip \
    \
    \
    \
    # 清理镜像，减少无用包
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && apt autoclean

# 执行命令
ENTRYPOINT ${FLUTTER_HOME}/bin/flutter

ARG FLUTTER_HOME

ENV FLUTTER_HOME ${FLUTTER_HOME}
ENV PATH=${FLUTTER_HOME}/bin:$PATH

ENV FLUTTER_STORAGE_BASE_URL https://storage.flutter-io.cn
ENV PUB_HOSTED_URL https://pub.flutter-io.cn
ENV FLUTTER_GIT_URL https://gitee.com/mirrors/Flutter.git

# 配置依赖包缓存路径
ENV FLUTTER_CACHE /var/lib/flutter
ENV PUB_CACHE ${FLUTTER_CACHE}/pub
