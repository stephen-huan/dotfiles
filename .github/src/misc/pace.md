# PACE

- project directory

```text
~/p-fschaefer7-0
```

- home directory

```text
/storage/home/hcoda1/6/shuan7
```

- scratch (temp)

```text
~/scratch
```

- [helpful commands](https://docs.pace.gatech.edu/gettingStarted/commands/)

## logging in

- need to run GT [VPN](https://docs.pace.gatech.edu/gettingStarted/vpn/)
  (GlobalProtect)
- [logging in](https://docs.pace.gatech.edu/phoenix_cluster/logon_phnx/):
- (kitty sets `$TERM` wrong)

```shell
TERM=xterm-color ssh shuan7@login-phoenix.pace.gatech.edu
```

- (GT password)
- to see headnodes

```shell
pace-whoami
```

## transferring files

- [transferring files](https://docs.pace.gatech.edu/storage/globus/)
- just use `scp`/`rsync`...

## submitting jobs

- [submitting jobs](https://docs.pace.gatech.edu/phoenix_cluster/slurm_guide_phnx/)
- account

```text
gts-fschaefer7
```

- see accounts

```shell
pace-quota
```

- see queue status

```shell
pace-check-queue -c inferno
```

- make
  [slurm](https://docs.pace.gatech.edu/phoenix_cluster/slurm_conversion_phnx/)
  file:

```bash
#!/bin/bash
#SBATCH -Jcknn-cg                 # job name
#SBATCH --account=gts-fschaefer7  # charge account
#SBATCH --nodes=1                 # number of nodes and cores per node required
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=22gb        # memory per core
#SBATCH -t48:00:00                # duration of the job (hh:mm:ss)
#SBATCH -qinferno                 # QOS name
#SBATCH -ojobs/cg_%j.out          # combined output and error messages file
cd $SLURM_SUBMIT_DIR              # change to working directory

# load modules
module load anaconda3

# enter conda virtual environment
conda activate ./venv

# run commands
lscpu
lsmem

time srun python -m experiments.cg
```

- submit job to scheduler (two queues: `inferno` and `embers`)

```bash
sbatch job.sbatch
```

- job inherits current directory, have to run `sbatch` from proper directory!

- submitted job status

```shell
squeue -u shuan7
```

## interactive session

- request [interactive session](https://docs.pace.gatech.edu/phoenix_cluster/slurm_guide_phnx/#interactive-jobs):

```bash
salloc -A gts-fschaefer7 -q inferno -N 1 --ntasks-per-node=4 -t 1:00:00
```

## software

### modules

- [modules](https://docs.pace.gatech.edu/software/modules/)

### conda

- [conda](https://docs.pace.gatech.edu/software/anacondaEnv/)
