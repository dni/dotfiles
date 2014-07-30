for file in ~/.bash/.{bash_prompt,aliases}; do
	[ -r "$file" ] && source "$file"
done
export PATH='/usr/local/bin:/usr/bin'
