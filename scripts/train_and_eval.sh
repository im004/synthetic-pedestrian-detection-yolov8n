#!/usr/bin/env bash
#
# FYP – YOLOv8n synthetic vs real pedestrian detection
# Reproducible training & evaluation commands for the 5 final conditions
# Repository note: minor shell syntax cleanup applied to preserve reproducibility.
# Imran Mohamed, BEng Electronic & Electrical Engineering, 2026
#
# Assumptions:
# - Ultralytics YOLO installed (`pip install ultralytics`)
# - Working dirs and data.yaml files match paths below
# - All runs are CPU-only on Apple M2, Ultralytics 8.3.249, PyTorch 2.8.0
#
# Global augmentation (implicit defaults for all runs):
#   auto_augment=randaugment
#   hsv_h=0.015 hsv_s=0.7 hsv_v=0.4
#   fliplr=0.5 flipud=0.0
#   erasing=0.4
#   mosaic=1.0 close_mosaic=10
#   mixup=0.0 cutmix=0.0 copypaste=0.0
#   translate=0.1 scale=0.5 shear=0.0 perspective=0.0
#   epochs=50 batch=4 imgsz=640 deterministic=True device=cpu
#
# Metrics reported in dissertation are always on the same
# 441‑image real validation split (data.yaml in yolo_dir_ped).
# ---------------------------------------------------------------


# =========================
# Condition 1 – Real‑only baseline (C1)
# =========================
# Train YOLOv8n on filtered real images only.
# Project root: ~/Downloads/yolo_dir_ped
# data.yaml: train=real train set, val=real validation set

cd ~/Downloads/yolo_dir_ped

yolo detect train \
  model=yolov8n.pt \
  data=data.yaml \
  imgsz=640 \
  epochs=50 \
  batch=4 \
  auto_augment=randaugment \
  hsv_h=0.015 hsv_s=0.7 hsv_v=0.4 \
  fliplr=0.5 flipud=0.0 \
  erasing=0.4 \
  mosaic=1.0 \
  translate=0.1 scale=0.5 shear=0.0 perspective=0.0 \
  name=realonly50ep

# (Optional) explicit validation to regenerate final metrics/plots
yolo detect val \
  model=~/Downloads/yolo_dir_ped/runs/detect/realonly50ep/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  plots=True \
  name=realonly50ep_full_plots



# =========================
# Condition 2 – Synthetic‑only (C2)
# =========================
# Train only on synthetic combo (SYNTHIA‑PANO + CARLA),
# evaluate on the same real validation split used above.
#
# Project root for synthetic combo dataset:
#   ~/Downloads/synth_combo
# synth_combo/data.yaml:
#   train=synthetic combo images
#   val=real validation images (yolo_dir_ped/valid/images)

# ---------- training (synthetic domain) ----------
cd ~/Downloads/synth_combo

yolo detect train \
  model=yolov8n.pt \
  data=data.yaml \
  imgsz=640 \
  epochs=50 \
  batch=4 \
  auto_augment=randaugment \
  hsv_h=0.015 hsv_s=0.7 hsv_v=0.4 \
  fliplr=0.5 flipud=0.0 \
  erasing=0.4 \
  mosaic=1.0 \
  translate=0.1 scale=0.5 shear=0.0 perspective=0.0 \
  name=synth_combo_50ep_small150

# ---------- evaluation on real validation split ----------
cd ~/Downloads/yolo_dir_ped

yolo detect val \
  model=/Users/imranmohamed/Downloads/synth_combo/runs/detect/synth_combo_50ep_small150/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  name=synth_combo_to_real_50ep_small150

# (Optional) with full PR/F1/confusion plots
yolo detect val \
  model=/Users/imranmohamed/Downloads/synth_combo/runs/detect/synth_combo_50ep_small150/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  plots=True \
  name=synthonly_full_plots



# =========================
# Condition 3 – 50/50 mixed (C3)
# =========================
# Train on a 50/50 mix of real+synthetic (symbolic links),
# then evaluate on the same real validation split.

# ---------- training (50/50 mix) ----------
cd ~/Downloads/real_synth_5050

# real_synth_5050/data.yaml:
#   train = 2,500 real + 2,500 synthetic images (balanced)
#   val   = real validation images (441)

