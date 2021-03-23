# Create an env from scratch
    conda create --name envname

# Create an env with specific python version
    conda create -n envname python=3.8

# Create from an env file
    conda env create -f environment.yml

# Save current env to file
    conda env export > environment.yml

# List all packages installed in this conda env
    conda list

# Install a package (in the current env)
    conda install <package-name>

# Uninstall a package (in the current env)
    conda remove <package-name>

# List all conda envs on this system
    conda env list

# Activating an environment
    conda activate envname

# Deactivating an environment
    conda deactivate
- For conda versions prior to 4.6, use 'source activate/deactivate'

# Delete an environment
    conda env remove --name envname

