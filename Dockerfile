FROM node:10-alpine

WORKDIR /opt

ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.2.5-linux.zip" \
    ANDROID_BUILD_TOOLS_VERSION=27.0.0 \
    ANDROID_APIS="android-27" \
    ANT_HOME="/usr/share/ant" \
    MAVEN_HOME="/usr/share/maven" \
    GRADLE_HOME="/usr/share/gradle" \
    ANDROID_HOME="/opt/android" \
    JAVA_HOME="/usr/bin/java"

ENV PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin:${PATH}"

RUN mkdir android
RUN apk --update add curl wget maven apache-ant gradle bash openjdk8 git && \
    wget -q -O android/tools.zip ${ANDROID_SDK_URL} && \
    apk del wget && \
    rm -rf /var/cache/apk/* && \
    unzip -q android/tools.zip -d android/ && rm android/tools.zip
RUN echo y | android update sdk -a -u -t platform-tools,${ANDROID_APIS},build-tools-${ANDROID_BUILD_TOOLS_VERSION}
RUN chmod a+x -R $ANDROID_HOME
RUN chown -R root:root $ANDROID_HOME
RUN npm i -g --unsafe-perm cordova ionic