yolo detect train \
  model=yolov8n.pt \
  data=data.yaml \
  imgsz=640 \
  epochs=50 \
  batch=4 \
  auto_augment=randaugment \
  hsv_h=0.015 hsv_s=0.7 hsv_v=0.4 \
  fliplr=0.5 flipud=0.0 \
  erasing=0.4 \
  mosaic=1.0 \
  translate=0.1 scale=0.5 shear=0.0 perspective=0.0 \
  name=real_synth_5050_50ep_small150

# ---------- evaluation on real validation split ----------
cd ~/Downloads/yolo_dir_ped

yolo detect val \
  model=/Users/imranmohamed/Downloads/real_synth_5050/runs/detect/real_synth_5050_50ep_small150/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  name=real_synth_5050_to_real_50ep_small150

# (Optional) with full plots
yolo detect val \
  model=/Users/imranmohamed/Downloads/real_synth_5050/runs/detect/real_synth_5050_50ep_small150/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  plots=True \
  name=5050_full_plots



# =========================
# Condition 4 – 70:30 real‑dominated mix (C4)
# =========================
# All 2,500 real images + 750 synthetic (30%) as symlinks.
# This is the best-performing data‑level strategy.

# ---------- training (70:30 mix) ----------
cd ~/Downloads/real_plus_syn30

# real_plus_syn30/data.yaml:
#   train = all real + 30% extra synthetic
#   val   = real validation images (441)

yolo detect train \
  model=yolov8n.pt \
  data=data.yaml \
  imgsz=640 \
  epochs=50 \
  batch=4 \
  auto_augment=randaugment \
  hsv_h=0.015 hsv_s=0.7 hsv_v=0.4 \
  fliplr=0.5 flipud=0.0 \
  erasing=0.4 \
  mosaic=1.0 \
  translate=0.1 scale=0.5 shear=0.0 perspective=0.0 \
  name=real_plus_syn30_50ep_small150

# ---------- evaluation on real validation split ----------
cd ~/Downloads/yolo_dir_ped

# minimal eval (metrics only)
yolo detect val \
  model=/Users/imranmohamed/Downloads/real_plus_syn30/runs/detect/real_plus_syn30_50ep_small150/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  name=7030_mixed_full

# full plots (PR, F1, confusion matrix) used in figures
yolo detect val \
  model=/Users/imranmohamed/Downloads/real_plus_syn30/runs/detect/real_plus_syn30_50ep_small150/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  plots=True \
  name=7030_mixed_full_plots



# =========================
# Condition 5 – Synthetic pretrain → real fine‑tune (C5)
# =========================
# Stage 1: train on synthetic combo only (as in C2, but only
#          synthetic used for both train and val in that folder).
# Stage 2: initialise from Stage‑1 best.pt and fine‑tune
#          for 50 epochs on the real dataset (same data.yaml as C1).

# ---------- Stage 1 – synthetic pretraining ----------
cd ~/Downloads/synth_combo

# (this is logically the same as C2 training; if already run, reuse)
yolo detect train \
  model=yolov8n.pt \
  data=data.yaml \
  imgsz=640 \
  epochs=50 \
  batch=4 \
  auto_augment=randaugment \
  hsv_h=0.015 hsv_s=0.7 hsv_v=0.4 \
  fliplr=0.5 flipud=0.0 \
  erasing=0.4 \
  mosaic=1.0 \
  translate=0.1 scale=0.5 shear=0.0 perspective=0.0 \
  name=synth_combo_50ep_small150

# best synthetic checkpoint:
#   ~/Downloads/synth_combo/runs/detect/synth_combo_50ep_small150/weights/best.pt


# ---------- Stage 2 – fine‑tune on real ----------
cd ~/Downloads/yolo_dir_ped

yolo detect train \
  model=/Users/imranmohamed/Downloads/synth_combo/runs/detect/synth_combo_50ep_small150/weights/best.pt \
  # real-only data.yaml from C1
  data=data.yaml \
  imgsz=640 \
  epochs=50 \
  batch=4 \
  auto_augment=randaugment \
  hsv_h=0.015 hsv_s=0.7 hsv_v=0.4 \
  fliplr=0.5 flipud=0.0 \
  erasing=0.4 \
  mosaic=1.0 \
  translate=0.1 scale=0.5 shear=0.0 perspective=0.0 \
  name=finetunesynthcombotoreal50ep

# ---------- final evaluation + plots on real validation ----------
yolo detect val \
  model=/Users/imranmohamed/Downloads/yolo_dir_ped/runs/detect/finetunesynthcombotoreal50ep/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  name=finetunesynthcombotoreal50ep_eval

