for file in ~/.bash/.{bash_prompt,aliases}; do
	[ -r "$file" ] && source "$file"
done
