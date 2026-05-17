git status -u | grep "Instancesv2" |
while read -r line; do
      if [[ "${line}" != *"renamed"* && "${line}" != *"new file"* && "${line}" != *"deleted"* ]];then
         git add "${line}"
      fi
done