yolo detect val \
  model=/Users/imranmohamed/Downloads/yolo_dir_ped/runs/detect/finetunesynthcombotoreal50ep/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  plots=True \
  name=pretrain_finetune_full_plots



# =========================
# Optional: one‑shot full‑plots for all five conditions
# (re‑generate PR / F1 curves and confusion matrices)
# =========================
cd ~/Downloads/yolo_dir_ped

# C1 real‑only
yolo detect val \
  model=/Users/imranmohamed/Downloads/yolo_dir_ped/runs/detect/realonly50ep/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  plots=True \
  name=realonly_full_plots

# C2 synthetic‑only
yolo detect val \
  model=/Users/imranmohamed/Downloads/synth_combo/runs/detect/synth_combo_50ep_small150/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  plots=True \
  name=synthonly_full_plots

# C3 50/50 mix
yolo detect val \
  model=/Users/imranmohamed/Downloads/real_synth_5050/runs/detect/real_synth_5050_50ep_small150/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  plots=True \
  name=5050_full_plots

# C4 70:30 mix
yolo detect val \
  model=/Users/imranmohamed/Downloads/real_plus_syn30/runs/detect/real_plus_syn30_50ep_small150/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  plots=True \
  name=7030_mixed_full_plots

# C5 pretrain+finetune
yolo detect val \
  model=/Users/imranmohamed/Downloads/yolo_dir_ped/runs/detect/finetunesynthcombotoreal50ep/weights/best.pt \
  data=data.yaml \
  imgsz=640 \
  plots=True \
  name=pretrain_finetune_full_plots

# =========================
# Mixed dataset builders
# =========================

REAL=~/Downloads/yolo_dir_ped
SYNTH=~/Downloads/synth_combo
MIX5050=~/Downloads/real_synth_5050
MIX7030=~/Downloads/real_plus_syn30
SEED=42

make_yaml () {
  cat > "$1/data.yaml" <<EOF
path: $1
train: images/train
val: images/val
names:
  0: person
EOF
}

reset_mix () {
  rm -rf "$1"
  mkdir -p "$1/images/train" "$1/labels/train" "$1/images/val" "$1/labels/val"
}

link_split () {
  src_img="$1"; src_lbl="$2"; dst_img="$3"; dst_lbl="$4"
  while IFS= read -r img; do
    base="$(basename "$img")"
    stem="${base%.*}"
    ln -s "$img" "$dst_img/$base"
    [ -f "$src_lbl/$stem.txt" ] && ln -s "$src_lbl/$stem.txt" "$dst_lbl/$stem.txt"
  done < <(find "$src_img" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort)
}

sample_and_link () {
  src_img="$1"; src_lbl="$2"; dst_img="$3"; dst_lbl="$4"; n="$5"
  find "$src_img" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort | shuf -n "$n" | while read -r img; do
    base="$(basename "$img")"
    stem="${base%.*}"
    ln -s "$img" "$dst_img/$base"
    [ -f "$src_lbl/$stem.txt" ] && ln -s "$src_lbl/$stem.txt" "$dst_lbl/$stem.txt"
  done
}

# C3: 50/50 = 2500 real + 2500 synthetic
reset_mix "$MIX5050"
sample_and_link "$REAL/images/train"  "$REAL/labels/train"  "$MIX5050/images/train" "$MIX5050/labels/train" 2500
sample_and_link "$SYNTH/images/train" "$SYNTH/labels/train" "$MIX5050/images/train" "$MIX5050/labels/train" 2500
link_split "$REAL/images/val" "$REAL/labels/val" "$MIX5050/images/val" "$MIX5050/labels/val"
make_yaml "$MIX5050"

# C4: 70:30 = all real + 750 synthetic
reset_mix "$MIX7030"
link_split "$REAL/images/train" "$REAL/labels/train" "$MIX7030/images/train" "$MIX7030/labels/train"
sample_and_link "$SYNTH/images/train" "$SYNTH/labels/train" "$MIX7030/images/train" "$MIX7030/labels/train" 750
link_split "$REAL/images/val" "$REAL/labels/val" "$MIX7030/images/val" "$MIX7030/labels/val"
make_yaml "$MIX7030"
sample_and_link "$SYNTH/images/train" "$SYNTH/labels/train" "$MIX7030/images/train" "$MIX7030/labels/train" 750
link_split "$REAL/images/val" "$REAL/labels/val" "$MIX7030/images/val" "$MIX7030/labels/val"

