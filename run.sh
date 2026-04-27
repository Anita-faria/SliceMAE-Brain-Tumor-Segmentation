#!/bin/bash

set -e
PYTHON310="/opt/homebrew/bin/python3.10"
VENV="venv"

echo ""
echo "  ███╗   ██╗███████╗██╗   ██╗██████╗  ██████╗ "
echo "  ████╗  ██║██╔════╝██║   ██║██╔══██╗██╔═══██╗"
echo "  ██╔██╗ ██║█████╗  ██║   ██║██████╔╝██║   ██║"
echo "  ██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██║   ██║"
echo "  ██║ ╚████║███████╗╚██████╔╝██║  ██║╚██████╔╝"
echo "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ "
echo "  Brain Tumour Segmentation · BraTS2020 · U-Net"
echo ""

# ── Step 1: Find Python 3.10 ──────────────────────────────────────────────────
echo "▸ Checking Python 3.10..."

if [ -f "$PYTHON310" ]; then
    PY=$PYTHON310
elif command -v python3.10 &>/dev/null; then
    PY=$(command -v python3.10)
else
    echo ""
    echo "  ✖ Python 3.10 not found!"
    echo "  Install it with: brew install python@3.10"
    echo "  Then re-run this script."
    exit 1
fi

echo "  ✔ Found: $PY ($($PY --version))"

# ── Step 2: Create venv if missing or wrong Python ────────────────────────────
NEED_SETUP=0

if [ ! -d "$VENV" ]; then
    echo "▸ Creating virtual environment..."
    $PY -m venv $VENV
    NEED_SETUP=1
else
    VENV_VER=$($VENV/bin/python --version 2>&1)
    if [[ "$VENV_VER" != *"3.10"* ]]; then
        echo "▸ Wrong Python in venv ($VENV_VER) — recreating with 3.10..."
        rm -rf $VENV
        $PY -m venv $VENV
        NEED_SETUP=1
    else
        echo "  ✔ Virtual environment OK ($VENV_VER)"
    fi
fi

# ── Step 3: Install packages if fresh venv ────────────────────────────────────
if [ $NEED_SETUP -eq 1 ]; then
    echo "▸ Installing packages (3-5 min on first run)..."
    $VENV/bin/pip install --upgrade pip -q
    $VENV/bin/pip install "numpy<2" -q
    $VENV/bin/pip install tensorflow-macos==2.12.0 tensorflow-metal==0.8.0 -q
    $VENV/bin/pip install flask opencv-python-headless Pillow matplotlib nibabel -q
    echo "  ✔ All packages installed"
else
    # Fix numpy if pip upgraded it to 2.x
    NUMPY_VER=$($VENV/bin/python -c "import numpy; print(numpy.__version__)" 2>/dev/null || echo "missing")
    if [[ "$NUMPY_VER" == "missing" || "$NUMPY_VER" == 2* ]]; then
        echo "▸ Fixing NumPy (found v$NUMPY_VER, need <2)..."
        $VENV/bin/pip install "numpy<2" -q
        echo "  ✔ NumPy fixed"
    else
        echo "  ✔ NumPy OK (v$NUMPY_VER)"
    fi
fi

# ── Step 4: Check model file ──────────────────────────────────────────────────
if [ -f "best_unet_model.h5" ]; then
    SIZE=$(du -sh best_unet_model.h5 | cut -f1)
    echo "  ✔ Model found (best_unet_model.h5 · $SIZE)"
else
    echo "  ⚠  best_unet_model.h5 not found — running in DEMO mode"
fi

# ── Step 5: Launch app ────────────────────────────────────────────────────────
echo ""
echo "  → Open http://127.0.0.1:5001 in your browser"
echo "  → Press Ctrl+C to stop"
echo ""

$VENV/bin/python app.py
