for file in ~/.bash/.{bash_prompt,aliases}; do
	[ -r "$file" ] && source "$file"
done

export ANDROID_HOME=/usr/local/opt/android-sdk
# export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/share/npm/bin:$PATH
export ANDROID_HOME=/usr/local/Cellar/android-sdk/24.1.2/
export JAVA_HOME=/usr/
export DOCKER_HOST=tcp://192.168.59.104:2376
export DOCKER_CERT_PATH=/Users/dni/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1
