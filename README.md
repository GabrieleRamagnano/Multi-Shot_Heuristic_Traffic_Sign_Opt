# Multi-shot Solving and Domain Heuristics for CASP-based Traffic Signal Optimisation
### Requirements
- [Clingcon](https://potassco.org/clingcon/)
- [Java](https://www.java.com/en/download/manual.jsp): to run [enhsp](https://sites.google.com/view/enhsp/) and [pps](https://github.com/hstairs/pps) (compiled files are in ./bin)


### Parse pddl domains into asp instances 
```
python extract_instances.py [Directory_with_pddl_files]
```
Example
```
python extract_instances.py ./Test
```

### Run clingcon with Heuristic Domain
```
clingcon instance_fixed.lp enc_clingcon.lp [Heuristic_encoding] [ASP_instance] --const horizon=[horizon] --const bound=[cars_bound] --config=crafty --heuristic=Domain
```
Example
```
clingcon instance_fixed.lp enc_clingcon.lp ./heu_hphase ./Test/p01[count=350].lp --const horizon=600 --const bound=1000000 --config=crafty --heuristic=Domain
```
Note: 1000000 stands for 10.00000

## Run experiments 

### Heuristic Experiment (without PDDL+) 
It is possible to run these type of experiments using
```
bash ./run_experiment.sh
```
See `./heuristic/experiments/how_to_run.md` for an example of execution.

### Heuristic Bound Experiment (with PDDL+) 
The scripts to run these experiments are in the subdirectories `./pddl_cafe`,`./pddl_combo`,`./pddl_minus` located in `./heuristic/experiments/`. 

```
combine_pddl_clingcon.sh [Directory]
```

```
combine_pddl_hlink.sh [Directory]
```

### Extra 
The **aggregated conuter** results of each experiment are in their corresponding subdirectory
```
./heuristic/experiments/[name-test]/result
```
The comparison of **improvements** of some results can be found in the corresponding subdirectory
```
./heuristic/experiments/Improvement_results
```
