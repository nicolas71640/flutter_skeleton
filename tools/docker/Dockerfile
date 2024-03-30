FROM ubuntu:22.04

ENV ANDROID_STUDIO_HOME /home/builder/android-studio
ENV ANDROID_HOME /home/builder/android
ENV FLUTTER_HOME /home/builder/flutter
ENV ANDROID_USER_HOME /home/builder/.android

ENV PATH "${PATH}:${FLUTTER_HOME}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools"
ENV JDK_HOME /usr/lib/jvm/openjdk-17

RUN apt-get update && \
    apt-get install -y bash file git unzip xz-utils zip wget openjdk-17-jdk clang cmake ninja-build pkg-config libgtk-3-dev curl gpg jq sudo libpulse0 tightvncserver iputils-ping gawk

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb &&  \
    dpkg -i /tmp/chrome.deb || \
    apt-get install -fy 

#Bitwarden
RUN curl -L "https://vault.bitwarden.com/download/?app=cli&platform=linux" -o /tmp/bw.zip 
RUN unzip /tmp/bw.zip && mv bw /bin  && rm /tmp/bw.zip

# Create user builder.
RUN useradd -m builder && \
    usermod --shell /bin/bash builder && \
    usermod -aG sudo builder && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/builder && \
    chmod 0440 /etc/sudoers.d/builder && \
    sed -i "s|^#force_color_prompt=.*|force_color_prompt=yes|" /home/builder/.bashrc

# Define use
USER builder


RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.4-stable.tar.xz -O /tmp/flutter.tar.xz && \
    mkdir -p ${FLUTTER_HOME} && \
    tar xf /tmp/flutter.tar.xz -C ${FLUTTER_HOME} --strip-components=1

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/commandlinetools.zip && \
    mkdir -p ${ANDROID_HOME}/cmdline-tools/latest && \
    unzip /tmp/commandlinetools.zip -d /tmp/extract && \    
    mv /tmp/extract/cmdline-tools/* ${ANDROID_HOME}/cmdline-tools/latest

RUN wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.2.1.20/android-studio-2022.2.1.20-linux.tar.gz -O /tmp/android-studio.tar.gz && \
    mkdir -p ${ANDROID_STUDIO_HOME} && \
    tar xf /tmp/android-studio.tar.gz -C ${ANDROID_STUDIO_HOME} --strip-components=1 && \
    cp -r ${ANDROID_STUDIO_HOME}/jbr ${ANDROID_STUDIO_HOME}/jre


#Accept licences
RUN yes | sdkmanager --licenses && yes | sdkmanager --update
RUN sdkmanager \
    "tools" \
    "platform-tools" \
    "emulator"

RUN sdkmanager "build-tools;30.0.3"
RUN sdkmanager "platforms;android-31"
RUN sdkmanager "platforms;android-32"
RUN sdkmanager "platforms;android-33"
RUN sdkmanager "platforms;android-34"
RUN sdkmanager "system-images;android-34;google_apis;x86_64"

RUN flutter precache

RUN flutter doctor -v

