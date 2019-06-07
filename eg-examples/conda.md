# Create an env from scratch
    conda create --name envname

# Create from an env file
    conda env create -f environment.yml

# List all packages installed in this conda env
    conda list

# List all conda envs on this system
    conda env list

# Activating an environment
    conda activate envname

# Deactivating an environment
    conda deactivate
- For conda versions prior to 4.6, use 'source activate/deactivate'

# Delete an environment
    conda env remove --name envname

