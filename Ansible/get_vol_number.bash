#Bash script created by the AskF5 team for K89192130.
#Determines the next available volume set number to use
#for a new BIG-IP software installation.
#Requires that volume set use a number and not a name.

OLDIFS="$IFS"
IFS=$'\n'
disk=$(tmsh show sys sof status | awk '/.D[1-9]/{print substr($1,1,4)}' | head -n1)
maxvnumber=0
for vnumber in $(tmsh show sys sof status | grep complete)
    do
        vnumber=${vnumber:4:2}
        vnumber=${vnumber// /}
        if (( vnumber > maxvnumber )); then
            maxvnumber=$vnumber
        fi
done
volume=$disk$((maxvnumber + 1))
echo -n $volume
IFS="$OLDIFS"