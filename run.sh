#git status -u | grep "Instancesv2" |
#while read -r line; do
#      if [[ "${line}" != *"renamed"* && "${line}" != *"new file"* && "${line}" != *"deleted"* ]];then
#         git add "${line}"
#      fi
#done

function cache
{
      tail -n +1 ./.gitignore | 
      while read -r line; do
            git rm -r --cached "${line}"
      done
}

function update
{
      git add ./.gitignore
      git commit -m".gitignore updated"
}

"$@"