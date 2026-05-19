#!/bin/bash

declare root_ref=$1
declare root_test=$2
declare ref=$3
declare test=$4
declare lb_ref=$5
declare lb_test=$6
declare enc_ref=$7
declare enc_test=$8

declare -g dotunkw_ref
declare -g dotunkw_test
declare -g imprv_ref
declare -g imprv_test
declare home_="./result"
declare utility="./experiments/aux0.sh"
declare task="./../Results_experiments/Task1/bounds.csv" 
declare fst_line="Encoding,Horizon,Problem,counter wrac1_y_wrbc1,counter wrbc1_b_wrcc1,counter wrcc1_x_wrdc1,counter wrdc1_b_wrec1,counter wrec1_y_wrfc1,Total,Diff"

function add_dot
{ 
    local dotcsv=$1
    local dotunkw_inst=$2

    tail -n +2 "${dotcsv}" | 
    while read -r line; do 
          echo "${line}" >> "${dotunkw_inst}"
    done
}

function is_there
{
    local -n _asp_output=$1
    local inst_=$2
 
    echo "${root_}/${inst_:2}"
    if  bash "${utility}" search3 "${root_},${root_}/${inst_:2}"; then
        _asp_output="${root_}/${inst_:2}" #;echo "${_asp_output}"
        return 0
    else
        return 1
    fi
}

function clean_file
{
    bash "${utility}" search3 ".,${dotunkw_ref}" && { rm -r "${dotunkw_ref}"; printf "${fst_line%',Diff'}"$'\n' > "${dotunkw_ref}"; } 
    bash "${utility}" search3 ".,${dotunkw_test}" && { rm -r "${dotunkw_test}"; printf "${fst_line%',Diff'}"$'\n' > "${dotunkw_test}"; } 
    bash "${utility}" search3 ".,${imprv_test}" && { rm -r "${imprv_test}"; printf "${fst_line}"$'\n' > "${imprv_test}"; }
    bash "${utility}" search3 ".,${imprv_ref}" && { rm -r "${imprv_ref}"; printf "${fst_line}"$'\n' > "${imprv_ref}"; }
}

function unknown
{
    local dotcsv=$1
    local dotunkw_inst=$2
    local label=$3
    local encoding=$4
    local asp_output
    local -i len

    local prefix="./Instancesv2_round/sippv2/"
    local len=${#prefix}
    if [[ "${encoding}" == "clingcon" ]]; then   
        for sufx in "random/" "sipp/" "sippv2/"; do
            tail -n +2 $task | 
            while IFS=',' read -r HORIZON PROBLEM MIN; do
                  if [[ "$PROBLEM" == *"_round"* ]]; then
                     problem="./Instancesv2_round/${sufx}${PROBLEM:len}" #;echo "${root_}/${home_:2}/${problem:2}_${label}_$HORIZON.txt"
                     is_there asp_output "${home_}/${problem:2}_${label}_$HORIZON.txt" &&
                     tail -n +1 "${asp_output}" | 
                     while read -r line; do    
                             if [[ "${line}" == *"UNKNOWN"* ]]; then
                                #echo "${asp_output}" >> "${unknown_inst}"
                                echo "${encoding},${HORIZON},${root_:3}${home_:1}${problem:1},,,,,,0" >> "${dotunkw_inst}"
                             fi
                     done
                  fi
            done
        done
    fi
    add_dot "${dotcsv}" "${dotunkw_inst}"
 
}

function improvement
{
    local asp_output
  
    tail -n +2 "${dotunkw_test}" | 
    while IFS=',' read -r ENC HOR PROBLEM l1 l2 l3 l4 l5 TOT; do
        tot1=$(echo "$TOT" | bc -l)
        tail -n +2 "${dotunkw_ref}" | 
        while IFS=',' read -r enc hor problem l1 l2 l3 l4 l5 tot; do
              if [[ "$PROBLEM" == "$problem" && "$HOR" == "$hor" ]]; then
                 tot2=$(echo "$tot" | bc -l)
                 diff=$(echo "$tot2 - $tot1" | bc -l)
                 if (( $(echo "$diff > 0" | bc -l) )); then 
                    echo "${enc},${hor},${problem},${l1},${l2},${l3},${l4},${l5},${tot},${diff}" >> "${imprv_ref}"
                 elif (( $(echo "$diff < 0" | bc -l) )); then 
                      diff=$(echo "- $diff" | bc -l)
                      echo "${ENC},${HOR},${PROBLEM},${l1},${l2},${l3},${l4},${l5},${TOT},${diff}" >> "${imprv_test}"
                 fi
             fi
        done
    done

    
 
}

function main
{
    dotunkw_ref="${ref%'_dot.csv'}_unkw.csv"
    dotunkw_test="${test%'_dot.csv'}_unkw.csv"
    imprv_ref="${ref%'_dot.csv'}_imprv.csv"
    imprv_test="${test%'_dot.csv'}_imprv.csv"
    clean_file

    root_="${root_ref}"
    unknown "${ref}" "${dotunkw_ref}" "${lb_ref}" "${enc_ref}"

    root_="${root_test}"
    unknown "${test}" "${dotunkw_test}" "${lb_test}" "${enc_test}"


    improvement
}

shopt -s lastpipe
main