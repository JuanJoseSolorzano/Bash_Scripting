# Bash Scripting

## Overview
#test only
This folder contains various Bash scripts for automation, system tasks, and other utilities. Each script is designed to perform a specific function, and they can be used individually or combined to create more complex workflows.
The main goal of this is practicing the bash scripting.

## Scripts

### 1. `start-config`

This script is used to configure and install necessary packages for Arduino development. It installs `arduino-mk` and `screen`, creates necessary directories, and sets up a Makefile for Arduino projects.

#### Usage

1. Give execution permissions to the script:
    ```sh
    chmod +x start-config
    ```

2. Execute the script:
    ```sh
    sudo ./start-config
    ```
    or
    ```sh
    sudo bash start-config
    ```

### 2. `backup.sh`

This script creates a backup of specified directories and saves them to a designated backup location.

#### Usage

1. Open the script and set the `SOURCE_DIRS` and `BACKUP_DIR` variables.
2. Give execution permissions to the script:
    ```sh
    chmod +x backup.sh
    ```

3. Execute the script:
    ```sh
    ./backup.sh
    ```

### 3. `cleanup.sh`

This script cleans up temporary files and directories to free up disk space.

#### Usage

1. Open the script and set the `TEMP_DIRS` variable.
2. Give execution permissions to the script:
    ```sh
    chmod +x cleanup.sh
    ```

3. Execute the script:
    ```sh
    ./cleanup.sh
    ```

### 4. `monitor.sh`

This script monitors system resources such as CPU and memory usage and logs the information to a file.

#### Usage

1. Open the script and set the `LOG_FILE` variable.
2. Give execution permissions to the script:
    ```sh
    chmod +x monitor.sh
    ```

3. Execute the script:
    ```sh
    ./monitor.sh
    ```

## Contributing

If you would like to contribute to this collection of Bash scripts, please fork the repository and submit a pull request with your changes. Make sure to follow the coding standards and include appropriate documentation.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

## Contact

For any questions or inquiries, please contact the project maintainer at [juanjose.solorzano.c@gmail.com](mailto:juanjose.solorzano.c@gmail.com).
