# Multi-shot Solving and Domain Heuristics for CASP-based Traffic Signal Optimisation
### Requirements
- [Clingcon](https://potassco.org/clingcon/)
- [Java](https://www.java.com/en/download/manual.jsp): to run [enhsp](https://sites.google.com/view/enhsp/) and [pps](https://github.com/hstairs/pps) (compiled files are in ./bin)


### Parse pddl domains into asp instances 
```
python extract_instances.py [Directory_with_pddl_files]
```

This is specific for the **random** instances contained in `./heuristic/experiments/Instancesv2_round/random/` 
```
python extract_instances_rnd.py [Directory_with_pddl_files]
```

Example
```
python extract_instances.py ./Test
```

### Run multi-shot
```
python multishot/multi-shot.py <enc_file> <instance_files...> [--horizon HORIZON] [--bound BOUND] [--lim LIM] [--shot_duration SHOT_DURATION] [--models_per_shot MODELS_PER_SHOT] [--stats]
```
Example
```
python multishot/multi-shot.py multishot/enc_multishot.lp ./Test/p01[count=350].lp multishot/instance_fixed.lp --horizon 900 --shot_duration 100
```

### Run Heuristic Domain
```
clingcon instance_fixed.lp enc_clingcon.lp <Heuristic_encoding> <ASP_instance> --const horizon=[horizon] --const bound=[PCU_bound] --config=crafty --heuristic=Domain
```
Example
```
clingcon instance_fixed.lp enc_clingcon.lp ./heu_hphase ./Test/p01[count=350].lp --const horizon=600 --const bound=1000000 --config=crafty --heuristic=Domain
```
Note: 1000000 stands for 10.00000

#### Heuristic Experiment (without PDDL+) 
It is possible to run these type of experiments using
```
bash ./run_experiment.sh
```
See `./heuristic/experiments/how_to_run.md` for an example of execution.
To apply the conversion from 1000000 to 10.00000:
```
python ./dot_conversion.py <csv-file> <experiment-label>
```
Example
```
python ./dot_conversion.py ./test/result_OPT_clingcon.csv OPT_clingcon
```
To compute the aggregated results for a given time horizon (`key = ""`)
```
python ./aggregate_horizon.py <csv-reference> <csv-test> <name-reference> <name-test> <horizon> <key> <encoding-reference> <encoding-test>
```

Example
```
python ./aggregate_horizon.py ./test/result_cafe_dot.csv ./test/result_OPT_hlink_dot.csv cafe link 600 "" cafe clingcon
```
The parameter **key** is used to aggregate for a specific instance over the same horizon:

Example
```
python ./aggregate_horizon.py ./test/result_cafe_dot.csv ./test/result_OPT_hlink_dot.csv cafe link 600 p02 cafe clingcon
```

#### Heuristic Bound Experiment (with PDDL+) 
The scripts to run these experiments are in the subdirectories `./pddl_cafe`,`./pddl_combo`,`./pddl_minus` located in `./heuristic/experiments/`. 

```
combine_pddl_clingcon.sh [Directory]
```

```
combine_pddl_hlink.sh [Directory]
```
To calculate the improvement run
```
bash ./compute_improvement.sh <reference-dir> <test-dir>  <reference-csv> <test-csv> <reference-label> <test-label> <reference-encoding> <test-encoding>
```
Example
```
bash ./compute_improvement.sh ./experiments/heu_105 ./experiments/heu_105 ./test/result_cafe_dot.csv  ./test/result_OPT_hlink_dot.csv cafe OPT_hplink cafe clingcon
```

#### Results
The **aggregated conuter** results of each experiment are in their corresponding subdirectory
```
./heuristic/experiments/[name-test]/result/
```
The comparison of **improvements** of some results can be found in the corresponding subdirectory
```
./heuristic/experiments/Improvement_results/
```
