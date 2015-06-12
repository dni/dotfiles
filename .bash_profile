for file in ~/.bash/.{bash_prompt,aliases}; do
	[ -r "$file" ] && source "$file"
done
# export PATH='/usr/local/bin:/usr/bin'
# export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/share/npm/bin:$PATH
export ANDROID_HOME=/usr/local/Cellar/android-sdk/24.1.2/
export JAVA_HOME=/usr/
