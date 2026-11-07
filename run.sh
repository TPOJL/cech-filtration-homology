#!/usr/bin/env bash
set -e

echo "Setting up virtual environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

source venv/bin/activate

echo "Installing TDA & Convex Optimization dependencies..."
pip install --upgrade pip -q
pip install -r requirements.txt -q

echo "Launching Jupyter Notebook (TAO_projekt.ipynb)..."
jupyter notebook TAO_projekt.ipynb
