# 🧠 SliceMAE: Brain Tumor Segmentation from MRI Using 2D Slice-Based MAE-UNet

> **Capstone Project — CSE 400C | East West University, Dhaka, Bangladesh | April 2026**  
> Supervised by **Dr. Anisur Rahman**, Associate Professor, Dept. of CSE

---

## 📌 Overview

Brain tumor segmentation is a critical yet time-consuming task in neuro-oncology. Manual delineation by radiologists takes **1–2 days per patient** and is prone to inconsistency. This project proposes **SliceMAE**, a self-supervised learning (SSL) framework that combines **Masked Autoencoder (MAE) pre-training** with a **U-Net segmentation decoder** to achieve accurate, data-efficient brain tumor segmentation from multimodal MRI scans.

We benchmarked **8 models** (4 supervised + 4 SSL-based) on the **BraTS2020 dataset** and deployed a full web-based clinical prototype called **NeuroScan**.

---

## 🏆 Key Results

| Model | Type | Overall Dice (%) |
|-------|------|-----------------|
| U-Net | Supervised | 83.93 |
| ViT | Supervised | 82.45 |
| UNETR | Supervised | 75.71 |
| TransUNet | Supervised | 83.43 |
| MAE-ViT | SSL | 81.55 |
| MAE-UNETR | SSL | 84.43 |
| DenseCL-ViT | SSL | 78.00 |
| **MAE-UNet (SliceMAE)** | **SSL** | **88.23 ✅ Best** |

### MAE-UNet vs Supervised U-Net — Sub-Region Performance

| Sub-Region | U-Net | MAE-UNet | Gain |
|------------|-------|----------|------|
| Necrotic Core | 76.10% | 80.63% | +4.53% |
| Peritumoral Edema | 81.86% | 93.44% | +11.58% |
| Enhancing Tumor | 78.00% | 97.58% | +19.58% |
| **Overall Dice** | **83.93%** | **88.23%** | **+4.30%** |

---

## 🏗️ Architecture

SliceMAE uses a **two-stage pipeline**:

**Stage 1 — MAE Pre-training (Unsupervised)**
- Input: 2D MRI slices (128×128×4 multimodal)
- 75% of image patches randomly masked
- Encoder: 6 Transformer blocks learn to reconstruct masked regions
- Forces the model to learn rich brain anatomy representations **without labels**

**Stage 2 — U-Net Fine-tuning (Supervised)**
- Pre-trained encoder weights transferred to U-Net
- Decoder: symmetric skip connections for precise boundary segmentation
- Trained on labeled BraTS2020 data with Dice + Cross-Entropy loss

---

## 📂 Dataset

**BraTS 2020** — Brain Tumor Segmentation Challenge Dataset

| Detail | Value |
|--------|-------|
| Total Subjects | 494 patients |
| Training Set | 369 patients (with masks) |
| Validation Set | 125 patients |
| MRI Modalities | T1, T1ce, T2, FLAIR |
| Tumor Classes | Background, Necrotic Core, Peritumoral Edema, Enhancing Tumor |

📥 Dataset available at: [Kaggle BraTS2020](https://www.kaggle.com/datasets/awsaf49/brats20-dataset-training-validation)

---

## 🛠️ Technologies Used

| Category | Tools |
|----------|-------|
| Deep Learning | Python, PyTorch, TensorFlow 2.12, Keras |
| Medical Imaging | NiBabel, OpenCV, NumPy |
| Web Backend | Flask, Docker |
| Web Frontend | HTML5, CSS3, JavaScript, Three.js |
| SSL Methods | Masked Autoencoder (MAE), DenseCL |
| Models | U-Net, ViT, UNETR, TransUNet |
| Deployment | Hugging Face Spaces |
| Report Generation | jsPDF |

---

## 🌐 Live Demo — NeuroScan

A web-based clinical decision support prototype built on the MAE-UNet model.

**Features:**
- 🔬 Upload multimodal MRI (.nii files) or PNG/JPG images
- 🎯 Real-time tumor segmentation with color-coded overlays
- 📊 Per-class volumetric measurements (cm³)
- 🔄 Interactive 3D tumor reconstruction (Three.js)
- 📋 Automated clinical PDF report generation
- 🏥 Rule-based clinical decision support (WHO 2021 guidelines)

🔗 **Live App:** [https://huggingface.co/spaces/ratulpodder/neuroscan](https://huggingface.co/spaces/ratulpodder/neuroscan)

---

## ⚙️ Training Configuration

| Parameter | Supervised Models | SSL Models |
|-----------|------------------|-----------|
| Optimizer | Adam | Adam |
| Input Size | 128×128 | 128×128 |
| Loss Function | Dice + CrossEntropy | Dice + CrossEntropy |
| Batch Size | 8/16 | Pre-train: 32 / Fine-tune: 16 |
| Epochs | 50 | Pre-train: 100 / Fine-tune: 50 |
| Learning Rate | 0.0001 | 0.0001 |
| Early Stopping | Yes (patience=10) | Yes (patience=10) |
| Mask Ratio | — | 75% |

---

## 👩‍💻 Team

| Student ID | Name |
|------------|------|
| 2022-1-60-252 | **Faria Azad Anita** |
| 2022-1-60-067 | Ratul Podder |
| 2022-1-60-073 | Erin Dewan Oishe |
| 2022-1-60-082 | Prioti Kar Tithy |

**Supervisor:** Dr. Anisur Rahman, Associate Professor & Proctor, Dept. of CSE, East West University

---

## 📄 Report

The full capstone project report was submitted to the Department of Computer Science & Engineering, East West University, Dhaka, Bangladesh on 16th April 2026.


---

## ⚠️ Disclaimer

NeuroScan is a **research tool only** and is **not intended for clinical diagnosis**. All treatment decisions must be made by a qualified neuro-oncologist with full clinical context.

---

<p align="center">Made with ❤️ at East West University, Dhaka, Bangladesh</p>
