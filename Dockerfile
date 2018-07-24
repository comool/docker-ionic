FROM alpine:3.8

ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.2.5-linux.zip" \
    ANDROID_BUILD_TOOLS_VERSION=27.0.0 \
    ANDROID_APIS="android-27" \
    ANT_HOME="/usr/share/ant" \
    MAVEN_HOME="/usr/share/maven" \
    GRADLE_HOME="/usr/share/gradle" \
    ANDROID_HOME="/opt/android" \
    JAVA_HOME="/usr/bin/java"

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin

RUN apk --update add wget curl maven apache-ant gradle bash openjdk8 nodejs nodejs-npm

WORKDIR /opt

RUN mkdir android && cd android
RUN wget -q -O tools.zip ${ANDROID_SDK_URL}
RUN unzip -q tools.zip && rm tools.zip
RUN mv tools android/
RUN echo y | android/tools/android update sdk -a -u -t platform-tools,${ANDROID_APIS},build-tools-${ANDROID_BUILD_TOOLS_VERSION}
RUN chmod a+x -R $ANDROID_HOME
RUN chown -R root:root $ANDROID_HOME
RUN npm i -g --unsafe-perm cordova ionic
