#!/bin/bash

# setup script for pulp-readers environment
# this script creates a virtual environment and installs requirements

set -e  # exit on error

ENV_NAME="pulp-readers"
REQUIREMENTS_FILE="requirements.txt"

echo "setting up ${ENV_NAME} env..."

# check if virtual environment already exists
if [ -d "${ENV_NAME}" ]; then
    echo "environment '${ENV_NAME}' already exists"
    read -p "do you want to remove it and create a new one? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "removing existing virtual environment..."
        rm -rf "${ENV_NAME}"
    else
        echo "keeping existing virtual environment."
        echo "to activate it, run: source ${ENV_NAME}/bin/activate"
        exit 0
    fi
fi

# check for python 3.12
echo "checking for python 3.12..."
if command -v python3.12 &> /dev/null; then
    PYTHON_CMD="python3.12"
    echo "found python3.12"
elif python3 --version | grep -q "3.12"; then
    PYTHON_CMD="python3"
    echo "found python 3.12 via python3"
else
    echo "warning: python 3.12 not found, using available python3"
    PYTHON_CMD="python3"
fi

# create virtual environment
echo "creating virtual environment '${ENV_NAME}' with ${PYTHON_CMD}..."
${PYTHON_CMD} -m venv "${ENV_NAME}"

# activate virtual environment
echo "activating virtual environment..."
source "${ENV_NAME}/bin/activate"

# upgrade pip
echo "upgrading pip..."
pip install --upgrade pip

# install requirements if the file exists and is not empty
if [ -f "${REQUIREMENTS_FILE}" ] && [ -s "${REQUIREMENTS_FILE}" ]; then
    echo "installing requirements from ${REQUIREMENTS_FILE}..."
    pip install -r "${REQUIREMENTS_FILE}"
else
    echo "no requirements to install (${REQUIREMENTS_FILE} is empty or doesn't exist)."
fi

echo ""
echo "setup completed successfully!"
echo ""
echo "to activate the environment, run:"
echo "  source ${ENV_NAME}/bin/activate"
echo ""
echo "to deactivate, run:"
echo "  deactivate"

